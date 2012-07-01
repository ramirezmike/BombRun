//
//  Fireball.h
//  BombRun
//
//  Created by Michael Ramirez on 7/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class HelloWorldLayer;

@interface Fireball : CCNode {

	HelloWorldLayer* _layer;
	
	CCSprite *fireballShadow;
	CCSprite *fireball;
	float fireballScale;
	float shadowScale;
	BOOL landed;
	int lifeCount;
}

@property (readwrite, assign) int lifeCount;

-(id)initWithCoords:(CGPoint) coords andLayer:(HelloWorldLayer *) layer;
-(void)updateFireball;
-(void)sendFireball:(CGPoint)coords;
-(void)lockShadow:(CGPoint)coords;



@end
