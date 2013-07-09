
@class HashTable;

/**
 * HashTable entry.
 */

@interface HTEntry : NSObject {
    HTEntry *next;
    NSInteger hash;
    NSString *key;
    id value;
}

@property(nonatomic, copy) HTEntry  *next;
@property(assign, getter=getHash, setter=setHash:) NSInteger  hash;
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy)        id value;

+ (HTEntry *)newEntry:(NSInteger)h key:(NSString *)k value:(id)v next:(HTEntry *) n;
- (id) init:(NSInteger)h key:(NSString *)k value:(id)v next:(HTEntry *)n;
- (id) copyWithZone:(NSZone *)zone;
- (void) setValue:(id)newValue;
- (BOOL) isEqualTo:(id)o;
- (NSInteger) hash;
- (NSString *) description;
@end

/**
 * LinkedMap entry.
 */

@interface LMNode : NSObject {
    LMNode *next;
    LMNode *prev;
    id item;
}

@property(nonatomic, copy) LMNode *next;
@property(nonatomic, copy) LMNode *prev;
@property(nonatomic, copy)      id item;

+ (LMNode *) newNode:(LMNode *)aPrev element:(id)anElement next:(LMNode *)aNext;
- (id) init:(LMNode *)aPrev element:(id)anElement next:(LMNode *)aNext;
@end

