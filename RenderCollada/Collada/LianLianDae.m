//
//  LianLianDae.m
//  RenderCollada
//
//  Created by killa on 1/22/15.
//  Copyright (c) 2015 lianliantech. All rights reserved.
//

#import "LianLianDae.h"

@implementation LianLianDae
- (void)prepareToDraw
{
    if(self.vertexs){
        free(self.vertexs);
    }
    self.vertexs = malloc(sizeof(SceneVertex) * self.vertexCount);
    NSInteger triangleAllIndex = 0;
    for (NSInteger nodeIndex = 0; nodeIndex < self.nodes.count; nodeIndex++) {
        LLNode *node = [_nodes objectAtIndex:nodeIndex];
        float *verticesArray = node.m_GeometryData.m_SkinnedVerticesArray;
        if (verticesArray == NULL) {
            verticesArray = node.m_GeometryData.m_VerticesArray;
        }
        float *normalArray = node.m_GeometryData.m_NormalArray;
        for (NSInteger triangleIndex = 0; triangleIndex < node.triangleCount; triangleIndex++) {
            int vertex0Index = node.m_TriangleGroup[triangleIndex].m_Triangle.m_VerticesIndex[0];
            int vertex1Index = node.m_TriangleGroup[triangleIndex].m_Triangle.m_VerticesIndex[1];
            int vertex2Index = node.m_TriangleGroup[triangleIndex].m_Triangle.m_VerticesIndex[2];
            
            int normal0Index = node.m_TriangleGroup[triangleIndex].m_Triangle.m_NormalsIndex[0];
            int normal1Index = node.m_TriangleGroup[triangleIndex].m_Triangle.m_NormalsIndex[1];
            int normal2Index = node.m_TriangleGroup[triangleIndex].m_Triangle.m_NormalsIndex[2];
            
            _vertexs[triangleAllIndex * 3 + 0].positionCoords = GLKVector3Make(
                                                                           verticesArray[vertex0Index * 3 + 0],
                                                                           verticesArray[vertex0Index * 3 + 1],
                                                                           verticesArray[vertex0Index * 3 + 2]
                                                                           );
            _vertexs[triangleAllIndex * 3 + 1].positionCoords = GLKVector3Make(
                                                                           verticesArray[vertex1Index * 3 + 0],
                                                                           verticesArray[vertex1Index * 3 + 1],
                                                                           verticesArray[vertex1Index * 3 + 2]
                                                                           );
            _vertexs[triangleAllIndex * 3 + 2].positionCoords = GLKVector3Make(
                                                                           verticesArray[vertex2Index * 3 + 0],
                                                                           verticesArray[vertex2Index * 3 + 1],
                                                                           verticesArray[vertex2Index * 3 + 2]
                                                                           );
            _vertexs[triangleAllIndex * 3 + 0].normalCoords = GLKVector3Make(
                                                                         normalArray[normal0Index * 3 + 0],
                                                                         normalArray[normal0Index * 3 + 1],
                                                                         normalArray[normal0Index * 3 + 2]
                                                                         );
            _vertexs[triangleAllIndex * 3 + 1].normalCoords = GLKVector3Make(
                                                                         normalArray[normal1Index * 3 + 0],
                                                                         normalArray[normal1Index * 3 + 1],
                                                                         normalArray[normal1Index * 3 + 2]
                                                                         );
            _vertexs[triangleAllIndex * 3 + 2].normalCoords = GLKVector3Make(
                                                                         normalArray[normal2Index * 3 + 0],
                                                                         normalArray[normal2Index * 3 + 1],
                                                                         normalArray[normal2Index * 3 + 2]
                                                                         );
            triangleAllIndex++;
        }
    }
}

- (void)setupSkeleton:(int) a_Frame
{
    for (NSInteger nodeIndex = 0; nodeIndex < self.nodes.count; nodeIndex++) {
        LLNode *node = [_nodes objectAtIndex:nodeIndex];
        [node setupSkeleton:a_Frame];
        [node setupBindPose];
    }
}

@end
