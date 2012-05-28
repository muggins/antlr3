// $ANTLR 3.4 /Users/acondit/source/antlr/code/antlr3/runtime/ObjC/Framework/examples/polydiff/PolyPrinter.g 2012-05-25 18:42:52

/* =============================================================================
 * Standard antlr OBJC runtime definitions
 */
#import <Foundation/Foundation.h>
#import <ANTLR/ANTLR.h>
#import <ST4/ST.h>

/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

/* treeParserHeaderFile */
#ifndef ANTLR3TokenTypeAlreadyDefined
#define ANTLR3TokenTypeAlreadyDefined
typedef enum {
    ANTLR_EOF = -1,
    INVALID,
    EOR,
    DOWN,
    UP,
    MIN
} ANTLR3TokenType;
#endif

#pragma mark Tokens
#ifndef TOKENLISTAlreadyDefined
#define TOKENLISTAlreadyDefined 1
#ifdef EOF
#undef EOF
#endif
#define EOF -1
#define T__8 8
#define T__9 9
#define ID 4
#define INT 5
#define MULT 6
#define WS 7
#endif
#pragma mark Dynamic Global Scopes globalAttributeScopeInterface
#pragma mark Dynamic Rule Scopes ruleAttributeScopeInterface
#pragma mark Rule Return Scopes returnScopeInterface
/* returnScopeInterface PolyPrinter_poly_return */
@interface PolyPrinter_poly_return : TreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ST returnInterface.memVars */
ST *st; /* ObjC start of memVars() */

}
/* start property declarations */
/* ST returnScope.properties */
@property (retain, getter=getST, setter=setST:) ST *st;

/* start of method declarations */

+ (PolyPrinter_poly_return *)newPolyPrinter_poly_return;
/* this is start of set and get methods */
/* ST AST returnScopeInterface.methodsDecl */
- (id) getTemplate;
- (NSString *) description;  /* methodsDecl */

@end /* end of returnScopeInterface interface */



/* Interface grammar class */
@interface PolyPrinter  : TreeParser { /* line 572 */
#pragma mark Dynamic Rule Scopes ruleAttributeScopeDecl
#pragma mark Dynamic Global Rule Scopes globalAttributeScopeMemVar


/* ObjC start of actions.(actionScope).memVars */
/* ObjC end of actions.(actionScope).memVars */
/* ObjC start of memVars */
/* ST genericParserHeaderFile.memVars -- empty now */
STGroup *group; /* ST -- really a part of STAttrMap */
/* ObjC end of memVars */

 }

/* ObjC start of actions.(actionScope).properties */
/* ObjC end of actions.(actionScope).properties */
/* ObjC start of properties */
/* ST genericParser.properties */
@property (retain, getter=getGroup, setter=setGroup:) STGroup *group;
/* ObjC end of properties */

+ (void) initialize;
+ (PolyPrinter *) newPolyPrinter:(id<TreeNodeStream>)aStream;
/* ObjC start of actions.(actionScope).methodsDecl */
/* ObjC end of actions.(actionScope).methodsDecl */

/* ObjC start of methodsDecl */
/* ST genericParser.methodsDecl */
- init;
- (STGroup *) getGroup;
- (void) setGroup:(STGroup *)aGroup;

- (PolyPrinter_poly_return *)poly; 


@end /* end of PolyPrinter interface */

