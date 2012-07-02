//
//  HelloWorldLayer.h
//  BombRun
//
//  Created by Michael Ramirez on 6/29/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
@class Player;
@class FireWall;
@class HelloWorldLayer;

@interface FireballLayer : CCLayer
{
	FireballLayer *_layer;
	CCSprite* fireball;
	CCSprite* rope;
	CCSprite* flame1;
	CCSprite* flame2;
	
	float fireballScale;
	HelloWorldLayer* parentLayer;

}

-(id)initWithHelloLayer:(HelloWorldLayer *) helloLayer;

@end



@interface HelloWorldLayer : CCLayer
{
	CCTMXTiledMap *_tileMap;
	CCTMXLayer *_background;
	CCTMXLayer *_wall;
		
	Player *_player;
	
	NSMutableArray * _fireballs;
	
	CCSprite *fireballShadow;
	float fireballScale;
	float shadowScale;
	FireWall *wallOFire;
	
	CGPoint currentTouchLocation;
	
	BOOL wickLit;
}

@property (readwrite, assign) BOOL wickLit;


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(float) LerpA:(float) a B:(float) b T:(float) t;
-(BOOL)boundryCheck:(CGPoint)location;
-(BOOL)isPassable:(CGPoint)location;
-(void)vertexCheck:(CCSprite *) sprite;
-(void)updateVertexZ:(CGPoint)tilePos withSprite:(CCSprite *) sprite;
-(CGPoint)tileCoordForPosition:(CGPoint)position;
-(void)receiveShadowWorldCoordinates:(CGPoint) coords;
-(CGPoint)playerWorldPosition;


@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCTMXLayer *wall;
@property (nonatomic, retain) NSMutableArray *fireballs;


@end
