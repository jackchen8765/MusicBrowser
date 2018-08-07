//
//  DLList.h
//  MusicBrowser
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLNode;

@interface DLList: NSObject<NSCoding>

@property (readonly) NSInteger count;
@property (nonatomic) DLNode * head;
@property (nonatomic) DLNode * tail;

-(instancetype)init;
-(instancetype)initWithObj: (id)obj;
-(NSInteger)count;
-(id)first;
-(id)last;
-(void)append:(id)obj;
-(void)preAppend:(id)obj;
-(void)moveToHead:(DLNode*)node;
-(DLNode *)addToHead:(id)obj;
-(DLNode *) removeLastNode;

+(DLNode *)makeDLNode: (id)obj withPrev:(DLNode *)prev andNext:(DLNode *)next;

@end


