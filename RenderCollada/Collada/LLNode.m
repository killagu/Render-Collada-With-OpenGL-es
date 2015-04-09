//
//  LLNode.m
//  RenderCollada
//
//  Created by 顾珠彬 on 4/8/15.
//  Copyright (c) 2015 lianliantech. All rights reserved.
//

#import "LLNode.h"

@implementation LLNode


- (void)setupSkeleton:(int) a_Frame
{
    NSMutableArray *bonesStack = [NSMutableArray array];
    [bonesStack addObject:@(self.m_SkeletonData.m_RootBone.m_ID)];
    while (0 != bonesStack.count) {
        NSInteger currentBoneID = [bonesStack.lastObject integerValue];
        [bonesStack removeObject:bonesStack.lastObject];
        CBone *currentBone = [self getCurrentBone:currentBoneID];
        GLKMatrix4 WorldMatrix = currentBone.m_JointMatrix;
        if (currentBone.m_NoOfKeyFrames > 0 && a_Frame < currentBone.m_Keyframes.count) {
            WorldMatrix = ((CKeyframe *)[currentBone.m_Keyframes objectAtIndex:a_Frame]).m_transform;
        }
        if (currentBone.m_ParentID != -1) {
            CBone *parentBone = [self getCurrentBone:currentBone.m_ParentID];
            WorldMatrix = GLKMatrix4Multiply(WorldMatrix, parentBone.m_WorldMatrix);
        }
        currentBone.m_WorldMatrix = WorldMatrix;
        currentBone.m_SkinningMatrix = GLKMatrix4Multiply(currentBone.m_InverseBindMatrix,WorldMatrix);
        if (currentBone.m_children.count != 0) {
            NSInteger noOfChildren = currentBone.m_ChildCount;
            for (NSInteger i = 0; i < noOfChildren; i++) {
                CBone *childrenBone = (CBone *)[currentBone.m_children objectAtIndex:i];
                [bonesStack addObject:@(childrenBone.m_ID)];
            }
        }
    }
}

- (void)setupBindPose
{
    if (self.m_GeometryData) {
        free(self.m_GeometryData.m_SkinnedVerticesArray);
        free(self.m_GeometryData.m_SkinnedNormalsArray);
    }
    self.m_GeometryData.m_SkinnedNormalsArray = malloc(sizeof(float) * self.m_GeometryData.m_NormalsArraySizes);
    self.m_GeometryData.m_SkinnedVerticesArray = malloc(sizeof(float) * self.m_GeometryData.m_VerticesArraySize);
    NSInteger numberOfVertices = self.m_GeometryData.m_VerticesArraySize / 3;
    for (NSUInteger currentVertex = 0; currentVertex < numberOfVertices; currentVertex++) {
        GLKVector3 tempVertex = GLKVector3Make(.0f, .0f, .0f);
        GLKVector3 tempNormal = GLKVector3Make(.0f, .0f, .0f);
        GLKVector3 tempNormalTransform = GLKVector3Make(.0f, .0f, .0f);
        
        GLKVector3 vertex = GLKVector3Make(self.m_GeometryData.m_VerticesArray[currentVertex * 3 + 0],
                                           self.m_GeometryData.m_VerticesArray[currentVertex * 3 + 1],
                                           self.m_GeometryData.m_VerticesArray[currentVertex * 3 + 2]);
        vertex = [self LianLianVector3:vertex MultiplyGLKMatrix4:self.m_SkeletonData.m_BindShapeMatrix];
        GLKVector3 normal = GLKVector3Make(self.m_GeometryData.m_NormalArray[currentVertex * 3 + 0],
                                           self.m_GeometryData.m_NormalArray[currentVertex * 3 + 1],
                                           self.m_GeometryData.m_NormalArray[currentVertex * 3 + 2]);
        float TotalJointsWeight = 0;
        float NormalizedWeight = 0;
        CVertexInfluence *currentVertexInfluence = ((CVertexInfluence *)[self.m_GeometryData.m_VertexInfulence objectAtIndex:currentVertex]);

        for (NSUInteger currentInfluence = 0; currentInfluence < currentVertexInfluence.m_NoOfInfulences; currentInfluence++) {
            CBone* currentInfluenceBone = [self getCurrentBone:currentVertexInfluence.m_Joints[currentInfluence]];
            GLKVector3 tempVertexToAdd = [self LianLianVector3:vertex MultiplyGLKMatrix4:currentInfluenceBone.m_SkinningMatrix];
            tempVertexToAdd = GLKVector3MultiplyScalar(tempVertexToAdd, currentVertexInfluence.m_Weights[currentInfluence]);
            tempVertex = GLKVector3Add(tempVertex, tempVertexToAdd);
            tempNormalTransform = matrixMutilpleVector3(currentInfluenceBone.m_SkinningMatrix, normal);
            tempNormal = GLKVector3Add(tempNormal, GLKVector3MultiplyScalar(tempNormalTransform, currentVertexInfluence.m_Weights[currentInfluence]));
            TotalJointsWeight += currentVertexInfluence.m_Weights[currentInfluence];
        }
        if (TotalJointsWeight != 1.0f) {
            NormalizedWeight = 1.0f / TotalJointsWeight;
            tempVertex = GLKVector3MultiplyScalar(tempVertex, NormalizedWeight);
            tempNormal = GLKVector3MultiplyScalar(tempNormal, NormalizedWeight);
        }
        self.m_GeometryData.m_SkinnedVerticesArray[currentVertex * 3 + 0] = tempVertex.x;
        self.m_GeometryData.m_SkinnedVerticesArray[currentVertex * 3 + 1] = tempVertex.y;
        self.m_GeometryData.m_SkinnedVerticesArray[currentVertex * 3 + 2] = tempVertex.z;
        
        self.m_GeometryData.m_SkinnedNormalsArray[currentVertex * 3 + 0] = tempNormal.x;
        self.m_GeometryData.m_SkinnedNormalsArray[currentVertex * 3 + 1] = tempNormal.y;
        self.m_GeometryData.m_SkinnedNormalsArray[currentVertex * 3 + 2] = tempNormal.z;
    }
}

- (CBone *)getCurrentBone:(NSInteger)boneId
{
    CBone *result = nil;
    for(CBone *bone in self.m_SkeletonData.m_Bones){
        if (bone.m_ID == boneId) {
            result = bone;
            break;
        }
    }
    return result;
}

- (GLKVector3) LianLianVector3: (GLKVector3) vectorLeft MultiplyGLKMatrix4:(GLKMatrix4) matrixRight
{
    GLKVector4 v4 = [self LianLianVector4:GLKVector4Make(vectorLeft.v[0], vectorLeft.v[1], vectorLeft.v[2], 0.0f) MultiplyGLKMatrix4:matrixRight];
    return GLKVector3Make(v4.v[0], v4.v[1], v4.v[2]);
}

- (GLKVector4) LianLianVector4:(GLKVector4) vectorLeft MultiplyGLKMatrix4:(GLKMatrix4) matrixRight
{
    GLKVector4 v = {
        matrixRight.m[0] * vectorLeft.v[0] + matrixRight.m[4] * vectorLeft.v[1] + matrixRight.m[8]  * vectorLeft.v[2] + matrixRight.m[12] * vectorLeft.v[3],
        matrixRight.m[1] * vectorLeft.v[0] + matrixRight.m[5] * vectorLeft.v[1] + matrixRight.m[9]  * vectorLeft.v[2] + matrixRight.m[13] * vectorLeft.v[3],
        matrixRight.m[2] * vectorLeft.v[0] + matrixRight.m[6] * vectorLeft.v[1] + matrixRight.m[10] * vectorLeft.v[2] + matrixRight.m[14] * vectorLeft.v[3],
        matrixRight.m[3] * vectorLeft.v[0] + matrixRight.m[7] * vectorLeft.v[1] + matrixRight.m[11] * vectorLeft.v[2] + matrixRight.m[15] * vectorLeft.v[3] };
    return v;
}

GLKVector3 matrixMutilpleVector3(GLKMatrix4 matrix,GLKVector3 vector)
{
    GLKVector3 result = GLKVector3Make(vector.x * matrix.m00 + vector.y * matrix.m01 + vector.z * matrix.m02,
                                       vector.x * matrix.m10 + vector.y * matrix.m11 + vector.z * matrix.m12,
                                       vector.x * matrix.m20 + vector.y * matrix.m21 + vector.z * matrix.m22);
    return result;
}



@end
