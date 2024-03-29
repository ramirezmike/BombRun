
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
-(BOOL)checkCollisionWithPlayer:(CGPoint) playerLocation;
-(void)updateFireball;
-(void)sendFireball:(CGPoint)coords;
-(void)lockShadow:(CGPoint)coords;



@end
