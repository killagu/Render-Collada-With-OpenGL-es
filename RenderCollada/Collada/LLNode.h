//
//  LLNode.h
//  RenderCollada
//
//  Created by 顾珠彬 on 4/8/15.
//  Copyright (c) 2015 lianliantech. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LLNode : NSObject

@property (nonatomic) NSInteger vertexCount;
@property (nonatomic) CGeometryData *m_GeometryData;
@property (nonatomic) CSkeletonData *m_SkeletonData;
@property (nonatomic) CTriangleGroup *m_TriangleGroup;
@property (nonatomic) NSInteger triangleCount;

- (void)setupSkeleton:(int) a_Frame;
- (void)setupBindPose;
@end
