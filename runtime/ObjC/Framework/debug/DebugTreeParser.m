// [The "BSD licence"]
// Copyright (c) 2006-2007 Kay Roepke
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "DebugTreeParser.h"


@implementation DebugTreeParser

@synthesize dbg;
@synthesize isCyclicDecision;

/** Create a normal parser except wrap the token stream in a debug
 *  proxy that fires consume events.
 public DebugTreeParser(TreeNodeStream input, DebugEventListener dbg, RecognizerSharedState state) {
 super(input instanceof DebugTreeNodeStream?input:new DebugTreeNodeStream(input,dbg), state);
 setDebugListener(dbg);
 }
 
 public DebugTreeParser(TreeNodeStream input, RecognizerSharedState state) {
 super(input instanceof DebugTreeNodeStream?input:new DebugTreeNodeStream(input,null), state);
 }
 
 public DebugTreeParser(TreeNodeStream input, DebugEventListener dbg) {
 this(input instanceof DebugTreeNodeStream?input:new DebugTreeNodeStream(input,dbg), dbg, null);
 }
 */

- (id) initWithStream:(id<TreeNodeStream>)theStream State:(RecognizerSharedState *)state
{
    isCyclicDecision = NO;
	id<TreeNodeStream> treeNodeStream = nil;
	dbg = [[DebugEventSocketProxy alloc] initWithGrammarName:[self grammarFileName] debuggerPort:-1];
	if (theStream && ![theStream isKindOfClass:[DebugTreeNodeStream class]]) {
		treeNodeStream = [[DebugTreeNodeStream alloc] initWithTree:theStream DebugListener:dbg];
	} else {
		treeNodeStream = theStream;
	}
	self = [super initWithStream:treeNodeStream];
	if ( self ) {
		// [dbg waitForDebuggerConnection];
	}
	return self;
}

- (id) initWithStream:(id<TreeNodeStream>)theStream State:(RecognizerSharedState *)state
				 DebugListener:(id<DebugEventListener>)theDebugListener
{
    isCyclicDecision = NO;
	id<TreeNodeStream> treeNodeStream = nil;
	dbg = theDebugListener;
	if (theStream && ![theStream isKindOfClass:[DebugTreeNodeStream class]]) {
		treeNodeStream = [[DebugTreeNodeStream alloc] initWithTree:theStream DebugListener:dbg];
	} else {
		treeNodeStream = theStream;
	}
	self = [super initWithStream:treeNodeStream];
	if ( self ) {
		// [dbg waitForDebuggerConnection];
	}
	return self;
}

- (id) initWithStream:(id<TreeNodeStream>)theStream
				DebugListener:(id<DebugEventListener>)theDebugListener
{
    isCyclicDecision = NO;
	id<TreeNodeStream> treeNodeStream = nil;
	dbg = theDebugListener;
	if (theStream && ![theStream isKindOfClass:[DebugTreeNodeStream class]]) {
		treeNodeStream = [[DebugTreeNodeStream alloc] initWithTree:theStream DebugListener:dbg];
	} else {
		treeNodeStream = theStream;
	}
	self = [super initWithStream:treeNodeStream];
	if ( self ) {
		// [dbg waitForDebuggerConnection];
	}
	return self;
}

- (void) dealloc
{
    dbg = nil;
}

- (id<DebugEventListener>) debugListener
{
    return dbg;
}

- (id<DebugEventListener>) getDebugListener
{
    return dbg;
}

- (void) setDebugListener: (id<DebugEventListener>) aDebugListener
{
    if ([input isKindOfClass:[DebugTreeNodeStream class]]) {
        [(DebugTreeNodeStream *)input setDebugListener:dbg];
    }
    dbg = aDebugListener;
}

#pragma mark -
#pragma mark Overrides

- (void)reportErrorIO:(NSException *)e
{
    // System.err.println(e);
    // e.printStackTrace(System.err);
}

- (void)reportError:(RecognitionException *)e
{
    [dbg recognitionException:e];
}

- (id<Tree>)getMissingSymbol:(id<IntStream>)anInput
            Exception:(RecognitionException *)e
            TokenType:(NSInteger)expectedTokenType
            Follow:(ANTLRBitSet *)follow
{
    id<Tree> o = [super getMissingSymbol:anInput
            Exception:e
            TokenType:expectedTokenType
            Follow:follow];
    [dbg consumeNode:o];
    return o;
}

- (void) beginResync
{
	[dbg beginResync];
}

- (void) endResync
{
	[dbg endResync];
}

- (void)beginBacktracking:(NSInteger)level
{
	[dbg beginBacktrack:level];
}

- (void)endBacktracking:(NSInteger)level wasSuccessful:(BOOL)successful
{
	[dbg endBacktrack:level wasSuccessful:successful];
}

@end
