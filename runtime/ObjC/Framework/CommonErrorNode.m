//
//  CommonErrorNode.m
//  ANTLR
//
// [The "BSD licence"]
// Copyright (c) 2010 Alan Condit
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

#import "CommonErrorNode.h"
#import "MissingTokenException.h"
#import "NoViableAltException.h"
#import "TreeNodeStream.h"
#import "UnwantedTokenException.h"

@implementation CommonErrorNode

+ (id) newCommonErrorNode:(id<TokenStream>)anInput
                          From:(id<Token>)aStartToken
                            To:(id<Token>)aStopToken
                     Exception:(RecognitionException *) e
{
    return [[CommonErrorNode alloc] initWithInput:anInput From:aStartToken To:aStopToken Exception:e];
}

- (id) init
{
    self = [super init];
    if ( self != nil ) {
    }
    return self;
}

- (id) initWithInput:(id<TokenStream>)anInput
                From:(id<Token>)aStartToken
                  To:(id<Token>)aStopToken
           Exception:(RecognitionException *) e
{
    self = [super init];
    if ( self != nil ) {
        //System.out.println("aStartToken: "+aStartToken+", aStopToken: "+aStopToken);
        if ( aStopToken == nil ||
            ([aStopToken getTokenIndex] < [aStartToken getTokenIndex] &&
             aStopToken.type != TokenTypeEOF) )
        {
            // sometimes resync does not consume a token (when LT(1) is
            // in follow set.  So, aStopToken will be 1 to left to aStartToken. adjust.
            // Also handle case where aStartToken is the first token and no token
            // is consumed during recovery; LT(-1) will return null.
            aStopToken = aStartToken;
        }
        input = anInput;
        startToken = aStartToken;
        stopToken = aStopToken;
        trappedException = e;
    }
    return self;
}

- (void)dealloc
{
#ifdef DEBUG_DEALLOC
    NSLog( @"called dealloc in CommonErrorNode" );
#endif
    input = nil;
    startToken = nil;
    stopToken = nil;
    trappedException = nil;
}

- (BOOL) isNil
{
    return NO;
}

- (NSInteger)type
{
    return TokenTypeInvalid;
}

- (NSString *)text
{
    NSString *badText = nil;
    if ( [startToken isKindOfClass:[self class]] ) {
        NSInteger i = [(id<Token>)startToken getTokenIndex];
        NSInteger j = [(id<Token>)stopToken getTokenIndex];
        if ( stopToken.type == TokenTypeEOF ) {
            j = [(id<TokenStream>)input size];
        }
        badText = [(id<TokenStream>)input descriptionFromStart:i ToEnd:j];
    }
    else if ( [startToken isKindOfClass:[self class]] ) {
        badText = [(id<TreeNodeStream>)input descriptionFromNode:startToken ToNode:stopToken];
    }
    else {
        // people should subclass if they alter the tree type so this
        // next one is for sure correct.
        badText = @"<unknown>";
    }
    return badText;
}

- (NSString *)description
{
    NSString *aString;
    if ( [trappedException isKindOfClass:[MissingTokenException class]] ) {
        aString = [NSString stringWithFormat:@"<missing type: %ld >",
        [(MissingTokenException *)trappedException getMissingType]];
        return aString;
    }
    else if ( [trappedException isKindOfClass:[UnwantedTokenException class]] ) {
        aString = [NSString stringWithFormat:@"<extraneous: %@, resync=%@>",
        [trappedException getUnexpectedToken],
        [self text]];
        return aString;
    }
    else if ( [trappedException isKindOfClass:[MismatchedTokenException class]] ) {
        aString = [NSString stringWithFormat:@"<mismatched token: %@, resync=%@>", trappedException.token, [self text]];
        return aString;
    }
    else if ( [trappedException isKindOfClass:[NoViableAltException class]] ) {
        aString = [NSString stringWithFormat:@"<unexpected:  %@, resync=%@>", trappedException.token, [self text]];
        return aString;
    }
    aString = [NSString stringWithFormat:@"<error: %@>",[self text]];
    return aString;
}

@synthesize input;
@synthesize startToken;
@synthesize stopToken;
@synthesize trappedException;
@end
