//
//  SearchService.m
//  MusicBrowser
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import "SearchService.h"
#import "Track.h"

@interface SearchService()

@property (nonatomic, weak) id<SearchServiceDelegate> delegate; //delegate for lyrics search
@property (nonatomic) NSURLSession * session;
@property (nonatomic) NSURLSessionDataTask * dataTask;
@property (nonatomic) NSError * error; //to hold the any possible error from URL query

- (NSArray<Track *> *) parseTrackData:(NSData *)data; //parse the response data from iTunes music query
- (NSDictionary *) parseLyricsData:(NSData *)data; //parse the response data from LyricsWiki query

@end


@implementation SearchService

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _type = TrackInfo;
    }
    return self;
}

- (instancetype)initWithType: (SearchServieType) type {
    self = [super init];
    if (self != nil) {
        _type = type;
    }
    return self;
}

- (NSURLSession *)session {
    if (!_session) {
        // Initialize Session Configuration
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // Configure Session Configuration
        [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
        
        // Initialize Session
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    
    return _session;
}

-(void)searchTracksFor: (NSString *)term completionHandler:(void (^)(NSArray<Track*> * tracks, NSError *error)) completionHander {
    if (self.dataTask != nil) {
        [self.dataTask cancel];
    }
    
    _type = TrackInfo;
    
    //use NSURLComponents to make sure special chacters are taken care of to form a valid URL string
    NSURLComponents * components = [[NSURLComponents alloc] initWithString:@"https://itunes.apple.com/search"];
    components.query = [NSString stringWithFormat:@"term=%@", term];
    NSURL * url = components.URL;
    
    self.dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.error = error;
        
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        NSArray<Track *> * tracks = nil;
        if (error == nil && httpResponse.statusCode == 200) {
            tracks = [self parseTrackData:data];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHander(tracks, self.error);
        });
    }];
    
    [self.dataTask resume];
    
}

- (void)searchLyricsFor: (Track *)track withDelegate: (id<SearchServiceDelegate>) delegate {
    self.delegate = delegate;
    _type = LyricsInfo;
    
    self.error = nil;
    if (self.dataTask != nil) {
        [self.dataTask cancel];
    }
    
    //use NSURLComponents to make sure special chacters are taken care of to form a valid URL string
    NSURLComponents * components = [[NSURLComponents alloc] initWithString:@"http://lyrics.wikia.com/api.php"];
    components.query = [NSString stringWithFormat:@"func=getSong&artist=%@&song=%@&fmt=json", track.artist, track.name];
    NSURL * url = components.URL;
    self.dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.error = error;
        
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        if (error == nil && httpResponse.statusCode == 200) {
            NSDictionary * lyrics = [self parseLyricsData:data];
            if (self.error == nil && lyrics != nil) {
                [self.delegate serviceCompleted:self withResult:lyrics];
            }
            else {
                [self.delegate serviceFailed:self withError:error];
            }
        }
    }];
    
    [self.dataTask resume];
    
}

- (NSArray<Track *> *) parseTrackData:(NSData *)data {
    NSMutableArray<Track *> * tracks = [[NSMutableArray alloc] init];

    NSError * err = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err != nil) {
        self.error = err;
        return tracks;
    }
    
    NSArray *results = [dict objectForKey:@"results"];
    
    for (NSDictionary * trackDict in results) {
        NSString * name = [trackDict objectForKey:@"trackName"];
        NSString * artist = [trackDict objectForKey:@"artistName"];
        NSString * album = [trackDict objectForKey:@"collectionName"];
        NSString * genre = [trackDict objectForKey:@"kind"];
        NSString * imageURL = [trackDict objectForKey:@"artworkUrl100"];
        NSString * previewURL = [trackDict objectForKey:@"previewUrl"];
        NSString * artisViewURL = [trackDict objectForKey:@"artistViewUrl"];
        NSString * trackViewURL = [trackDict objectForKey:@"trackViewUrl"];
        if ([name length] > 0 && [artist length] > 0 && [album length] > 0 && [imageURL length] > 0)
        {
            Track * track = [[Track alloc] initWithName: name artist: artist album: album genre: genre imageURL: imageURL previewURL: previewURL artistViewURL: artisViewURL trackViewURL: trackViewURL lyrics:nil];
            [tracks addObject:track];
        }
    }
    return tracks;
}

//LyricsWiki API has been broken due to license issues
//As a result, the API response is not a valid JSON object.
//And a lot of times, no lyrics is not found.
- (NSDictionary *) parseLyricsData:(NSData *)data {
    NSDictionary * lyricsDict = nil;
    NSError * err = nil;
    
    /*
    LyricsaWiki API call always returns an invalid JSON object as follows.
    song = {
        'artist':'Taylor Swift',
        'song':'Look What You Made Me Do',
        'lyrics':'I don\'t like your little games\nDon\'t like your tilted stage\nThe role you made me play\nOf the fool, no, I don\'t like you\n\nI don\'t like your perfect crime\nHow you laugh when you lie\nYou said the gun was mine\nIsn\'t cool, no, I don\'t like you (oh)\n\nBut I got smarter, I got harder in the nick of time\nHoney, I rose up from the dead, I do it all the ti[...]',
        'url':'http://lyrics.wikia.com/Taylor_Swift:Look_What_You_Made_Me_Do'
    }
     
    */

    BOOL validJSON = [NSJSONSerialization isValidJSONObject:data];
    if (validJSON) {
        lyricsDict = [NSJSONSerialization JSONObjectWithData:data options:0
                                                           error:&err];
        if (err != nil) {
            self.error = err;
        }
    }
    
    else {
        NSString * song = [NSString stringWithUTF8String:[data bytes]];
        
        //to replace single quotes with double quotes in order to form a valid JSON object
        song = [song stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
        
        
        if ([song length] > 0) {
            NSRange startRange = [song rangeOfString:@"{"];
            NSRange endRange = [song rangeOfString:@"}"];
            
            //to extract substring between { and }
            if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
                NSRange range = NSMakeRange(startRange.location, endRange.location - startRange.location + 1);
                NSString * str = [song substringWithRange:range];
                NSData * lyricsData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:lyricsData options: 0 error: &err];
                if (err != nil) {
                    self.error = err;
                }
                else {
                    NSString * lyrics = [dict objectForKey:@"lyrics"];
                    //reversing double quotes back to single quotes
                    lyrics = [lyrics stringByReplacingOccurrencesOfString:@"\"" withString:@"\'"];
                    return @{@"lyrics": lyrics};
                }
            }
        }
        else {
            return @{@"lyrics": @"Not Found"};
        }
    }

    return lyricsDict;
}

@end
