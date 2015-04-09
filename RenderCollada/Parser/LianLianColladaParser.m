//
//  RRCJointAndAnimationParser.m
//  RRCModelViewer
//
//  Created by killa on 1/11/15.
//  Copyright (c) 2015 RendonCepeda. All rights reserved.
//

#import "LianLianColladaParser.h"
#import "LLNode.h"

enum ColladaXML{
    ColladaXMLMesh = 1,
    ColladaXMLAnimation,
    ColladaXMLNode,
    ColladaXMLController
};


@interface LianLianColladaParser()

@property (nonatomic) NSMutableString *elementString;
@property (nonatomic) enum ColladaXML status;

@end

@implementation LianLianColladaParser

@synthesize elementString;
@synthesize status;
@synthesize dicMesh;
@synthesize dicAllMesh;
@synthesize dicSource;
@synthesize dicSources;
@synthesize dicFloatArray;
@synthesize dicVertices;
@synthesize dicTriangles;
@synthesize dicInputs;
@synthesize dicP;
@synthesize dae;
@synthesize currentBone;
@synthesize dicBones;
@synthesize parentBone;
@synthesize bones;
@synthesize currentBoneID;
@synthesize dicController;
@synthesize dicSkin;
@synthesize dicJoints;
@synthesize dicVertexWeight;
@synthesize dicControllers;
@synthesize dicAnimation;
@synthesize dicSampler;
@synthesize animations;

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (nil == elementString) {
        elementString = [[NSMutableString alloc] init];
    }
    [elementString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([@"geometry" isEqualToString:elementName]) {
        status = ColladaXMLMesh;
        if (nil == dicMesh) {
            dicMesh = [NSMutableDictionary dictionary];
        }
        [dicMesh setObject:[attributeDict objectForKey:@"id"] forKey:@"id"];
        [dicMesh setObject:[attributeDict objectForKey:@"name"] forKey:@"name"];
    }
    else if ([@"source" isEqualToString:elementName]){
        if (ColladaXMLMesh == status || ColladaXMLController == status || ColladaXMLAnimation == status) {
            if (nil == dicSources) {
                dicSources = [NSMutableDictionary dictionary];
            }
            if (nil == dicSource) {
                dicSource = [NSMutableDictionary dictionary];
            }
            [dicSources setObject:dicSource forKey:[attributeDict objectForKey:@"id"]];
        }
    }
    else if ([@"float_array"  isEqualToString:elementName] || [elementName isEqualToString:@"Name_array"]){
        if (ColladaXMLMesh == status || ColladaXMLController == status || ColladaXMLAnimation == status) {
            if (nil == dicFloatArray) {
                dicFloatArray = [NSMutableDictionary dictionary];
            }
            [dicFloatArray setObject:[attributeDict objectForKey:@"count"] forKey:@"count"];
        }
    }
    else if ([@"vertices" isEqualToString:elementName]){
        if (status == ColladaXMLMesh) {
            if (nil == dicVertices) {
                dicVertices = [NSMutableDictionary dictionary];
            }
            [dicVertices setObject:[attributeDict objectForKey:@"id"] forKey:@"id"];
        }
    }
    else if ([@"input" isEqualToString:elementName]){
        if(nil == dicInputs){
            dicInputs = [NSMutableDictionary dictionary];
        }
        [dicInputs setObject:[attributeDict objectForKey:@"source"] forKey:[attributeDict objectForKey:@"semantic"]];
    }
    else if ([@"triangles" isEqualToString:elementName]){
        if (nil == dicTriangles) {
            dicTriangles = [NSMutableDictionary dictionary];
        }
        [dicTriangles setObject:[attributeDict objectForKey:@"count"] forKey:@"count"];
        [dicTriangles setObject:[attributeDict objectForKey:@"material"] forKey:@"material"];
    }
    else if ([@"p" isEqualToString:elementName]){
        if (nil == dicP) {
            dicP = [NSMutableDictionary dictionary];
        }
    }
    else if ([@"node" isEqualToString:elementName]){
        currentBone = [CBone new];
        [currentBone setM_ID:(int)currentBoneID];
        currentBone.boneName = [attributeDict objectForKey:@"name"];
        if (nil == parentBone) {
            [currentBone setM_ParentID:-1];
            [dicBones setObject:currentBone forKey:[attributeDict objectForKey:@"name"]];
        }
        else {
            [currentBone setM_ParentID:parentBone.m_ID];
            if (nil == parentBone.m_children) {
                parentBone.m_children = [NSMutableArray array];
                parentBone.m_ChildCount = 0;
            }
            parentBone.m_ChildCount ++;
            [parentBone.m_children addObject:currentBone];
        }
        [bones addObject:currentBone];
        currentBoneID ++;
        parentBone = currentBone;
        status = ColladaXMLNode;
    }
    else if ([@"controller" isEqualToString:elementName]){
        if (nil == dicController) {
            dicController = [NSMutableDictionary dictionary];
        }
        [dicController setObject:[attributeDict objectForKey:@"id"] forKey:@"id"];
        status = ColladaXMLController;
    }
    else if ([@"skin" isEqualToString:elementName]){
        if (nil == dicSkin) {
            dicSkin = [NSMutableDictionary dictionary];
        }
        [dicSkin setObject:[attributeDict objectForKey:@"source"] forKey:@"source"];
    }
    else if ([@"joints" isEqualToString:elementName]){
        if (nil == dicJoints) {
            dicJoints = [NSMutableDictionary dictionary];
        }
    }
    else if ([@"vertex_weights" isEqualToString:elementName]){
        if (nil == dicVertexWeight) {
            dicVertexWeight = [NSMutableDictionary dictionary];
        }
        [dicVertexWeight setObject:[attributeDict objectForKey:@"count"] forKey:@"count"];
    }
    else if ([@"library_animations" isEqualToString:elementName]){
        status = ColladaXMLAnimation;
    }
    else if ([@"animation" isEqualToString:elementName]){
        if (nil == dicAnimation) {
            dicAnimation = [NSMutableDictionary dictionary];
        }
        if (nil != [attributeDict objectForKey:@"name"]) {
            [dicAnimation setValue:[attributeDict objectForKey:@"name"] forKey:@"name"];
            [dicAnimation setValue:[attributeDict objectForKey:@"id"] forKey:@"id"];
        }
    }
    else if ([@"sampler" isEqualToString:elementName]){
        if (nil == dicSampler) {
            dicSampler = [NSMutableDictionary dictionary];
        }
        [dicSampler setObject:[attributeDict objectForKey:@"id"] forKey:@"id"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([@"geometry" isEqualToString:elementName]) {
        [dicMesh setObject:dicSources forKey:@"sources"];
        dicSources = nil;
        [dicMesh setObject:dicVertices forKey:@"vertices"];
        dicVertices = nil;
        [dicMesh setObject:dicTriangles forKey:@"triangles"];
        dicTriangles = nil;
        [dicAllMesh setObject:dicMesh forKey:[dicMesh objectForKey:@"id"]];
        dicMesh = nil;
        status = 0;
    }
    else if ([@"source" isEqualToString:elementName]){
        if (ColladaXMLMesh == status || ColladaXMLController == status || ColladaXMLAnimation == status) {
            [dicSource setObject:[dicFloatArray objectForKey:@"count"] forKey:@"count"];
            [dicSource setObject:[dicFloatArray objectForKey:@"floatArray"] forKey:@"floatArray"];
            dicFloatArray = nil;
            dicSource = nil;
        }
    }
    else if ([@"float_array" isEqualToString:elementName] || [@"Name_array" isEqualToString:elementName]){
        if (ColladaXMLMesh == status || ColladaXMLController == status || ColladaXMLAnimation == status) {
            [dicFloatArray setObject:elementString forKey:@"floatArray"];
        }
    }
    else if ([elementName isEqualToString:@"vertices"]){
        if (ColladaXMLMesh == status) {
            for(NSString *key in dicInputs.allKeys){
                [dicVertices setObject:[dicInputs objectForKey:key] forKey:key];
            }
            dicInputs = nil;
        }
    }
    else if ([@"triangles" isEqualToString:elementName]){
        for(NSString *key in dicInputs.allKeys){
            [dicTriangles setObject:[dicInputs objectForKey:key] forKey:key];
        }
        dicInputs = nil;
        if (nil != [dicP objectForKey:@"p"]) {
            [dicTriangles setObject:[dicP objectForKey:@"p"] forKey:@"p"];
        }
        
        dicP = nil;
    }
    else if ([@"p" isEqualToString:elementName]){
        if (elementString) {
            [dicP setObject:elementString forKey:@"p"];
        }
    }
    else if ([@"node" isEqualToString:elementName]){
        currentBone = nil;
        if (nil != parentBone) {
            parentBone = [self searchBone:parentBone.m_ParentID];
        }
    }
    else if ([@"matrix" isEqualToString:elementName]){
        if (ColladaXMLNode == status) {
            NSArray *arrayMatrixValue = [self getArrayFromStr:elementString];
            [currentBone setM_JointMatrix:*[self getMatrixFromString:arrayMatrixValue]];
        }
    }
    else if ([@"bind_shape_matrix" isEqualToString:elementName]){
        NSArray *arrayMatrixValue = [self getArrayFromStr:elementString];
        self.bindShapeMatrix = *[self getMatrixFromString:arrayMatrixValue];
    }
    else if ([@"joints" isEqualToString:elementName]){
        for(NSString *key in dicInputs.allKeys){
            [dicJoints setObject:[dicInputs objectForKey:key] forKey:key];
        }
        dicInputs = nil;
    }
    else if ([@"vcount" isEqualToString:elementName]){
        [dicVertexWeight setObject:elementString forKey:@"vcount"];
    }
    else if ([@"v" isEqualToString:elementName]){
        [dicVertexWeight setObject:elementString forKey:@"v"];
    }
    else if ([@"vertex_weights" isEqualToString:elementName]){
        for(NSString *key in dicInputs.allKeys){
            [dicVertexWeight setObject:[dicInputs objectForKey:key] forKey:key];
        }
        dicInputs = nil;
    }
    else if ([@"skin" isEqualToString:elementName]){
        [dicSkin setObject:dicVertexWeight forKey:@"vertex_weight"];
        dicVertexWeight = nil;
        [dicSkin setObject:dicSources forKey:@"sources"];
        dicSources = nil;
        [dicSkin setObject:dicJoints forKey:@"joints"];
        dicJoints = nil;
    }
    else if ([@"controller" isEqualToString:elementName]){
        [dicController setObject:dicSkin forKey:@"skin"];
        dicSkin = nil;
        [dicControllers setObject:dicController forKey:[dicController objectForKey:@"id"]];
        dicController = nil;
        status = 0;
    }
    else if ([@"library_animations" isEqualToString:elementName]){
        status = 0;
    }
    else if ([@"sampler" isEqualToString:elementName]){
        for(NSString *key in dicInputs.allKeys){
            [dicSampler setObject:[dicInputs objectForKey:key] forKey:key];
        }
        dicInputs = nil;
    }
    else if ([@"animation" isEqualToString:elementName]){
        if (nil != dicAnimation) {
            [dicAnimation setObject:dicSources forKey:@"sources"];
            dicSources = nil;
            [dicAnimation setObject:dicSampler forKey:@"sampler"];
            dicSampler = nil;
            [animations addObject:dicAnimation];
            dicAnimation = nil;
        }
    }
    elementString = nil;
}

- (CBone *)searchBone:(int) boneID
{
    CBone *bone = nil;
    for(CBone *tempBone in bones){
        if (boneID == tempBone.m_ID) {
            bone = tempBone;
        }
    }
    return bone;
}

- (CBone *)searchBoneByName:(NSString *)boneName
{
    CBone *bone = nil;
    for(CBone *tempBone in bones){
        if ([tempBone.boneName isEqualToString:boneName]) {
            bone = tempBone;
            break;
        }
    }
    return bone;
}

- (void)parserxml
{
    NSData* xmlData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"01011" withExtension:@"xml"]];
    if(xmlData)
    {
        NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
        xmlParser.delegate = self;
        dicAllMesh = [NSMutableDictionary dictionary];
        dicSources = [NSMutableDictionary dictionary];
        dicBones = [NSMutableDictionary dictionary];
        dicControllers = [NSMutableDictionary dictionary];
        bones = [NSMutableArray array];
        dae = [LianLianDae new];
        dae.nodes = [NSMutableArray array];
        animations = [NSMutableArray array];
        currentBoneID = 0;
        if([xmlParser parse])
        {
            for (NSString *key in dicAllMesh.allKeys){
                if (key != [dicAllMesh.allKeys lastObject]) {
                    continue;
                }
                //TODO convert geometry
                LLNode *llNode = [LLNode new];
                [self convertPositionAndNormal:llNode Key:key];
                
                //TODO convert controllers
                NSDictionary *tempController = [dicControllers objectForKey:[dicControllers.allKeys lastObject]];
                CSkeletonData *skeletonData = [CSkeletonData new];
                skeletonData.m_BindShapeMatrix = self.bindShapeMatrix;
                
                NSDictionary *dicTempSkin = [tempController objectForKey:@"skin"];
                NSDictionary *dicTempScources = [dicTempSkin objectForKey:@"sources"];
                NSDictionary *dicTempVertexWeith = [dicTempSkin objectForKey:@"vertex_weight"];
                NSDictionary *dicTempJoints = [dicTempSkin objectForKey:@"joints"];
                NSString *inverseBindMatrix = [[dicTempJoints objectForKey:@"INV_BIND_MATRIX"] substringFromIndex:1];
                NSString *jointName = [[dicTempVertexWeith objectForKey:@"JOINT"] substringFromIndex:1];
                NSString *weightName = [[dicTempVertexWeith objectForKey:@"WEIGHT"] substringFromIndex:1];
                
                NSDictionary *dicTempResultJoints = [dicTempScources objectForKey:jointName];
                NSDictionary *dicTempResultInverseBindMatrix = [dicTempScources objectForKey:inverseBindMatrix];
                NSDictionary *dicTempReusltWeights = [dicTempScources objectForKey:weightName];
                NSString *dicTempV = [dicTempVertexWeith objectForKey:@"v"];
                NSString *dicTempVCount = [dicTempVertexWeith objectForKey:@"vcount"];
                NSMutableArray *tempBoneArray = [NSMutableArray array];
                
                NSArray *sourceJoints = [self getArrayFromStr:[dicTempResultJoints objectForKey:@"floatArray"]];
                NSArray *sourceInverseBindMatrix = [self getArrayFromStr:[dicTempResultInverseBindMatrix objectForKey:@"floatArray"]];
                NSArray *sourceResultWeights = [self getArrayFromStr:[dicTempReusltWeights objectForKey:@"floatArray"]];
                NSArray *sourceV = [self getArrayFromStr:dicTempV];
                NSArray *sourceVCount = [self getArrayFromStr:dicTempVCount];
                
                
                GLKMatrix4* inverserBindMatrixs = [self getMatrixFromString:sourceInverseBindMatrix];
                for (NSUInteger jointIndex = 0; jointIndex < bones.count; jointIndex ++) {
                    CBone *tempBone = [bones objectAtIndex:jointIndex];
                    for (NSUInteger sourceJointIndex = 0; sourceJointIndex < sourceJoints.count; sourceJointIndex++) {
                        NSString *tempJointName = [sourceJoints objectAtIndex:sourceJointIndex];
                        if ([tempBone.boneName isEqualToString:tempJointName]) {
                            for (NSUInteger childJointIndex = 0; childJointIndex < bones.count; childJointIndex ++) {
                                CBone *childBone = [bones objectAtIndex:childJointIndex];
                                if (childBone.m_ParentID == tempBone.m_ID) {
                                    childBone.m_ParentID = (int)sourceJointIndex;
                                }
                            }
                            tempBone.m_ID = (int)sourceJointIndex;
                            [tempBoneArray addObject:tempBone];
                        }
                    }
                }
                for (NSUInteger jointIndex = 0; jointIndex < bones.count; jointIndex ++) {
                    CBone *tempBone = [bones objectAtIndex:jointIndex];
                    [self changeBonesParendID:tempBone];
                }
                for (NSUInteger jointIndex = 0; jointIndex < sourceJoints.count; jointIndex++) {
                    CBone *tempBone = [self searchBone:(int)jointIndex];
                    tempBone.m_InverseBindMatrix = inverserBindMatrixs[tempBone.m_ID];
                    if (tempBone.m_ParentID == -1) {
                        skeletonData.m_RootBone = tempBone;
                    }
                }
                skeletonData.m_Bones = tempBoneArray;
                skeletonData.m_NoOfBones = (int)tempBoneArray.count;
                llNode.m_SkeletonData = skeletonData;
                
                
                //convert vertex joint weight
                NSInteger vIndex = 0;
                NSMutableArray *influences = [NSMutableArray array];
                for (NSUInteger vcountIndex = 0; vcountIndex < sourceVCount.count; vcountIndex++) {
                    NSInteger vcount = [[sourceVCount objectAtIndex:vcountIndex] integerValue];
                    CVertexInfluence *tempVertexInfluence = [CVertexInfluence new];
                    tempVertexInfluence.m_Joints = malloc(sizeof(int) * vcount);
                    tempVertexInfluence.m_Weights = malloc(sizeof(int) * vcount);
                    tempVertexInfluence.m_NoOfInfulences = (int)vcount;
                    for (NSUInteger tempVIndex = vIndex; tempVIndex < vIndex + 2 * vcount; tempVIndex = tempVIndex + 2) {
                        tempVertexInfluence.m_Joints[(tempVIndex - vIndex) / 2] = (int)[[sourceV objectAtIndex:tempVIndex] integerValue];
                        tempVertexInfluence.m_Weights[(tempVIndex - vIndex) / 2] =
                        (float)[[sourceResultWeights objectAtIndex:[[sourceV objectAtIndex:tempVIndex + 1] integerValue] ] floatValue];
                    }
                    vIndex += 2 * vcount;
                    [influences addObject:tempVertexInfluence];
                }
                
                llNode.m_GeometryData.m_VertexInfulence = influences;
                
                
                //convert animation
                for(NSDictionary *dicTempAnimation in animations){
                    NSDictionary *dicTempSampler = [dicTempAnimation objectForKey:@"sampler"];
                    NSString *inputName = [[dicTempSampler objectForKey:@"INPUT"] substringFromIndex:1];
                    NSString *outPutName = [[dicTempSampler objectForKey:@"OUTPUT"] substringFromIndex:1];
                    NSDictionary *tempSources = [dicTempAnimation objectForKey:@"sources"];
                    NSDictionary *sourceInput = [tempSources objectForKey:inputName];
                    NSDictionary *sourceOutPut = [tempSources objectForKey:outPutName];
                    CBone *tempBone = [self searchBoneByName:[dicTempAnimation objectForKey:@"name"]];
                    NSArray *resultInput = [self getArrayFromStr:[sourceInput objectForKey:@"floatArray"]];
                    NSArray *resultOutPut = [self getArrayFromStr:[sourceOutPut objectForKey:@"floatArray"]];
                    GLKMatrix4 *frames = [self getMatrixFromString:resultOutPut];
                    NSMutableArray *frameArray = [NSMutableArray array];
                    for (NSUInteger frameIndex = 0; frameIndex < resultInput.count; frameIndex ++) {
                        CKeyframe *frame = [CKeyframe new];
                        frame.m_Time = [[resultInput objectAtIndex:frameIndex] floatValue];
                        frame.m_transform = frames[frameIndex];
                        [frameArray addObject:frame];
                    }
                    tempBone.m_NoOfKeyFrames = (int)resultInput.count;
                    tempBone.m_Keyframes = frameArray;
                }
            }
        }
    }
}

- (void)convertPositionAndNormal:(LLNode *)llNode Key:(NSString *)key
{
    NSDictionary *dicGeometry = [dicAllMesh objectForKey:key];
    NSDictionary *dicTempTriangles = [dicGeometry objectForKey:@"triangles"];
    NSDictionary *dicTempSources = [dicGeometry objectForKey:@"sources"];
    NSDictionary *dicPosition = [dicTempSources objectForKey:[[[dicGeometry objectForKey:@"vertices"] objectForKey:@"POSITION"] substringFromIndex:1]];
    
    NSDictionary *dicNormal = [dicTempSources objectForKey:[[dicTempTriangles objectForKey:@"NORMAL"] substringFromIndex:1]];
    NSDictionary *dicTexture = [dicTempSources objectForKey:[[dicTempTriangles objectForKey:@"TEXCOORD"] substringFromIndex:1]];
    CGeometryData* geometry = [CGeometryData new];
    
    NSInteger vertexCount = [[dicPosition objectForKey:@"count"] integerValue];
    geometry.m_VerticesArray = [self getCoordFromString:[dicPosition objectForKey:@"floatArray"] count:vertexCount stride:3];
    geometry.m_VerticesArraySize = (unsigned int)vertexCount;
    
    NSInteger normalCount = [[dicNormal objectForKey:@"count"] integerValue];
    geometry.m_NormalArray = [self getCoordFromString:[dicNormal objectForKey:@"floatArray"] count:normalCount stride:3];
    geometry.m_NormalsArraySizes = (unsigned int)normalCount;
    
    NSInteger texCoordCount = [[dicTexture objectForKey:@"count"] integerValue];
    geometry.m_TextureCoordsArray = [self getCoordFromString:[dicTexture objectForKey:@"floatArray"] count:texCoordCount stride:2];
    geometry.m_TextureCoordsArraySize = (unsigned int)texCoordCount;
    
    llNode.m_GeometryData = geometry;
    
    //TODO convert triangle
    NSInteger triangleCount = [[dicTempTriangles objectForKey:@"count"] integerValue];
    CTriangleGroup *triangleGroup = [self getTriangleFromString:[dicTempTriangles objectForKey:@"p"]];
    llNode.m_TriangleGroup = triangleGroup;
    llNode.triangleCount = triangleCount;
    llNode.vertexCount = triangleCount * 3;
    [dae.nodes addObject:llNode];
    dae.vertexCount += llNode.vertexCount;
}

- (NSArray *)getArrayFromStr:(NSString *)resource
{
    NSArray* tempResultConvertWithN = [resource componentsSeparatedByString:@"\n"];
    NSMutableArray* tempResult = [NSMutableArray array];
    for (NSString* strTemp in tempResultConvertWithN) {
        [tempResult addObjectsFromArray:[strTemp componentsSeparatedByString:@" "]];
    }
    NSMutableArray* tempResultConvertWithOutTrim = [NSMutableArray array];
    for (NSInteger i = 0; i < tempResult.count; i++) {
        NSString* temp = [tempResult objectAtIndex:i];
        if (![temp isEqualToString:@""]) {
            [tempResultConvertWithOutTrim addObject:temp];
        }
    }
    return tempResultConvertWithOutTrim;
}

- (void)changeBonesParendID:(CBone *)tempParentBone
{
    for(CBone *childBone in tempParentBone.m_children){
        childBone.m_ParentID = tempParentBone.m_ID;
        [self changeBonesParendID:childBone];
    }
}

- (GLKMatrix4 *)getMatrixFromString:(NSArray *)resource
{
    
    GLKMatrix4 *matrixs = malloc(sizeof(GLKMatrix4) * (resource.count / 16));
    for (int i = 0; i < resource.count; i = i + 16) {
        if (resource.count - i < 16) {
            break;
        }
        matrixs[i / 16] = GLKMatrix4Make(
                                         [[resource objectAtIndex:i] floatValue],
                                         [[resource objectAtIndex:i + 1] floatValue],
                                         [[resource objectAtIndex:i + 2] floatValue],
                                         [[resource objectAtIndex:i + 3] floatValue],
                                         [[resource objectAtIndex:i + 4] floatValue],
                                         [[resource objectAtIndex:i + 5] floatValue],
                                         [[resource objectAtIndex:i + 6] floatValue],
                                         [[resource objectAtIndex:i + 7] floatValue],
                                         [[resource objectAtIndex:i + 8] floatValue],
                                         [[resource objectAtIndex:i + 9] floatValue],
                                         [[resource objectAtIndex:i + 10] floatValue],
                                         [[resource objectAtIndex:i + 11] floatValue],
                                         [[resource objectAtIndex:i + 12] floatValue],
                                         [[resource objectAtIndex:i + 13] floatValue],
                                         [[resource objectAtIndex:i + 14] floatValue],
                                         [[resource objectAtIndex:i + 15] floatValue]
                                         );
    }
    return matrixs;
}

- (float *)getCoordFromString:(NSString *)resource count:(NSInteger) count stride:(NSInteger)stride
{
    NSArray *arr = [self getArrayFromStr:resource];
    float* des = malloc(sizeof(float) * count);
    for (NSUInteger i = 0 ; i < count; i++) {
        des[i] = [[arr objectAtIndex:i] floatValue];
    }
    return des;
}

- (float *)getCoordFromString:(NSString *)resource count:(NSInteger) count stride:(NSInteger)stride Bind:(GLKMatrix4)bsm
{
    NSArray *arr = [self getArrayFromStr:resource];
    float* des = malloc(sizeof(float) * count);

    for (NSUInteger i = 0 ; i < count / 3; i++) {
//        des[i] = [[arr objectAtIndex:i] floatValue];
        GLKVector4 vector = {
                            [[arr objectAtIndex:i] floatValue],
                            [[arr objectAtIndex:i + 1] floatValue],
                            [[arr objectAtIndex:i + 2] floatValue],
                                1};
        GLKVector4 vector2 = {
            vector.x * bsm.m00 + vector.y * bsm.m00 + vector.y * bsm.m00 + vector.w * bsm.m03,
            vector.x * bsm.m10 + vector.y * bsm.m11 + vector.y * bsm.m12 + vector.w * bsm.m13,
            vector.x * bsm.m00 + vector.y * bsm.m21 + vector.y * bsm.m22 + vector.w * bsm.m23,
            vector.x * bsm.m00 + vector.y * bsm.m31 + vector.y * bsm.m32 + vector.w * bsm.m33,
        };
        des[i * 3 + 0] = vector2.x;
        des[i * 3 + 2] = vector2.y;
        des[i * 3 + 3] = vector2.z;
    }
    return des;
}


- (CTriangleGroup*)getTriangleFromString:(NSString *)resource
{
    NSArray *arr = [self getArrayFromStr:resource];
    NSInteger triangleCount = arr.count / 9;
    CTriangleGroup *group = malloc(sizeof(CTriangleGroup) * triangleCount);
    for (NSUInteger triangleIndex = 0; triangleIndex < triangleCount; triangleIndex++) {
        group[triangleIndex].m_Triangle.m_VerticesIndex[0] = [[arr objectAtIndex:triangleIndex * 9 + 0] integerValue];
        group[triangleIndex].m_Triangle.m_NormalsIndex[0]  = [[arr objectAtIndex:triangleIndex * 9 + 1] integerValue];
        group[triangleIndex].m_Triangle.m_TexturesIndex[0] = [[arr objectAtIndex:triangleIndex * 9 + 2] integerValue];
        group[triangleIndex].m_Triangle.m_VerticesIndex[1] = [[arr objectAtIndex:triangleIndex * 9 + 3] integerValue];
        group[triangleIndex].m_Triangle.m_NormalsIndex[1]  = [[arr objectAtIndex:triangleIndex * 9 + 4] integerValue];
        group[triangleIndex].m_Triangle.m_TexturesIndex[1] = [[arr objectAtIndex:triangleIndex * 9 + 5] integerValue];
        group[triangleIndex].m_Triangle.m_VerticesIndex[2] = [[arr objectAtIndex:triangleIndex * 9 + 6] integerValue];
        group[triangleIndex].m_Triangle.m_NormalsIndex[2]  = [[arr objectAtIndex:triangleIndex * 9 + 7] integerValue];
        group[triangleIndex].m_Triangle.m_TexturesIndex[2] = [[arr objectAtIndex:triangleIndex * 9 + 8] integerValue];
    }
    return group;
}

- (GLKVector3 *)getVector3FromString:(NSArray *)resource
{
    GLKVector3 *vectors = malloc(sizeof(GLKVector3) * resource.count / 3);
    for (int i = 0; i < resource.count - 3; i = i + 3) {
        vectors[i / 3] = GLKVector3Make([[resource objectAtIndex:i + 0] floatValue],
                                    [[resource objectAtIndex:i + 1] floatValue],
                                    [[resource objectAtIndex:i + 2] floatValue]);
    }
    return vectors;
}

- (GLKVector2 *)getVector2FromString:(NSArray *)resource
{
    GLKVector2 *vectors = malloc(sizeof(GLKVector2) * resource.count / 2);
    for (int i = 0; i < resource.count - 2; i = i + 2) {
        vectors[i / 2] = GLKVector2Make([[resource objectAtIndex:i + 0] floatValue],
                                    [[resource objectAtIndex:i + 1] floatValue]);
    }
    return vectors;
}
@end
