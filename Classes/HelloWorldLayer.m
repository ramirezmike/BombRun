


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Player.h"
#import "Fireball.h"
#import "FireWall.h"
#import "SimpleAudioEngine.h"

#import "GameOverScene.h"
// HelloWorldLayer implementation

@implementation FireballLayer


-(void)newPosition
{
		float randomX = (arc4random()%480);
		float randomY = (arc4random()%200);
		fireball.position = ccp(randomX,randomY);
		fireball.opacity = 150;
}

-(CGPoint)getShadowWorldCoordinates
{
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	CGPoint center = ccp(screenSize.width/2,screenSize.height/2);
	CGPoint vectorFromCenter = ccpSub(fireball.position, center);
	
	CGPoint worldCenter = [parentLayer playerWorldPosition];
	CGPoint realWorldPosition = ccpAdd(worldCenter, vectorFromCenter);
	
	return realWorldPosition;
}

-(void)updateFireball:(ccTime)dt
{
	fireball.scale = fireballScale;
	fireballScale -= 0.1;
	
	flame1.rotation -= 30;
	flame2.rotation += 30;
	

		
	if (fireballScale < 3.0 && [[parentLayer fireballs]count] < 1) 
	{
		CGPoint realWorldCoords = [self getShadowWorldCoordinates];
		[parentLayer receiveShadowWorldCoordinates:realWorldCoords];
		fireball.visible = NO;
		[self newPosition];

	}
	if (fireballScale < 0.0 && [[parentLayer fireballs]count] < 1) 
	{
		fireballScale = 5.0;
		fireball.visible = YES;
	}
	
	if ([parentLayer wickLit]) 
	{
		flame1.visible = YES;
		flame2.visible = YES;
		rope.scaleX -= 0.1;
		flame1.position = ccp(flame1.position.x - 1.6, flame1.position.y);
		flame2.position = ccp(flame2.position.x - 1.6, flame2.position.y);

	}
	if (rope.scaleX < 0) 
	{
		GameOverScene *gameOverScene = [GameOverScene node];
		[gameOverScene.layer.label setString:@"You Lost! :("];
		[[SimpleAudioEngine sharedEngine]playEffect:@"explosion.wav"];

		[[CCDirector sharedDirector] replaceScene:gameOverScene];
	}
}

-(id)initWithHelloLayer:(HelloWorldLayer *) helloLayer
{
	if ((self = [super init])) 
	{
		parentLayer = helloLayer;
		fireball = [CCSprite spriteWithFile:@"shadow.png"];
		fireballScale = 5.0;
		
		//rope = [CCSprite spriteWithFile:@"rope.png"];
		rope = [CCSprite spriteWithFile:@"rope.png"];
		rope.position = ccp(10,10);
		rope.anchorPoint = ccp(0,1);
		rope.scaleX = 29;
		rope.scaleY = 1;
		
		CGPoint flamePoint = ccp(470,10);
		flame1 = [CCSprite spriteWithFile:@"flame.png"];
		flame1.position = flamePoint;
		
		flame2 = [CCSprite spriteWithFile:@"flame.png"];
		flame2.position = flamePoint;
		
		flame2.rotation += 45;
		
		flame1.visible = NO;
		flame2.visible = NO;
		
		
		[self newPosition];
		[self schedule:@selector(updateFireball:) interval:0.01];
		[self addChild:fireball];
		[self addChild:rope];
		[self addChild:flame1];
		[self addChild:flame2];

	}
	return self;
}

@end




@implementation HelloWorldLayer
@synthesize tileMap = _tileMap;
@synthesize background  = _background;
@synthesize wall = _wall;
@synthesize fireballs, wickLit;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	FireballLayer *fireLayer = [[FireballLayer alloc]initWithHelloLayer:layer];
	[scene addChild: layer];
	[scene addChild:fireLayer];
	return scene;
}

-(CGPoint)positionForTileCoord:(CGPoint)tileCoord
{
	tileCoord.y -= 1;
	CGPoint worldPosition = [_background positionAt:tileCoord];
	worldPosition = ccpAdd(worldPosition, _tileMap.position);

	return worldPosition;
}

-(CGPoint)playerWorldPosition
{
	return _player.position;
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
	[wallOFire moveWall];
	
	for (Fireball* ball in fireballs) 
	{
		[ball updateFireball];
		if (ball.lifeCount <= 0) 
		{
			[fireballs removeObject:ball];
		}
		if ([ball checkCollisionWithPlayer:_player.position]) 
		{
			wickLit = TRUE;
		}
	}
	
	if (_player.position.y > wallOFire.position.y - wallOFire.contentSize.height/2) 
	{
		NSLog(@"FIREWALL HIT!");
		NSLog(@"PLAYER: %@ WALL: %@", NSStringFromCGPoint(_player.position),NSStringFromCGPoint(wallOFire.position));
		wickLit = TRUE;
				GameOverScene *gameOverScene = [GameOverScene node];
		[gameOverScene.layer.label setString:@"You Lost! :("];
				[[SimpleAudioEngine sharedEngine]playEffect:@"explosion.wav"];

		[[CCDirector sharedDirector] replaceScene:gameOverScene];
	}
	
	if (_player.position.y < -1350) 
	{
		GameOverScene *gameOverScene = [GameOverScene node];
		[gameOverScene.layer.label setString:@"You Bombed The Orphanage! :D"];
		[[SimpleAudioEngine sharedEngine]playEffect:@"explosion.wav"];
		[[SimpleAudioEngine sharedEngine]playEffect:@"laugh.wav"];

		[[CCDirector sharedDirector] replaceScene:gameOverScene];
	}

}


-(void)receiveShadowWorldCoordinates:(CGPoint) coords
{
	Fireball *ball = [[Fireball alloc]initWithCoords:coords andLayer:self];
	[fireballs addObject:ball]; 
	
	[ball lockShadow:coords];
	[ball sendFireball:coords];
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
			NSString *wall = [tileProperties valueForKey:@"wall"];
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
		
	//	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
		self.isTouchEnabled = YES;
	
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"laugh.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"step.wav"];
				
		self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"level01.tmx"];
		self.background = [_tileMap layerNamed:@"Background"];
		self.wall = [_tileMap layerNamed:@"Wall"];
		_tileMap.position = ccp(0 + _tileMap.contentSize.width/4,0 - _tileMap.contentSize.height/2);
		[self addChild:_tileMap z:-1];
		
		_player = [[Player alloc]initWithLayer:self];
		CGPoint playerTileSpawn = ccp(12,12);
		playerTileSpawn = [self positionForTileCoord:playerTileSpawn];
		_player.position = playerTileSpawn;
		_player.anchorPoint = CGPointMake(0.5f, 0.2f);	
		
		//_player.position = ccp(0,0);
		
		wickLit = FALSE;
		
		fireballs = [[NSMutableArray alloc]init];
		
		wallOFire = [[FireWall alloc]initWithLayer:self andSpeed:3];
		wallOFire.position = [self positionForTileCoord:ccp(0,0)];
		[self addChild:wallOFire];
		
		
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
	[_fireballs release];
	[super dealloc];
}
@end
