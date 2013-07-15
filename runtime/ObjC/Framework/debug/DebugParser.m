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

#import "DebugParser.h"


@implementation DebugParser

+ (DebugParser *)newDebugParser:(id<TokenStream>)input State:(RecognizerSharedState *)state DebugListener:(id<DebugEventListener>)debugger
{
    return [[DebugParser alloc] initWithTokenStream:input State:state DebugListener:debugger];
}

+ (DebugParser *)newDebugParser:(id<TokenStream>)input State:(RecognizerSharedState *)state
{
    return [[DebugParser alloc] initWithTokenStream:input State:state DebugListener:nil];
}

+ (DebugParser *)newDebugParser:(id<TokenStream>)input DebugListener:(id<DebugEventListener>)debugger
{
    return [[DebugParser alloc] initWithTokenStream:input DebugListener:debugger];
}

/*
public DebugTreeParser(TreeNodeStream input, DebugEventListener dbg, RecognizerSharedState state)
{
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

- (id) initWithTokenStream:(id<TokenStream>)theStream State:(RecognizerSharedState *)aState DebugListener:(id<DebugEventListener>)theDebugListener
{
	id<TokenStream> tokenStream = nil;
	if (theDebugListener) {
		dbg = theDebugListener;
	} else {
		dbg = [[DebugEventSocketProxy alloc] initWithGrammarName:[self grammarFileName] debuggerPort:-1];
	}
	if (theStream && ![theStream isKindOfClass:[DebugTokenStream class]]) {
		tokenStream = [[DebugTokenStream alloc] initWithTokenStream:theStream debugListener:dbg];
	} else {
		tokenStream = theStream;
	}
	self = [super initWithTokenStream:tokenStream State:aState];
	if (self) {
		dbg = theDebugListener;
		// [debugListener waitForDebuggerConnection];
	}
	return self;
}

- (id) initWithTokenStream:(id<TokenStream>)theStream State:(RecognizerSharedState *)aState
{
	id<TokenStream> tokenStream = nil;
	dbg = [[DebugEventSocketProxy alloc] initWithGrammarName:[self grammarFileName] debuggerPort:-1];
	if (theStream && ![theStream isKindOfClass:[DebugTokenStream class]]) {
		tokenStream = [[DebugTokenStream alloc] initWithTokenStream:theStream debugListener:dbg];
	} else {
		tokenStream = theStream;
	}
	self = [super initWithTokenStream:tokenStream State:aState];
	if (self) {
		// [debugListener waitForDebuggerConnection];
	}
	return self;
}

- (id) initWithTokenStream:(id<TokenStream>)theStream
			 DebugListener:(id<DebugEventListener>)theDebugListener
{
	id<TokenStream> tokenStream = nil;
	if (theDebugListener) {
		dbg = theDebugListener;
	} else {
		dbg = [[DebugEventSocketProxy alloc] initWithGrammarName:[self grammarFileName] debuggerPort:-1];
	}
	if (theStream && ![theStream isKindOfClass:[DebugTokenStream class]]) {
		tokenStream = [[DebugTokenStream alloc] initWithTokenStream:theStream debugListener:dbg];
	} else {
		tokenStream = theStream;
	}
	self = [super initWithTokenStream:tokenStream];
	if (self) {
		dbg = theDebugListener;
		// [debugListener waitForDebuggerConnection];
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

- (id<DebugEventListener>)getDebugListener
{
    return dbg;
}

- (void) setDebugListener: (id<DebugEventListener>) aDebugListener
{
    dbg = aDebugListener;
}

#pragma mark -
#pragma mark Overrides

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

#ifdef DONTUSEYET
public void reportError(IOException e) {
    System.err.println(e);
    e.printStackTrace(System.err);
}

public void reportError(RecognitionException e) {
    super.reportError(e);
    dbg.recognitionException(e);
}
#endif

@end
