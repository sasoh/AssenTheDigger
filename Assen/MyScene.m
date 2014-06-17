//
//  MyScene.m
//  Assen
//
//  Created by Alexander Popov on 6/17/14.
//  Copyright (c) 2014 ---. All rights reserved.
//

#import "MyScene.h"

static const float DAILY_TARGET = 10.0f;

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        _metersDug = 0.0f;
        _gameOver = NO;
        
        // init background
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
        CGPoint centerPoint = CGPointMake(CGRectGetMidX([self frame]), CGRectGetMidY([self frame]));
        [background setPosition:centerPoint];
        [self addChild:background];
        
        // init assen
        _assen = [[AssenNode alloc] initWithState:AssenNodeStateDigging];
        [_assen setAnchorPoint:CGPointMake(0, 1)];
        [_assen setPosition:CGPointMake(50, [_assen size].height + 210)];
        [_assen setDelegate:self];
        [self addChild:_assen];
        
        // init labels
        _infoLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
        [_infoLabel setFontSize:10];
        [_infoLabel setFontColor:[UIColor blackColor]];
        [_infoLabel setText:@"Dug today: 0m"];
        [_infoLabel setPosition:CGPointMake([self frame].size.width / 2, 200)];
        [self addChild:_infoLabel];
        
        _statusLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
        [_statusLabel setFontSize:14];
        [_statusLabel setFontColor:[UIColor blackColor]];
        [_statusLabel setText:@"Assen has rested and is ready to dig."];
        [_statusLabel setPosition:CGPointMake(centerPoint.x, centerPoint.y + 50)];
        [self addChild:_statusLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_gameOver != YES) {
        [_assen dig];
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark -
#pragma mark Assen delegate method

- (void)assen:(AssenNode *)node changedToState:(AssenNodeState)state {

    // hide status label
    [_statusLabel setHidden:YES];
    
    if (state == AssenNodeStateThrowing) {
        _metersDug += 0.2f;
        [_infoLabel setText:[NSString stringWithFormat:@"Dug today: %.1fm", _metersDug]];
        
        if (_metersDug >= DAILY_TARGET) {
            [_statusLabel setHidden:NO];
            [_statusLabel setText:@"You done enough for today. Come back tomorrow."];
            _gameOver = YES;
            // mabye reset?
        }
    } else if (state == AssenNodeStateSmoking) {
        // show smoking break label
        [_statusLabel setText:@"Assen is tired and he's having a smoke."];
        [_statusLabel setHidden:NO];
    }
    
}

- (void)assenHasRested:(AssenNode *)node
{
    
    [_statusLabel setText:@"Assen has rested and is ready to dig."];
    
}

@end
