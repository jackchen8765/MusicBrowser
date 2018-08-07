//
//  SearchService.h
//  MusicBrowser
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Track;
@class SearchService;

typedef enum{
    TrackInfo = 0,  //for search music track
    LyricsInfo = 1  //for search lyrics of a song
} SearchServieType;


//this protocol will be adopted by those who requires search results from a SearchService instance
@protocol SearchServiceDelegate<NSObject>
- (void)serviceCompleted: (SearchService *) service withResult: (NSDictionary *)result;
- (void)serviceFailed: (SearchService *) service withError: (NSError *)error;

@end


//this class provides two kinds of services:
//1. search iTunes music tracks based on a search term.
//2. search lyrics for song specified by song and artist name.
@interface SearchService : NSObject

@property(nonatomic, readonly) SearchServieType type;

- (instancetype)init;
- (instancetype)initWithType: (SearchServieType) type;

//the track search results are returned via a completion handler
- (void)searchTracksFor: (NSString *)term completionHandler:(void (^)(NSArray<Track*> * tracks, NSError *error)) completionHander;

//the lyrics search result can also be returned via a completion handler
//but is implemented via delegation pattern intead.
- (void)searchLyricsFor: (Track *)track withDelegate: (id<SearchServiceDelegate>) delegate;

@end


