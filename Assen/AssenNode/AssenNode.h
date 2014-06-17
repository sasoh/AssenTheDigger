//
//  AssenNode.h
//  Assen
//
//  Created by Alexander Popov on 6/17/14.
//  Copyright (c) 2014 ---. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, AssenNodeState) {
    AssenNodeStateSmoking,
    AssenNodeStateDigging,
    AssenNodeStateThrowing,
};

@class AssenNode;

@protocol AssenNodeDelegate <NSObject>

- (void)assen:(AssenNode *)node changedToState:(AssenNodeState)state;
- (void)assenHasRested:(AssenNode *)node;

@end

@interface AssenNode : SKSpriteNode {
    int _moves;
    SKEmitterNode *_emitter;
}

@property (nonatomic, assign) AssenNodeState state;
@property (nonatomic, weak) id <AssenNodeDelegate> delegate;

- (instancetype)initWithState:(AssenNodeState)state;
- (void)dig;

@end
