//
//  HelloWorldLayer.m
//  BombRun
//
//  Created by Michael Ramirez on 6/29/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Player.h"
// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize tileMap = _tileMap;
@synthesize background  = _background;
@synthesize wall = _wall;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	return scene;
}

-(CGPoint)tileCoordForPosition:(CGPoint)location
{
	CGPoint pos = ccpSub(location, _tileMap.position);
	
	float halfMapWidth = _tileMap.mapSize.width * 0.5f;
	float mapHeight = _tileMap.mapSize.height;
	float tileWidth = _tileMap.tileSize.width;
	float tileHeight = _tileMap.tileSize.height;
	
	CGPoint tilePosDiv = CGPointMake(pos.x / tileWidth, pos.y / tileHeight);
	float inverseTileY = mapHeight - tilePosDiv.y;
	
	float posX = (int)(inverseTileY + tilePosDiv.x - halfMapWidth);
	float posY = (int)(inverseTileY - tilePosDiv.x + halfMapWidth);
	
	posX = MAX(0, posX);
	if (posX != MIN(_tileMap.mapSize.width - 1, posX))
	{
		//distance = lengthFromCenter;
	}
	posX = MIN(_tileMap.mapSize.width - 1, posX);

	
	posY = MAX(0, posY);
	if (posY != MIN(_tileMap.mapSize.height - 1, posY))
	{
		//distance = lengthFromCenter;
	}
	posY = MIN(_tileMap.mapSize.height - 1, posY);

	return CGPointMake(posX, posY);
}


-(void)nextFrame:(ccTime)dt
{
	[_player frameUpdate];
}

-(CGPoint) locationFromTouch:(UITouch *)touch
{
	CGPoint touchLocation = [touch locationInView:[touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(CGPoint) locationFromTouches:(NSSet *)touches
{
	return [self locationFromTouch:[touches anyObject]];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	currentTouchLocation = [self locationFromTouches:touches];
	[_player movementSetupWithTouch:currentTouchLocation andHoldCount:1];
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	currentTouchLocation = [self locationFromTouches:touches];
	[_player movementSetupWithTouch:currentTouchLocation andHoldCount:2];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_player stopMovement];
}

-(BOOL) isWall:(CGPoint) tilePos
{
	BOOL isWall = FALSE;
	int tileGID = [_wall tileGIDAt:tilePos];
	if (tileGID) 
	{
		NSDictionary* tileProperties = [_tileMap propertiesForGID:tileGID];
		//id blocks_movement = [tileProperties objectForKey:@"blocks_movement"];
		if (tileProperties) 
		{
			NSString *wall = [tileProperties valueForKey:@"wall"];
			if (wall && [wall compare:@"True"] == NSOrderedSame) 
			{
				isWall = TRUE;
				//NSLog(@"Wall Detected");
			}
		}
	}
	return isWall;
}

-(BOOL) isPassable:(CGPoint) location
{
	CGPoint tileCoord = [self tileCoordForPosition:location];
	BOOL isPassable = TRUE;
	int tileGID = [_wall tileGIDAt:tileCoord];
	if (tileGID) 
	{
		NSDictionary* tileProperties = [_tileMap propertiesForGID:tileGID];
		//id blocks_movement = [tileProperties objectForKey:@"blocks_movement"];
		if (tileProperties) 
		{
			NSString *wall = [tileProperties valueForKey:@"Wall"];
			if (wall && [wall compare:@"True"] == NSOrderedSame) 
			{
				isPassable = FALSE;
			}
		}
	}
	return isPassable;
}

-(BOOL)boundryCheck:(CGPoint)location
{
	CGPoint pos = ccpSub(location, _tileMap.position);
	
	float halfMapWidth = _tileMap.mapSize.width * 0.5f;
	float mapHeight = _tileMap.mapSize.height;
	float tileWidth = _tileMap.tileSize.width;
	float tileHeight = _tileMap.tileSize.height;
	
	CGPoint tilePosDiv = CGPointMake(pos.x / tileWidth, pos.y / tileHeight);
	float inverseTileY = mapHeight - tilePosDiv.y;
	
	float posX = (int)(inverseTileY + tilePosDiv.x - halfMapWidth);
	float posY = (int)(inverseTileY - tilePosDiv.x + halfMapWidth);
	
	if (posX != MIN(_tileMap.mapSize.width - 1, posX) || posX < 0)
	{
		//NSLog(@"X outside of map");
		return FALSE;
	}
	posX = MAX(0, posX);
	posX = MIN(_tileMap.mapSize.width - 1, posX);

	
	if (posY != MIN(_tileMap.mapSize.height - 1, posY) || posY < 0)
	{
		//NSLog(@"Y outside of map");
		return FALSE;
	}
	posY = MAX(0, posY);
	posY = MIN(_tileMap.mapSize.height - 1, posY);
	return TRUE;
}

-(void) updateVertexZ:(CGPoint)tilePos withSprite:(CCSprite *) sprite
{
	float lowestZ = -(_tileMap.mapSize.width + _tileMap.mapSize.height); 
	float currentZ = tilePos.x + tilePos.y;
	sprite.vertexZ = lowestZ + currentZ - 1;
}

-(void)vertexCheck:(CCSprite *) sprite
{
	CGPoint tilePos = [self tileCoordForPosition:sprite.position];
	CGPoint northTile = ccp(tilePos.x,tilePos.y-1);
	CGPoint westTile = ccp(tilePos.x-1,tilePos.y);
	CGPoint southWestTile = ccp(tilePos.x-1,tilePos.y+1);
	
	if ([self isWall:northTile]) 
	{
		CGPoint newPosition = ccp(tilePos.x + 1, tilePos.y);
		[self updateVertexZ:newPosition withSprite:sprite];
	}
	if ([self isWall:westTile]) 
	{
		CGPoint newPosition = ccp(tilePos.x + 1,tilePos.y);
		[self updateVertexZ:newPosition withSprite:sprite];
	}
	if ([self isWall:southWestTile]) 
	{
		CGPoint newPosition = ccp(tilePos.x,tilePos.y+1);
		[self updateVertexZ:newPosition withSprite:sprite];
	}
}


- (float) LerpA:(float) a B:(float) b T:(float) t
{
	return a + t*(b - a);
}

-(id) init
{
	if( (self=[super init])) 
	{
		//CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
		//label.position =  ccp( size.width /2 , size.height/2 );
		//[self addChild: label];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
		self.isTouchEnabled = YES;
		
		self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"level01.tmx"];
		self.background = [_tileMap layerNamed:@"Background"];
		self.wall = [_tileMap layerNamed:@"Wall"];
		_tileMap.position = ccp(0,0);
		[self addChild:_tileMap z:-1];
		
		_player = [[Player alloc]initWithLayer:self];
		_player.position = ccp(screenSize.width/8 - _player.contentSize.width,screenSize.height/1.5 - _player.contentSize.height);
		_player.anchorPoint = CGPointMake(0.5f, 0.2f);	
		
		[self addChild:_player];
		[self runAction:[CCFollow actionWithTarget:_player]];

		[self schedule:@selector(nextFrame:) interval:0.01];


	}
	return self;
}


- (void) dealloc
{
	_tileMap = nil;
	_background = nil;
	_wall = nil;
	[super dealloc];
}
@end
