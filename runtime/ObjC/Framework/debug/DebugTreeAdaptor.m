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

#import "DebugTreeAdaptor.h"


@implementation DebugTreeAdaptor

@synthesize dbg;
@synthesize adaptor;

+ (DebugTreeAdaptor *)newDebugTreeAdaptor:(CommonTreeAdaptor *)aTreeAdaptor debugListener:(id<DebugEventListener>)aDebugListener
{
    return [[DebugTreeAdaptor alloc] initWithTreeAdaptor:aTreeAdaptor debugListener:aDebugListener];
}


- (id) initWithTreeAdaptor:(CommonTreeAdaptor *)aTreeAdaptor debugListener:(id<DebugEventListener>)aDebugListener
{
	self = [super init];
	if (self) {
		self.dbg = aDebugListener;
		self.adaptor = aTreeAdaptor;
	}
	return self;
}

- (void) dealloc
{
    [self setDebugListener: nil];
    [self setTreeAdaptor: nil];
}

- (id) create:(CommonToken *)payload
{
    if ( payload.index < 0 ) {
        // could be token conjured up during error recovery
        return [self createToken:payload.type Text:payload.text];
    }
    id node = [adaptor create:payload];
    [dbg createNode:node token:payload];
    return node;
}
         
- (CommonToken *)createToken:(NSInteger) tokenType Text:(NSString *)text
{
    return [CommonToken newToken:tokenType Text:text];
}

- (id<DebugEventListener>)getDebugListener
{
    return dbg;
}

- (void) setDebugListener: (id<DebugEventListener>) aDebugListener
{
    dbg = aDebugListener;
}

- (CommonTreeAdaptor *) getAdaptor
{
    return adaptor; 
}

- (void) setAdaptor: (CommonTreeAdaptor *) aTreeAdaptor
{
    adaptor = aTreeAdaptor;
}

#pragma mark -
#pragma mark Proxy implementation

// anything else that hasn't some debugger event assicioated with it, is simply
// forwarded to the actual token stream
- (void) forwardInvocation:(NSInvocation *)anInvocation
{
	[anInvocation invokeWithTarget:[self getTreeAdaptor]];
}

#pragma mark -

#pragma mark Construction

- (id<BaseTree>) newTreeWithToken:(id<Token>) payload
{
	id<BaseTree> newTree = [CommonTree newTreeWithToken:payload];
	[dbg createNode:newTree token:payload];
	return newTree;
}

/*	We don't have debug events for those:
 - (id) copyNode:(id<BaseTree>)aNode
{
}
- (id) copyTree:(id<BaseTree>)aTree
{
}
*/

- (void) addChild:(id<BaseTree>)child toTree:(id<BaseTree>)aTree
{
	[adaptor addChild:child toTree:aTree];
	[dbg addChild:aTree child:child];
}

- (id<BaseTree>) becomeRoot:(id<BaseTree>)newRoot old:(id<BaseTree>)oldRoot
{
	id<BaseTree> newTree = [adaptor becomeRoot:newRoot old:oldRoot];
	[dbg becomeRoot:newTree old:oldRoot];
	return newTree;
}

/* handle by forwardInvocation: 
- (NSUInteger) uniqueIdForTree:(id<BaseTree>)aNode
{
}
*/

#pragma mark Rewrite Rules
- (void) addTokenAsChild:(id<Token>)child toTree:(id<BaseTree>)aTree;
{
	id<BaseTree> newChild = [self newTreeWithToken:child];
	[self addChild:newChild toTree:aTree];
}

- (id<BaseTree>) becomeRootfromToken:(id<Token>)aNewRoot old:(id<BaseTree>)oldRoot
{
	id<BaseTree> newTree = [adaptor becomeRoot:aNewRoot old:oldRoot];
	[dbg becomeRoot:newTree old:oldRoot];
	return newTree;
}

- (id<BaseTree>) create:(NSInteger)tokenType token:(id<Token>)fromToken
{
    id<BaseTree> node = [adaptor createTree:tokenType FromToken:fromToken];
    [dbg createNode:node];
    return node;
}

- (id<BaseTree>) create:(NSInteger)tokenType FromToken:(id<Token>)fromToken text:(NSString *) text
{
    id<BaseTree> node = [adaptor createTree:tokenType FromToken:fromToken Text:text];
    [dbg createNode:node];
    return node;
}

- (id<BaseTree>) create:(NSInteger)tokenType Text:(NSString *)text
{
    id<BaseTree> node = [adaptor createTree:tokenType Text:text];
    [dbg createNode:node];
    return node;
}

#pragma mark Content

- (void) setTokenBoundaries:(id<BaseTree>)aTree From:(id<Token>)startToken To:(id<Token>)stopToken
{
	[adaptor setTokenBoundaries:aTree From:startToken To:stopToken];
	if (aTree && startToken && stopToken) {
		[dbg setTokenBoundaries:aTree From:startToken To:stopToken];
	}
}
/* handled by forwardInvocation:
- (NSInteger) tokenStartIndexForTree:(id<BaseTree>)aTree
{
}
 
- (NSInteger) tokenStopIndexForTree:(id<BaseTree>)aTree
{
}
*/

#pragma mark Navigation / Tree Parsing
/* handled by forwardInvocation:
- (id<BaseTree>) childForNode:(id<BaseTree>) aNode atIndex:(NSInteger) i
{
}
 
- (NSInteger) childCountForTree:(id<BaseTree>) aTree
{
}
*/

@end
