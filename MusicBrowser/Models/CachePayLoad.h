//
//  CachePayLoad.h
//  MusicBrowser
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <Foundation/Foundation.h>


//this class is to hold the key/value pair as a payload
@interface CachePayload: NSObject<NSCoding>

@property id value;
@property id key;

-(instancetype)initWithValue:(id)value andKey: (id)key;

@end


