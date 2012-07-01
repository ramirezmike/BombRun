//
//  Player.h
//  BombRun
//
//  Created by factorysettings on 6/29/12.
//  Copyright 2012 factorysettings. All rights reserved.
//

#import "cocos2d.h"

@class HelloWorldLayer;

@interface Player : CCSprite {
	HelloWorldLayer *_layer;
	
	int holdCount;
	
	float speed;
	float distance;
	float lengthFromCenter;
	
	BOOL inWater;
	BOOL inAir;
	BOOL isAlive;
	
	CGPoint playerStartPoint;
	CGPoint playerEndPoint;
	CGPoint normalizedVector;
}

-(id)initWithLayer:(HelloWorldLayer *)layer;
-(void)frameUpdate;
-(void)stopMovement;
-(void)movementSetupWithTouch:(CGPoint)currentTouchLocation andHoldCount:(int) hold;


@end
