//
//  GameOverScene.h
//  BombRun
//
//  Created by factorysettings on 7/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
	CCLabelTTF *_label;
}
@property (nonatomic,retain) CCLabelTTF *label;

@end

@interface GameOverScene :CCScene
{
	GameOverLayer *_layer;
}

@property (nonatomic, retain) GameOverLayer *layer;
@end