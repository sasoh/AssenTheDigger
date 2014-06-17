//
//  AssenNode.m
//  Assen
//
//  Created by Alexander Popov on 6/17/14.
//  Copyright (c) 2014 ---. All rights reserved.
//

#import "AssenNode.h"

// filenames
static NSString * const FILE_SMOKING  = @"assen_smoking";
static NSString * const FILE_DOWN     = @"assen_down";
static NSString * const FILE_UP       = @"assen_up";

static const int BASE_MOVES = 15;
static const float REST_TIME = 10.0f;

@interface AssenNode ()

- (void)setNewState:(AssenNodeState)state;
- (void)replenishTimerFunction:(NSTimer *)sender;

@end

@implementation AssenNode

- (instancetype)initWithState:(AssenNodeState)state {
    
    NSString *filename = nil;
    
    switch (state) {
        case AssenNodeStateSmoking: {
            filename = FILE_SMOKING;
            break;
        }
        case AssenNodeStateDigging: {
            filename = FILE_DOWN;
            break;
        }
        case AssenNodeStateThrowing: {
            filename = FILE_UP;
            break;
        }
        default:
            filename = FILE_SMOKING;
            state = AssenNodeStateSmoking;
            break;
    }
    
    self = [super initWithImageNamed:filename];
    
    if (self != nil) {
        _state = state;
        _moves = BASE_MOVES;
    }
    
    return self;
    
}

- (void)dig {
    
    --_moves;
    if (_moves <= 0) {
        if (_state != AssenNodeStateSmoking) {
            [self setNewState:AssenNodeStateSmoking];
            
            // replenish after some time
            // TODO: Sending app to background resets timer & invalidates this, shoud figure out a workaround
            [NSTimer scheduledTimerWithTimeInterval:REST_TIME target:self selector:@selector(replenishTimerFunction:) userInfo:nil repeats:NO];
        }
    } else {
        if (_state == AssenNodeStateDigging) {
            [self setNewState:AssenNodeStateThrowing];
        } else {
            [self setNewState:AssenNodeStateDigging];
        }
    }
    
}

- (void)setNewState:(AssenNodeState)state
{
    
    if (_state != state) {
        _state = state;
        
        if (_emitter != nil) {
            // leave just one more particle & the system will disappear
            [_emitter setNumParticlesToEmit:1];
        }
        
        if (_state == AssenNodeStateSmoking) {
            [self setTexture:[SKTexture textureWithImageNamed:FILE_SMOKING]];
            NSString *particleFileName = [[NSBundle mainBundle] pathForResource:@"Smoke" ofType:@"sks"];
            _emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFileName];
            [_emitter setPosition:CGPointMake(60, -20)];
            [self addChild:_emitter];
        } else if (_state == AssenNodeStateDigging) {
            [self setTexture:[SKTexture textureWithImageNamed:FILE_DOWN]];
        } else if (_state == AssenNodeStateThrowing) {
            [self setTexture:[SKTexture textureWithImageNamed:FILE_UP]];
            NSString *particleFileName = [[NSBundle mainBundle] pathForResource:@"Dirt" ofType:@"sks"];
            _emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFileName];
            [_emitter setPosition:CGPointMake(100, -20)];
            [self addChild:_emitter];
        }
        [self setSize:[[self texture] size]];
        
        [_delegate assen:self changedToState:_state];
    }
    
}

- (void)replenishTimerFunction:(NSTimer *)sender {
    _moves = BASE_MOVES;
    [_delegate assenHasRested:self];
}

@end
