//
//  FireWall.m
//  BombRun
//
//  Created by factorysettings on 7/1/12.
//  Copyright 2012 . All rights reserved.
//

#import "FireWall.h"
#import "HelloWorldLayer.h"

@implementation FireWall

-(void)moveWall
{
	CGPoint moveDown = ccp(self.position.x, self.position.y - movement);
	self.position = moveDown;
}

-(id)initWithLayer:(HelloWorldLayer *)layer andSpeed:(int)speed
{
	if ((self = [super initWithFile:@"firewall.png"])) 
	{
		_layer = layer;
		movement = speed;
				self.anchorPoint = ccp(0.5,0);

		self.scaleX = 100;
		self.scaleY = 7;
	
	}
	return self;
}

@end
