//
//  Fireball.m
//  BombRun
//
//  Created by Michael Ramirez on 7/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Fireball.h"


@implementation Fireball

@synthesize lifeCount;


-(void)updateFireball
{
	if (!landed) 
	{
		//NSLog(@"%f",shadowScale);
		shadowScale -= 0.1;
		fireballShadow.scale = shadowScale;
	
		if (shadowScale < 1.0) 
		{
			shadowScale = 1.0;
		}
	}
	fireball.scale = fireballScale;
	fireballScale -= 0.1;
	if (fireballScale < 1.0) 
	{
		fireballScale = 1.0;
		lifeCount -= 1;
	}
	else 
	{
			fireball.rotation += 10.0;
	}

	
	if (lifeCount <= 0) 
	{
		[_layer removeChild:fireball cleanup:YES];
		fireball = nil;
		[fireball release];
	}

}

-(void)removeSelf
{
	[_layer removeChild:fireballShadow cleanup:YES];
	fireballShadow = nil;
	[fireballShadow release];
	landed = TRUE;
}

-(void)sendFireball:(CGPoint)coords
{
	fireball.position = ccp(coords.x, coords.y + 320);
	fireballScale = 5.0;
	id actionMove = [CCMoveTo actionWithDuration:0.5 position:coords];
	id removeSelf = [CCCallFunc actionWithTarget:self selector:@selector(removeSelf)];
	[fireball runAction:[CCSequence actions:actionMove,removeSelf,nil]];
}

-(void)lockShadow:(CGPoint)coords
{
	shadowScale = 2.0;
	fireballShadow.scale = shadowScale;
	fireballShadow.position = coords;
}

-(id)initWithCoords:(CGPoint) coords andLayer:(HelloWorldLayer *) layer
{
	if ((self = [super init])) 
	{
		_layer = layer;
		fireballShadow = [CCSprite spriteWithFile:@"shadow.png"];
		fireballShadow.opacity = 150;
		//fireballShadow.visible = NO;
		fireball = [CCSprite spriteWithFile:@"fireball.png"];
		[_layer addChild:fireballShadow];
		[_layer addChild:fireball];
		landed = FALSE;
		lifeCount = 30;
	}
	return self;
}



@end
