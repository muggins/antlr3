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

#import <Foundation/Foundation.h>
#import "TreeParser.h"
#import "DebugEventSocketProxy.h"
#import "DebugTreeNodeStream.h"

@interface DebugTreeParser : TreeParser {
	__strong id<DebugEventListener> dbg;
	BOOL isCyclicDecision;
}

@property (retain, getter = getDBG, setter = setDBG:) __strong id<DebugEventListener> dbg;
@property (assign) BOOL isCyclicDecision;

/** Create a normal parser except wrap the token stream in a debug
 *  proxy that fires consume events.
 */

+ (DebugTreeParser *)newDebugTreeParser:(id<TreeNodeStream>) input State:(RecognizerSharedState *)state DebugListener:(id<DebugEventListener>)dbg;
+ (DebugTreeParser *)newDebugTreeParser:(id<TreeNodeStream>) input State:(RecognizerSharedState *)state;
+ (DebugTreeParser *)newDebugTreeParser:(id<TreeNodeStream>) input DebugListener:(id<DebugEventListener>)dbg;

	// designated initializer
- (id) initWithTreeNodeStream:(id<TreeNodeStream>)theStream
                        State:(RecognizerSharedState *)state
				debugListener:(id<DebugEventListener>)theDebugListener;
- (id) initWithStream:(id<TreeNodeStream>)theInput
                State:(RecognizerSharedState *)state;
- (id) initWithTreeNodeStream:(id<TreeNodeStream>)theStream
				debugListener:(id<DebugEventListener>)theDebugListener;

- (id<DebugEventListener>) getDebugListener;
#ifdef DONTUSEYET
/** Provide a new debug event listener for this parser.  Notify the
 *  input stream too that it should send events to this listener.
 */
public void setDebugListener(DebugEventListener dbg) {
    if ( input instanceof DebugTreeNodeStream ) {
        [(DebugTreeNodeStream)input setDebugListener:dbg];
    }
    this.dbg = dbg;
}

#endif
- (void) setDebugListener: (id<DebugEventListener>) aDebugListener;

- (void)reportErrorIO:(NSException *)e;
- (void)reportError:(RecognitionException *)e;

- (void) recoverFromMismatchedToken:(id<IntStream>)inputStream
						  exception:(NSException *)e 
						  tokenType:(TokenType)ttype 
							 follow:(ANTLRBitSet *)follow;

- (id<Tree>)getMissingSymbol:(id<IntStream>)input
                   Exception:(RecognitionException *)e
                   TokenType:(NSInteger)expectedTokenType
                      Follow:(ANTLRBitSet *)follow;
@end
