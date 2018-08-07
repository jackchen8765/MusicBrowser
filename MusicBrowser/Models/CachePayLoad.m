//
//  CachePayLoad.m
//  MusicBrowser
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//


#import "CachePayLoad.h"

@implementation CachePayload

-(instancetype)initWithValue:(id)value andKey:(id)key {
    if (value == nil || key == nil) {
        return nil;
    }
    
    self = [super init];
    if (self != nil){
        self.key = key;
        self.value = value;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil){
        self.key = [aDecoder decodeObjectForKey:@"CachePayloadKey"];
        self.value = [aDecoder decodeObjectForKey:@"CachePayloadValue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.key forKey:@"CachePayloadKey"];
    [aCoder encodeObject:self.value forKey:@"CachePayloadValue"];
}


@end
