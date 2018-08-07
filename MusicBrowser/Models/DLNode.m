//
//  DLNode.m
//  AlgorithmObjC
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//



#import "DLNode.h"


@implementation DLNode

-(instancetype)initWithValue:(id)value {
    if (value == nil ) {
        return nil;
    }
    
    self = [super init];
    if (self != nil) {
        _value = value;
        self.prev = self.next = nil;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {
        _value = [aDecoder decodeObjectForKey:@"DLNode"];
        _prev = nil;
        _next = nil;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_value forKey:@"DLNode"];
}

@end

