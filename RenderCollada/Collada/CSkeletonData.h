//
//  CSkeletonData.h
//  RenderCollada
//
//  Created by killa on 1/22/15.
//  Copyright (c) 2015 lianliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBone.h"

@interface CSkeletonData : NSObject
@property (nonatomic) unsigned int m_NoOfBones;
@property (nonatomic) unsigned int m_NoOfKeyframes;
@property (nonatomic) GLKMatrix4 m_BindShapeMatrix;
@property (nonatomic) NSArray *m_Bones;
@property (nonatomic) CBone *m_RootBone;
@end
