//
//  LRUCache.m
//  AlgorithmObjC
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//


#import "DLNode.h"
#import "DLList.h"
#import "CachePayLoad.h"
#import "LRUCache.h"



@interface LRUCache()

@property NSMutableDictionary * dict; //for quickly searching value for a key
@property DLList * list; //for quickly moving and removing nodes due to cache content changes

@end


//the
@implementation LRUCache

-(instancetype)initWithCapacity:(NSInteger)capacity {
    if (capacity < 1) {
        return nil;
    }
    
    self = [super init];
    if (self != nil) {
        _capacity = capacity;
        self.dict = [NSMutableDictionary dictionaryWithCapacity:capacity];
        self.list = [[DLList alloc] init];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {
        _capacity = [aDecoder decodeIntegerForKey:@"CacheCapacity"];
        self.dict = [NSMutableDictionary dictionaryWithCapacity:_capacity];
        self.list = [[DLList alloc] init];
        NSArray<DLNode *> * nodes = [aDecoder decodeObjectForKey:@"CachedNodesArray"];
        for (DLNode * node in [nodes reverseObjectEnumerator]) {
            CachePayload * payload = (CachePayload *) node.value;
            [self setValue:payload.value forKey:payload.key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSMutableArray<DLNode *> * savedNodes = [NSMutableArray arrayWithCapacity:self.list.count];
    
    [aCoder encodeInteger:_capacity forKey:@"CacheCapacity"];
    
    DLNode * curr = _list.head;
    while (curr != nil) {
        [savedNodes addObject:curr];
        curr = curr.next;
    }
    [aCoder encodeObject:savedNodes forKey:@"CachedNodesArray"];
}

-(void)setValue:(id)value forKey:(id)key {
    if (value == nil || key == nil) {
        return;
    }
    
    DLNode * node = self.dict[key];
    if (node == nil) {
        CachePayload * payload = [[CachePayload alloc] initWithValue:value andKey:key];
        node = [self.list addToHead:payload];
        self.dict[key] = node;
        
        if (self.list.count > self.capacity) {
            node = [self.list removeLastNode];
            payload = node.value;
            [self.dict removeObjectForKey:payload.key];
        }
    }
    else {
        [self.list moveToHead: node];
    }
}

-(id)valueForKey:(id)key {
    if(key == nil) return nil;
    
    DLNode * node = self.dict[key];
    if (node != nil) {
        CachePayload * payload = node.value;
        [self.list moveToHead:node];
        return payload.value;
    }
    return nil;
}

-(CachePayload *)mostRecentPayload {
    DLNode * head = self.list.head;
    return head != nil ? head.value : nil;
}
- (NSArray<CachePayload *> *) allPayloads{
    NSMutableArray<CachePayload *> * payloads = [NSMutableArray arrayWithCapacity:self.list.count];
    DLNode * curr = self.list.head;
    while (curr != nil) {
        [payloads addObject:curr.value];
    }
    return payloads;
}

@end

