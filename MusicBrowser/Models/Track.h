//
//  Track.h
//  MusicBrowser
//
//  Created by Jack Chen on 8/2/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject<NSCoding>

@property (nonatomic) NSString * name;
@property (nonatomic) NSString * artist;
@property (nonatomic) NSString * album;
@property (nonatomic) NSString * genre;
@property (nonatomic) NSString * imageURL;
@property (nonatomic) NSString * previewURL;
@property (nonatomic) NSString * artistViewURL;
@property (nonatomic) NSString * trackViewURL;
@property (nonatomic) NSString * lyrics;

- (id)initWithName: (NSString *) name
            artist: (NSString *) artist
             album: (NSString *) album
             genre: (NSString *) genre
          imageURL: (NSString *) imageURL
        previewURL: (NSString *) previewURL
     artistViewURL: (NSString *) artistViewURL
      trackViewURL: (NSString *) trackViewURL
            lyrics: (NSString *) lyrics;



@end
