//
//  CKeyframe.h
//  RenderCollada
//
//  Created by killa on 1/22/15.
//  Copyright (c) 2015 lianliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKeyframe : NSObject

@property (nonatomic) float m_Time;
@property (nonatomic) GLKMatrix4 m_transform;

@end
