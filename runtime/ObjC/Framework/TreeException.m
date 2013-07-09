//
//  TreeException.m
//  ANTLR
//
//  Created by Kay Röpke on 24.10.2006.
// [The "BSD licence"]
// Copyright (c) 2006-2007 Kay Roepke 2010 Alan Condit
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


#import "TreeException.h"


@implementation TreeException

+ (id) newException:(id<BaseTree>)theOldRoot newRoot:(id<BaseTree>)theNewRoot stream:(id<IntStream>)aStream;
{
	return [[TreeException alloc] initWithOldRoot:theOldRoot newRoot:theNewRoot stream:aStream];
}

- (id) initWithOldRoot:(id<BaseTree>)theOldRoot newRoot:(id<BaseTree>)theNewRoot stream:(id<IntStream>)aStream;
{
	if ((self = [super initWithStream:aStream reason:@"The new root has more than one child. Cannot make it the root node."]) != nil ) {
		[self setOldRoot:theOldRoot];
		[self setNewRoot:theNewRoot];
	}
	return self;
}

- (void) dealloc
{
#ifdef DEBUG_DEALLOC
    NSLog( @"called dealloc in TreeException" );
#endif
	[self setOldRoot:nil];
	[self setNewRoot:nil];
}

- (void) setNewRoot:(id<BaseTree>)aTree
{
	newRoot = aTree;
}

- (void) setOldRoot:(id<BaseTree>)aTree
{
	oldRoot = aTree;
}

- (NSString *) description
{
	 return [NSMutableString stringWithFormat:@"%@ old root: <%@> new root: <%@>", [super description], [oldRoot descriptionTree], [newRoot descriptionTree]];
}

@end
