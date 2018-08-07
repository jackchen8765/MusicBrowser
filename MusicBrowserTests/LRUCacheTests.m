//
//  LRUCacheTests.m
//  MusicBrowserTests
//
//  Created by Jack Chen on 8/4/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LRUCache.h"
#import "CachePayLoad.h"

@class TestObject;

@interface LRUCacheTests : XCTestCase

@property (nonatomic) LRUCache * cache;
@property (nonatomic) NSMutableArray<TestObject *> * values; //store some test values
@property (nonatomic) NSMutableArray<NSString *> * keys; //store some test keys

@end


//helper class for testing LRUCache
@interface TestObject : NSObject <NSCoding>

@property (nonatomic, strong) NSString *value;

+ (instancetype)objectWithValue:(NSString *)value;

@end


@implementation LRUCacheTests

//This method is called before the invocation of each test method in the class.
- (void)setUp {
    [super setUp];

    self.cache = [[LRUCache alloc] initWithCapacity:5];
    
    NSInteger count = 10;
    self.values = [NSMutableArray arrayWithCapacity:count];
    self.keys = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i <= count; i++) {
        [self.values addObject: [self testObj: i]];
        [self.keys addObject: [self key: i]];
    }
}

- (void)testCacheStoreValue {
    NSInteger i = 0;

    [self.cache setValue: self.values[i] forKey: self.keys[i]];
    
    XCTAssert([[self.cache valueForKey: self.keys[i]] isEqual: self.values[i]], @"LRUCache should store value");
}

- (void)testCacheStoreMultipleValues {
    
    for (NSInteger i = 1; i <= 3; i++) {
        [self.cache setValue: self.values[i] forKey: self.keys[i]];
    }
    
    
    XCTAssert([[self.cache valueForKey: self.keys[1]] isEqual: self.values[1]] &&
              [[self.cache valueForKey: self.keys[2]] isEqual: self.values[2]] &&
              [[self.cache valueForKey: self.keys[3]] isEqual: self.values[3]], @"LRUCache should store multiple values");
}

- (void)testCacheMostRecentValue {
    
    LRUCache * theCache = [[LRUCache alloc] initWithCapacity:3];
    
    for (NSInteger i = 1; i <= 3; i++) {
        [theCache setValue: self.values[i] forKey: self.keys[i]];
    }
    
    XCTAssert([theCache.mostRecentPayload.value isEqual:self.values[3]], @"Most recent value should the last accessed or stored value");
}

- (void)testCacheRemovingLeastRecentValue {
    LRUCache * theCache = [[LRUCache alloc] initWithCapacity:2];
    
    for (NSInteger i = 1; i <= 3; i++) {
        [theCache setValue: self.values[i] forKey: self.keys[i]];
    }
    XCTAssertFalse([theCache valueForKey:self.values[1]], @"The least recent value should be removed when cache capacity was already reached over.");
}

- (void)testArchivingCache {
    for (NSInteger i = 1; i <= 3; i++) {
        [self.cache setValue: self.values[i] forKey: self.keys[i]];
    }
    
    NSData *archivedCache = [NSKeyedArchiver archivedDataWithRootObject:self.cache];
    
    LRUCache * theRestoredCache = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCache];
    
    XCTAssert([[theRestoredCache valueForKey: self.keys[1]] isEqual: self.values[1]] &&
              [[theRestoredCache valueForKey: self.keys[2]] isEqual: self.values[2]] &&
              [[theRestoredCache valueForKey: self.keys[3]] isEqual: self.values[3]], @"Unarchived values should be equal to the original archived ones");
    
}

#pragma mark - helper methods

- (TestObject *)testObj: (NSInteger)i {
    NSString * value = [NSString stringWithFormat:@"value%ld", (long)i];
    return [TestObject objectWithValue: value];
}

- (NSString *)key : (NSInteger)i {
    return [NSString stringWithFormat:@"key%ld", (long)i];
}


@end


@implementation TestObject

+ (instancetype)objectWithValue:(NSString *)value {
    TestObject *obj = [TestObject new];
    obj.value = value;
    return obj;
}

- (NSUInteger)hash {
    return [self.value hash];
}

- (BOOL)isEqual:(TestObject *)object {
    return [self.value isEqualToString:object.value];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _value = [aDecoder decodeObjectForKey:@"value"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.value forKey:@"value"];
}


@end
