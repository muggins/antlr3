//
//  BufferedTreeNodeStream.h
//  ANTLR
//
// [The "BSD licence"]
// Copyright (c) 2010 Ian Michell 2010 Alan Condit
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
#import "Tree.h"
#import "CommonTreeAdaptor.h"
#import "TokenStream.h"
#import "CommonTreeNodeStream.h"
#import "LookaheadStream.h"
#import "TreeIterator.h"
#import "IntArray.h"
#import "AMutableArray.h"

#define DEFAULT_INITIAL_BUFFER_SIZE 100
#define INITIAL_CALL_STACK_SIZE 10

#ifdef DONTUSENOMO
@interface StreamIterator : TreeIterator
{
    NSInteger idx;
    __strong BufferedTreeNodeStream *input;
    __strong AMutableArray *nodes;
}

+ (id) newStreamIterator:(BufferedTreeNodeStream *) theStream;

- (id) initWithStream:(BufferedTreeNodeStream *) theStream;

- (BOOL) hasNext;
- (id) next;
- (void) remove;
@end
#endif

@interface BufferedTreeNodeStream : NSObject <TreeNodeStream> 
{
	id up;
	id down;
	id eof;
	
	AMutableArray *nodes;
	
	id root; // root
	
	id<TokenStream> tokens;
	CommonTreeAdaptor *adaptor;
	
	BOOL uniqueNavigationNodes;
	NSInteger index;
	NSInteger lastMarker;
	IntArray *calls;
	
	NSEnumerator *e;
    id currentSymbol;
	
}

@property (copy, getter=getUp, setter=setUp:) id up;
@property (copy, getter=getDown, setter=setDown:) id down;
@property (copy, getter=eof, setter=setEof:) id eof;
@property (copy) AMutableArray *nodes;
@property (copy) id root;
@property (copy, getter=getTokenStream, setter=setTokenStream:) id<TokenStream> tokens;
@property (copy, getter=getTreeAdaptor, setter=setTreeAdaptor:) CommonTreeAdaptor *adaptor;
@property (assign, getter=getUniqueNavigationNodes, setter=setUniqueNavigationNodes:) BOOL uniqueNavigationNodes;
@property (assign) NSInteger index;
@property (assign, getter=getLastMarker, setter=setLastMarker:) NSInteger lastMarker;
@property (copy, getter=getCalls, setter=setCalls:) IntArray *calls;
@property (copy, getter=getEnum, setter=setEnum:) NSEnumerator *e;
@property (copy) id currentSymbol;

+ (BufferedTreeNodeStream *) newBufferedTreeNodeStream:(CommonTree *)tree;
+ (BufferedTreeNodeStream *) newBufferedTreeNodeStream:(id<TreeAdaptor>)adaptor Tree:(CommonTree *)tree;
+ (BufferedTreeNodeStream *) newBufferedTreeNodeStream:(id<TreeAdaptor>)adaptor Tree:(CommonTree *)tree withBufferSize:(NSInteger)initialBufferSize;

#pragma mark Constructor
- (id) initWithTree:(CommonTree *)tree;
- (id) initWithTreeAdaptor:(CommonTreeAdaptor *)anAdaptor Tree:(CommonTree *)tree;
- (id) initWithTreeAdaptor:(CommonTreeAdaptor *)anAdaptor Tree:(CommonTree *)tree WithBufferSize:(NSInteger)bufferSize;

- (void)dealloc;
- (id) copyWithZone:(NSZone *)aZone;

// protected methods. DO NOT USE
#pragma mark Protected Methods
- (void) fillBuffer;
- (void) fillBufferWithTree:(CommonTree *) tree;
- (NSInteger) getNodeIndex:(CommonTree *) node;
- (void) addNavigationNode:(NSInteger) type;
- (id) get:(NSUInteger) i;
- (id) LT:(NSInteger) k;
- (id) getCurrentSymbol;
- (id) LB:(NSInteger) i;
#pragma mark General Methods
- (NSString *) getSourceName;

- (id<TokenStream>) getTokenStream;
- (void) setTokenStream:(id<TokenStream>) tokens;
- (CommonTreeAdaptor *) getTreeAdaptor;
- (void) setTreeAdaptor:(CommonTreeAdaptor *) anAdaptor;

- (BOOL)getUniqueNavigationNodes;
- (void) setUniqueNavigationNodes:(BOOL)aVal;

- (void) consume;
- (NSInteger) LA:(NSInteger) i;
- (NSInteger) mark;
- (void) release:(NSInteger) marker;
- (void) rewind:(NSInteger) marker;
- (void) rewind;
- (void) seek:(NSInteger) idx;

- (void) push:(NSInteger) i;
- (NSInteger) pop;

- (void) reset;
- (NSUInteger) count;
- (NSEnumerator *) objectEnumerator;
- (void) replaceChildren:(id)parent From:(NSInteger)startChildIndex To:(NSInteger)stopChildIndex With:(id) t;

- (NSString *) description;
- (NSString *) description:(NSInteger)aStart ToEnd:(NSInteger)aStop;
- (NSString *) descriptionFromNode:(id)aStart ToNode:(id)aStop;

// getters and setters
- (AMutableArray *) getNodes;
- (id) eof;
- (void)setEof:(id)anEOF;

@end
