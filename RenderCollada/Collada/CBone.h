//
//  CBone.h
//  RenderCollada
//
//  Created by killa on 1/22/15.
//  Copyright (c) 2015 lianliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKeyframe.h"

@interface CBone : NSObject
@property (nonatomic) int m_ID;
@property (nonatomic) int m_ParentID;

@property (nonatomic) GLKMatrix4 m_JointMatrix; //关节矩阵 在scene中
@property (nonatomic) GLKMatrix4 m_InverseBindMatrix;//反向绑定矩阵 在controller中
@property (nonatomic) GLKMatrix4 m_WorldMatrix;
@property (nonatomic) GLKMatrix4 m_SkinningMatrix;
@property (nonatomic) unsigned int m_ChildCount;
@property (nonatomic) NSMutableArray *m_children;
@property (nonatomic) unsigned int m_NoOfKeyFrames;
@property (nonatomic) NSArray *m_Keyframes;
@property (nonatomic) NSString *boneName;
@end
