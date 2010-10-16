//
//  BrainFuck.h
//  brainf4ck
//
//  Created by Tamas Zsar on 2010.10.16..
//  Copyright 2010 0xcefaedfe.com. All rights reserved.
//
#define MAX_MEM_SIZE 32768
#define MAX_PROGRAM_SIZE 1024*1024
#define kBrainFuckErrorDomain @"com.0xcefaedfe.brainf4ck"

#import <Foundation/Foundation.h>
#import "BrainFuckDelegate.h"

typedef enum {
	BrainFuckErrorFailedSettingProgram = -1,
	BrainFuckErrorSyntaxError = -2
} BrainFuckError;

@interface BrainFuck : NSObject {
	char *_memory;
	char *_program;
	NSUInteger _memoryPointer;
	NSUInteger _programPointer;
	NSUInteger _programSize;
	BOOL _isRunning;
	
	id<BrainFuckDelegate> _delegate;
	NSThread *_brainThread;
}

#pragma mark -
#pragma mark properties

@property (nonatomic, assign) id<BrainFuckDelegate> delegate;
@property (readonly) char *memoryBuffer;
@property (readwrite) char *programBuffer;
@property (readonly) BOOL isRunning;

#pragma mark -
#pragma mark methods
- (id)initWithMemorySize:(NSUInteger)aMemSize andDelegate:(id <BrainFuckDelegate>)aDelegate;
- (void)run;
- (void)pause;
- (void)stop;

@end
