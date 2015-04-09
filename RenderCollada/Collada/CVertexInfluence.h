//
//  CVertexInfluence.h
//  RenderCollada
//
//  Created by killa on 1/22/15.
//  Copyright (c) 2015 lianliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSkeletonData.h"

@interface CVertexInfluence : NSObject
@property (nonatomic) int m_NoOfInfulences;
@property (nonatomic) float *m_Weights;
@property (nonatomic) int *m_Joints;
@property (nonatomic) CSkeletonData *m_SkeletonData;
@end
