//
//  BrainFuckDelegate.h
//  brainf4ck
//
//  Created by Tamas Zsar on 2010.10.16..
//  Copyright 2010 0xcefaedfe.com. All rights reserved.
//

@class BrainFuck;

@protocol BrainFuckDelegate <NSObject>
@required
- (void)BrainFuck:(BrainFuck*)aBrain programPosition:(NSUInteger)aProgramPosition memoryPosition:(NSUInteger)aMemoryPosition;
- (void)BrainFuck:(BrainFuck*)aBrain didFailWithError:(NSError*)aError;
- (void)BrainFuckDidStartRunning:(BrainFuck*)aBrain;
- (void)BrainFuckDidStopRunning:(BrainFuck*)aBrain;
- (char)BrainFuckWantsInput:(BrainFuck*)aBrain;
- (void)BrainFuck:(BrainFuck*)aBrain didOutput:(char)aOutput;

@end
