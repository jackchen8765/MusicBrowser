//
//  Track.m
//  MusicBrowser
//
//  Created by Jack Chen on 8/2/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import "Track.h"


//hold information about a music track from iTunes and lyrics from LyricsWiki
//adopts NScoding for archiving and unarchiving
@implementation Track

- (id)initWithName: (NSString *) name
            artist: (NSString *) artist
             album: (NSString *) album
             genre: (NSString *) genre
          imageURL: (NSString *) imageURL
        previewURL: (NSString *) previewURL
     artistViewURL: (NSString *) artistViewURL
      trackViewURL: (NSString *) trackViewURL
            lyrics: (NSString *) lyrics {
    self = [super init];
    if (self != nil) {
        self.name = name;
        self.artist = artist;
        self.album = album;
        self.genre = genre;
        self.imageURL = imageURL;
        self.previewURL = previewURL;
        self.artistViewURL = artistViewURL;
        self.trackViewURL = trackViewURL;
        self.lyrics = lyrics;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self != nil) {
        self.name = [aDecoder decodeObjectForKey:@"trackName"];
        self.artist = [aDecoder decodeObjectForKey:@"artistName"];
        self.album = [aDecoder decodeObjectForKey:@"albumName"];
        self.genre = [aDecoder decodeObjectForKey:@"genre"];
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        self.previewURL = [aDecoder decodeObjectForKey:@"previewURL"];
        self.artistViewURL = [aDecoder decodeObjectForKey:@"artistViewURL"];
        self.trackViewURL = [aDecoder decodeObjectForKey:@"trackViewURL"];
        self.lyrics = [aDecoder decodeObjectForKey:@"lyrics"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (self.name != nil) [aCoder encodeObject:self.name forKey:@"trackName"];
    if (self.artist != nil) [aCoder encodeObject:self.artist forKey:@"artistName"];
    if (self.album != nil) [aCoder encodeObject:self.album forKey:@"albumName"];
    if (self.genre != nil) [aCoder encodeObject:self.genre forKey:@"genre"];
    if (self.imageURL != nil) [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    if (self.previewURL != nil) [aCoder encodeObject:self.previewURL forKey:@"previewURL"];
    if (self.artistViewURL != nil) [aCoder encodeObject:self.artistViewURL forKey:@"artistViewURL"];
    if (self.trackViewURL != nil) [aCoder encodeObject:self.trackViewURL forKey:@"trackViewURL"];
    if (self.lyrics != nil) [aCoder encodeObject:self.lyrics forKey:@"lyrics"];
}

@end
