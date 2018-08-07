//
//  DLList.m
//  MusicBrowser
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//


#import "DLNode.h"
#import "DLList.h"

//The doubly linked list is used in the LRUCache for quickly moving and removing nodes
@implementation DLList

-(instancetype)init{
    self = [super init];
    if (self != nil) {
        _count = 0;
        self.head = nil;
        self.tail = nil;
    }
    return self;
}

-(instancetype)initWithObj:(id)obj {
    self = [super init];
    if (self != nil) {
        DLNode * node = [[DLNode alloc] initWithValue:obj];
        self.head = node;
        self.tail = node;
        _count = 1;
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        NSArray<DLNode *> * savedNodes = [aDecoder decodeObjectForKey:@"DLListArray"];
        _count = 0;
        _head = nil;
        _tail = nil;
        for (DLNode * node in savedNodes) {
            [self append:node.value];
        }

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSMutableArray<DLNode*> * toSaveNodes = [NSMutableArray arrayWithCapacity:_count];
    DLNode * curr = _head;
    while (curr != nil) {
        [toSaveNodes addObject:curr];
        curr = curr.next;
    }
    [aCoder encodeObject: toSaveNodes forKey:@"DLListArray"];
}


-(id)first {
    return (self.head != nil) ? self.head.value : nil;
}

-(id)last {
    return (self.tail != nil) ? self.tail.value : nil;
}

-(void)preAppend:(id)obj {
    DLNode * node = [DLList makeDLNode:obj withPrev:nil andNext:self.head];
    if(self.count == 0) {
        self.tail = node;
    }

    self.head = node;
    _count++;
}

-(void)append:(id)obj {
    DLNode * node = [DLList makeDLNode:obj withPrev:self.tail andNext:nil];
    if(self.count == 0) {
        self.head = node;
    }

    self.tail = node;
    _count++;
}

-(DLNode *)addToHead:(id)obj {
    if (obj == nil) {
        return nil;
    }
    [self preAppend:obj];
    return self.head;
}

-(void)moveToHead:(DLNode*)node {
    if (self.head == node) {
        return;
    }
    
    DLNode * prevNode = node.prev;
    DLNode * nextNode = node.next;
    
    prevNode.next = nextNode;
    if (nextNode != nil) {
        nextNode.prev = prevNode;
    }
    
    node.prev = nil;
    node.next = self.head;
    self.head.prev = node;
    
    if (self.tail == node) {
        self.tail = prevNode;
    }
    
    self.head = node;
}

-(DLNode *) removeLastNode {
    if (_count == 0) {
        return nil;
    }
    
    DLNode * prevTail = self.tail.prev;
    DLNode * tailNode = self.tail;
    
    if (prevTail != nil) {
        prevTail.next = nil;
    }
    
    if (_count == 1) {
        self.head = nil;
    }
    
    self.tail = prevTail;
    _count--;
    
    return tailNode;
}

-(void)insert:(id)obj before:(DLNode*)node {
    if (obj == nil || node == nil) return;
    
    DLNode * newNode = [DLList makeDLNode:obj withPrev:node.prev andNext:node];
    if (node.prev == nil) {
        self.head = newNode;
    }
    
    if (node.next == nil) {
        self.tail = newNode;
    }
    _count++;
}

-(void)insert:(id)obj after: (DLNode *)node {
    if (obj == nil || node == nil) return;
    
    DLNode * newNode = [DLList makeDLNode:obj withPrev:node andNext:node.next];
    
    if (node.next == nil) {
        self.tail = newNode;
    }
    _count++;
    
}

-(void)remove:(id)obj {
    DLNode * node = [self search:obj];
    [self removeNode:node];
}

-(DLNode *)search:(id)obj {
    if (obj == nil) return nil;
    
    DLNode * curr = self.head;
    while (curr != nil) {
        if (obj == curr.value) {
            return curr;
        }
        curr = curr.next;
    }
    return nil;
}

-(void)removeNode:(DLNode*)node {
    if (node == nil || _count == 0) return;
    
    if (_count == 1) {
        self.head = self.tail = nil;
    }
    else if(node.prev == nil) {
        self.head = node.next;
    }
    else if(node.next == nil) {
        self.tail = node.prev;
    }
    else {
        DLNode * tmp = node.prev;
        tmp.next = node.next;
        tmp = node.next;
        tmp.prev = node.prev;
        node.prev = nil;
        node.next = nil;
    }
    _count++;
}

+(DLNode *)makeDLNode: (id)obj withPrev:(DLNode *)prev andNext:(DLNode *)next {
    if (obj == nil) {
        return nil;
    }
    DLNode * node = [[DLNode alloc] initWithValue:obj];
    node.prev = prev;
    node.next = next;
    if (prev != nil) {
        prev.next = node;
    }
    if (next != nil) {
        next.prev = node;
    }
    return node;
}


@end
