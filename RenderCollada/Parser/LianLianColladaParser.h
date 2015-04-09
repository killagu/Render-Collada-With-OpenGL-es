//
//  RRCJointAndAnimationParser.h
//  RRCModelViewer
//
//  Created by killa on 1/11/15.
//  Copyright (c) 2015 RendonCepeda. All rights reserved.
//



@interface LianLianColladaParser : NSObject <NSXMLParserDelegate>
@property (nonatomic) NSString *xmlPath;
@property (nonatomic) NSMutableDictionary *dicMesh;
@property (nonatomic) NSMutableDictionary *dicAllMesh;
@property (nonatomic) NSMutableDictionary *dicSources;
@property (nonatomic) NSMutableDictionary *dicSource;
@property (nonatomic) NSMutableDictionary *dicFloatArray;
@property (nonatomic) NSMutableDictionary *dicVertices;
@property (nonatomic) NSMutableDictionary *dicTriangles;
@property (nonatomic) NSMutableDictionary *dicInputs;
@property (nonatomic) NSMutableDictionary *dicP;

@property (nonatomic) CSkeletonData *skeletonData;
@property (nonatomic) NSMutableDictionary *dicBones;
@property (nonatomic) CBone *currentBone;
@property (nonatomic) CBone *parentBone;
@property (nonatomic) NSMutableArray *bones;
@property (nonatomic) LianLianDae *dae;
@property (nonatomic) NSInteger currentBoneID;

@property (nonatomic) NSMutableDictionary *dicController;
@property (nonatomic) NSMutableDictionary *dicControllers;
@property (nonatomic) NSMutableDictionary *dicSkin;
@property (nonatomic) GLKMatrix4 bindShapeMatrix;
@property (nonatomic) NSMutableDictionary *dicJoints;

@property (nonatomic) NSMutableArray *animations;
@property (nonatomic) NSMutableDictionary *dicAnimation;
@property (nonatomic) NSMutableDictionary *dicVertexWeight;
@property (nonatomic) NSMutableDictionary *dicSampler;
- (void)parserxml;

@end
