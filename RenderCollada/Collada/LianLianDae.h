//
//  LianLianDae.h
//  RenderCollada
//
//  Created by killa on 1/22/15.
//  Copyright (c) 2015 lianliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGeometryData.h"
#import "CSkeletonData.h"
#import "CTriangleGroup.h"
#import "LLNode.h"

typedef struct{
    GLKVector3 positionCoords;
    GLKVector3 normalCoords;
    GLKVector3 textureCoords;
}SceneVertex;

@interface LianLianDae : NSObject
{
    GLuint vertexBufferID;
}

@property (nonatomic) SceneVertex* vertexs;
@property (nonatomic) NSInteger vertexCount;
@property (nonatomic) NSMutableArray *nodes;

- (void)prepareToDraw;
- (void)setupSkeleton:(int) a_Frame;
@end
