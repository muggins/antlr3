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
#import "Parser.h"
#import "CommonTreeAdaptor.h"
#import "DebugEventListener.h"

#import "TokenStream.h"
#import "RecognitionException.h"

/**
 * A TreeAdaptor proxy that fires debugging events to a DebugEventListener
 * delegate and uses the TreeAdaptor delegate to do the actual work.  All
 * AST events are triggered by this adaptor; no code gen changes are needed
 * in generated rules.  Debugging events are triggered *after* invoking
 * tree adaptor routines.
 * 
 * Trees created with actions in rewrite actions like "-> ^(ADD {foo} {bar})"
 * cannot be tracked as they might not use the adaptor to create foo, bar.
 * The debug listener has to deal with tree node IDs for which it did
 * not see a createNode event.  A single <unknown> node is sufficient even
 * if it represents a whole tree.
 */

@interface DebugTreeAdaptor : BaseTreeAdaptor {
	id<DebugEventListener> dbg;
	CommonTreeAdaptor *adaptor;
}

@property (retain, getter=getDebugEventListener, setter = setDebugEventListener:)  id<DebugEventListener> dbg;
@property (retain, getter=getTreeAdaptor, setter = setTreeAdaptor:) CommonTreeAdaptor *adaptor;

+ (DebugTreeAdaptor *)newDebugTreeAdaptor:(CommonTreeAdaptor *)aTreeAdaptor debugListener:(id<DebugEventListener>)aDebugListener;

- (id) initWithTreeAdaptor:(CommonTreeAdaptor *)aTreeAdaptor debugListener:(id<DebugEventListener>)aDebugListener;

- (id) create:(id<Token>)payload;
- (id) errorNode:(id<TokenStream>)input start:(id<Token>)start stop:(id<Token>)stop e:(RecognitionException *)e;
- (id) dupTree:(id<Tree>)tree;
- (void) simulateTreeConstruction:(id)t;
- (id) dupNode:(id)treeNode;
// - (id) nil;
- (BOOL) isNil:(id<Tree>)tree;
- (void) addChild:(id<Tree>)child ToTree:(id<Tree>)t;
- (id) becomeRoot:(id<Tree>)newRoot oldRoot:(id<Tree>)oldRoot;
- (id) rulePostProcessing:(id<Tree>)root;
- (void) addTokenAsChild:(id<Token>)child ToTree:(id<Token>)t;
- (id) becomeRootFromToken:(id<Token>)newRoot oldRoot:(id)oldRoot;
- (id) create:(int)tokenType fromToken:(id<Token>)fromToken;
- (id) create:(int)tokenType fromToken:(id<Token>)fromToken text:(NSString *)text;
- (id) create:(int)tokenType text:(NSString *)text;
- (int) getType:(id)t;
- (void) setType:(id)t type:(int)type;
- (NSString *) getText:(id<Tree>)t;
- (void) setText:(id)t text:(NSString *)text;
- (id<Token>) getToken:(id)t;
- (void) setTokenBoundaries:(id)t From:(id<Token>)startToken To:(id<Token>)stopToken;
- (int) getTokenStartIndex:(id)t;
- (int) getTokenStopIndex:(id)t;
- (id) getChild:(id)t i:(int)i;
- (void) setChild:(id<Tree>)t i:(int)i child:(id<Tree>)child;
- (id) deleteChild:(id<Tree>)t i:(int)i;
- (int) getChildCount:(id<Tree>)t;
- (int) getUniqueID:(id)node;
- (id) getParent:(id<Tree>)t;
- (int) getChildIndex:(id<Tree>)t;
- (void) setParent:(id<Tree>)t parent:(id<Tree>)parent;
- (void) setChildIndex:(id<Tree>)t index:(int)index;
- (void) replaceChildren:(id<Tree>)parent startChildIndex:(int)startChildIndex stopChildIndex:(int)stopChildIndex t:(id<Tree>)t;
- (id<DebugEventListener>)getDebugListener;
- (void) setDebugListener:(id<DebugEventListener>)aDebugListener;

- (CommonTreeAdaptor *) getTreeAdaptor;
- (void) setTreeAdaptor:(CommonTreeAdaptor *)aTreeAdaptor;

@end
