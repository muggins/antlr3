#import <Foundation/Foundation.h>
#import <ANTLR/ANTLR.h>
#import "PolyLexer.h"
#import "PolyParser.h"
#import "PolyDifferentiator.h"
#import "PolyPrinter.h"
#import "Simplifier.h"


int main(int argc, const char *argv[])
{
    NSError *error;
    NSLog(@"starting polydiff\n");
    //	NSString *input = [NSString stringWithContentsOfFile:@"../../examples/polydiff/input"  encoding:NSASCIIStringEncoding error:&error];
	NSString *input = @"2x^3 + x^5 + 4x + 10x + 8x + x + 2";
	ANTLRStringStream *stream = [ANTLRStringStream newANTLRStringStream:input];
	NSLog(@"%@", input );

// BUILD AST
    PolyLexer *lex = [PolyLexer newPolyLexerWithCharStream:stream];
    CommonTokenStream *tokens = [CommonTokenStream newCommonTokenStreamWithTokenSource:lex];
    PolyParser *parser = [PolyParser newPolyParser:tokens];
    PolyParser_poly_return *r = [parser poly];
    NSLog(@"tree=%@", [r.tree descriptionTree]);

// DIFFERENTIATE
    CommonTreeNodeStream *nodes = [CommonTreeNodeStream newCommonTreeNodeStream:r.tree];
    [nodes setTokenStream:tokens];
    PolyDifferentiator *differ = [PolyDifferentiator newPolyDifferentiator:nodes];
    PolyDifferentiator_poly_return *r2 = [differ poly];
    NSLog(@"d/dx=%@", [r2.tree descriptionTree]);

// SIMPLIFY / NORMALIZE
    nodes = [CommonTreeNodeStream newCommonTreeNodeStream:r2.tree];
    [nodes setTokenStream:tokens];
    Simplifier *reducer = [Simplifier newSimplifier:nodes];
    Simplifier_poly_return *r3 = [reducer poly];
    NSLog(@"simplified=%@", [r3.tree descriptionTree]);

// CONVERT BACK TO POLYNOMIAL
    nodes = [CommonTreeNodeStream newCommonTreeNodeStream:r3.tree];
    [nodes setTokenStream:tokens];
    PolyPrinter *printer = [PolyPrinter newPolyPrinter:nodes];
    PolyPrinter_poly_return *r4 = [printer poly];
    NSLog( @"%@", [r4.st description]);

    NSLog(@"exiting PolyDiff\n");
    return 0;
}
