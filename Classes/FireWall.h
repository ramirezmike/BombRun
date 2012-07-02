//
//  FireWall.h
//  BombRun
//
//  Created by factorysettings on 7/1/12.
//  Copyright 2012 . All rights reserved.
//

#import "cocos2d.h"
@class HelloWorldLayer;
@interface FireWall : CCSprite	{

	int movement;
	HelloWorldLayer *_layer;
}

-(id)initWithLayer:(HelloWorldLayer *)layer andSpeed:(int) speed;
-(void)moveWall;


@end
