//
//  BrainFuck.m
//  brainf4ck
//
//  Created by Tamas Zsar on 2010.10.16..
//  Copyright 2010 0xcefaedfe.com. All rights reserved.
//

#import "BrainFuck.h"
#include <unistd.h>

@implementation BrainFuck
@synthesize delegate = _delegate;
@synthesize memoryBuffer = _memory;
@synthesize programBuffer = _program;
@synthesize isRunning = _isRunning;

#pragma mark -
#pragma mark initializer

- (id)initWithMemorySize:(NSUInteger)aMemSize andDelegate:(id<BrainFuckDelegate>)aDelegate {
	if (self = [super init]) {
		_memory = aMemSize < MAX_MEM_SIZE ? malloc(aMemSize) : malloc(MAX_MEM_SIZE);
		_program = malloc(MAX_PROGRAM_SIZE);
		self.delegate = aDelegate;
	}
	return self;
}

#pragma mark -
#pragma mark let's fuck some brains!!!

- (void)run {
	_memoryPointer = 0;
	_programPointer = 0;
	
	if (!_brainThread) {
		_brainThread = [[NSThread alloc] initWithTarget:self selector:@selector(mainLoop) object:nil];
	}
	[_brainThread start];
	_isRunning = YES;
	[_delegate BrainFuckDidStartRunning:self];
}

- (void)pause {
	_isRunning = NO;
}

- (void)stop {
	_isRunning = NO;
	_programPointer = 0;
	_memoryPointer = 0;
	[_brainThread release], _brainThread = nil;
	[_delegate BrainFuckDidStopRunning:self];	
}

- (void)mainLoop {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int kl = 0;

	while (_programPointer < _programSize || _program[_programPointer] != 0) {
		if (!_isRunning) {
			usleep(500);
			continue;
		}
		
		switch (_program[_programPointer]) {
			case '>':
				_memoryPointer++;
				break;
			case '<':
				_memoryPointer--;
				break;
			case '+':
				_memory[_memoryPointer]++;
				break;
			case '-':
				_memory[_memoryPointer]--;
				break;
			case ',':
				_memory[_memoryPointer] = [_delegate BrainFuckWantsInput:self];
				break;
			case '.':
				[_delegate BrainFuck:self didOutput:_memory[_memoryPointer]];
				break;
			case '[':
				if (_memory[_memoryPointer] == 0) {
					_programPointer++;
					while (kl > 0 || _program[_programPointer] != ']') {
						if (_program[_programPointer] == '[') kl++;
						if (_program[_programPointer] == ']') kl--;
						_programPointer++;
					}
				}
				break;
			case ']':
				if (_memory[_memoryPointer] != 0) {
					_programPointer--;
					while (kl > 0 || _program[_programPointer] != '[') {
						if (_program[_programPointer] == '[') kl--;
						if (_program[_programPointer] == ']') kl++;
						_programPointer--;
					}
					_programPointer--;
				}
				break;	
				case ' ':
				case '\n':
				case '\t':
					break;								
			default:
				[_delegate BrainFuck:self didFailWithError:[NSError errorWithDomain:kBrainFuckErrorDomain code:BrainFuckErrorSyntaxError userInfo:nil]];
				break;
		}
		[_delegate BrainFuck:self programPosition:_programPointer memoryPosition:_memoryPointer];
		_programPointer++;
	}
	[pool release];
}

#pragma mark -
#pragma mark custom setters/getters

- (void)setProgramBuffer:(char *)aBuffer {
	if (aBuffer == NULL || strlen(aBuffer) > MAX_PROGRAM_SIZE) {
		[_delegate BrainFuck:self didFailWithError:[NSError errorWithDomain:kBrainFuckErrorDomain code:BrainFuckErrorFailedSettingProgram userInfo:nil]];
	}
	_programSize = strlen(aBuffer);
	memcpy(_program, aBuffer, _programSize);
	
}

#pragma mark -
#pragma mark memory management

- (void)dealloc {
	[self stop];
	if (_memory) free(_memory);
	if (_program)	free(_program);
	
	[super dealloc];
}

@end
