//
//  LRUCache.h
//  MusicBrowser
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CachePayload;

@interface LRUCache: NSObject<NSCoding>

@property (readonly) NSInteger capacity;

- (instancetype)initWithCapacity:(NSInteger)capacity;
- (void)setValue:(id)value forKey: (id)key;
- (id)valueForKey:(id)key;
- (CachePayload *)mostRecentPayload;
- (NSArray<CachePayload *> *) allPayloads;

@end


