//
//  CGeometryData.h
//  RenderCollada
//
//  Created by killa on 1/22/15.
//  Copyright (c) 2015 lianliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVertexInfluence.h"

@interface CGeometryData : NSObject

@property (nonatomic) float *m_VerticesArray;//顶点数组
@property (nonatomic) float *m_SkinnedVerticesArray;
@property (nonatomic) float *m_NormalArray;//光线数组
@property (nonatomic) float *m_SkinnedNormalsArray;
@property (nonatomic) float *m_TextureCoordsArray;//贴图数组
@property (nonatomic) float *m_VertexWeightArray;//权重数组
@property (nonatomic) NSMutableArray *m_VertexInfulence;//CVertexInfluence

@property (nonatomic) unsigned int m_VerticesArraySize;
@property (nonatomic) unsigned int m_NormalsArraySizes;
@property (nonatomic) unsigned int m_TextureCoordsArraySize;
@property (nonatomic) unsigned int m_VertexWeightsArraySize;
@end
