//
//  DLNode.h
//  MusicBrowser
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLNode: NSObject<NSCoding>

@property (readonly) id value;
@property DLNode * prev;
@property DLNode * next;

-(instancetype) initWithValue: (id)value;

@end


