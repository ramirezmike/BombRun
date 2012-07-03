//
//  Player.m
//  BombRun
//
//  Created by factorysettings on 6/29/12.
//  Copyright 2012 factorysettings. All rights reserved.
//

#import "Player.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"


@implementation Player

-(id)initWithLayer:(HelloWorldLayer *)layer
{
	if ((self = [super initWithFile:@"Bomb.png"])) 
	{
		_layer = layer;
		holdCount = 0;
		speed = 5.0;
	}
	return self;
}

-(void)movementSetupWithTouch:(CGPoint)touch andHoldCount:(int) hold
{
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	CGPoint center = ccp(screenSize.width/2,screenSize.height/2);
	CGPoint vectorFromCenter = ccpSub(touch, center);
	
	lengthFromCenter = ccpLength(vectorFromCenter);
	normalizedVector = ccp(vectorFromCenter.x/lengthFromCenter,vectorFromCenter.y/lengthFromCenter);
	playerStartPoint = self.position;
	playerEndPoint = ccpAdd(self.position, vectorFromCenter);
	distance = 0;
	holdCount = hold;
}

-(void)checkLayerCollisions:(CGPoint) location
{
	if (![_layer boundryCheck:location] || ![_layer isPassable:location]) 
	{
		distance = lengthFromCenter;
		return;
	}
//	[_layer DiagWallCheck:[_layer tileCoordForPosition:location]];
	self.position = location;
	[_layer updateVertexZ:[_layer tileCoordForPosition:location] withSprite:self];
}

-(void)moveTowardEndPoint
{
	distance += speed;
	float Ycoord = [_layer LerpA:playerStartPoint.y B:playerEndPoint.y T:MIN(1.0,distance/lengthFromCenter)];
	float Xcoord = [_layer LerpA:playerStartPoint.x B:playerEndPoint.x T:MIN(1.0,distance/lengthFromCenter)];
	CGPoint interpolatedCoordinate = ccp(Xcoord,Ycoord);
	[self checkLayerCollisions:interpolatedCoordinate];
}

-(void)holdMovement
{
	CGPoint newPosition = ccp(self.position.x + (normalizedVector.x * speed), self.position.y + (normalizedVector.y * speed));
	[self checkLayerCollisions:newPosition];
}

-(void)stopMovement
{
	if (holdCount > 2) 
	{
		distance = lengthFromCenter;
	}
	holdCount = 0;
}

-(void)frameUpdate
{
	if (holdCount >= 2)
	{
		holdCount++;
		distance = lengthFromCenter;
		[self holdMovement];
	}
	
	if (holdCount == 1)
	{
		holdCount++;
	}
	
	if (distance < lengthFromCenter) 
	{
		[self moveTowardEndPoint];
		[_layer vertexCheck:self];
		[[SimpleAudioEngine sharedEngine]playEffect:@"step.wav"];

	}
	
}


@end
