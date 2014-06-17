//
//  MyScene.h
//  Assen
//

//  Copyright (c) 2014 ---. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AssenNode.h"

@interface MyScene : SKScene <AssenNodeDelegate> {
    AssenNode *_assen;
    SKLabelNode *_infoLabel;
    SKLabelNode *_statusLabel;
    float _metersDug;
    BOOL _gameOver;
}

@end
