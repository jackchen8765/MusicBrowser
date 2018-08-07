//
//  TrackDetailViewController.m
//  MusicBrowser
//
//  Created by Jack Chen on 8/3/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TrackDetailViewController.h"
#import "WebViewController.h"
#import "SearchService.h"
#import "Track.h"

@interface TrackDetailViewController ()<SearchServiceDelegate>

@property (nonatomic) SearchService * service;
@property (nonatomic) Boolean playing;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayerItem *playerItem;



@end

@implementation TrackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.track != nil) {
        
        self.trackNameLabel.text = self.track.name;
        self.artistNameLabel.text = self.track.artist;
        self.albumLabel.text = self.track.album;
        self.genreLabel.text = self.track.genre;
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.track.imageURL]
                          placeholderImage:[UIImage imageNamed:@"placeHolder"]];
        
        if ([self.track.lyrics length] > 0) {
            self.lyricsTextView.text = self.track.lyrics;
        }
        else {
            _service = [[SearchService alloc] initWithType:LyricsInfo];
            [_service searchLyricsFor:self.track withDelegate:self];
        }
        
        NSURL *url = [NSURL URLWithString:self.track.previewURL];
        
        _playerItem = [AVPlayerItem playerItemWithURL:url];
        
        _player = [AVPlayer playerWithPlayerItem: _playerItem];
        _player = [AVPlayer playerWithURL:url];
        
        //observing the completion play event
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        
        _playing = NO;
        
    }
 
}

-(void) viewWillDisappear:(BOOL)animated {
    if (self.playing) {
        [self.player pause];
        self.playing = NO;
        [self.listenButton setTitle:@"Listen" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    //the stream playback is completed
    self.playing = NO;
    
    //rewind to allow for playing again
    [self.player seekToTime:kCMTimeZero];
    
    [self.listenButton setTitle:@"Listen" forState:UIControlStateNormal];
}


#pragma mark - SearchServiceDelegate
- (void)serviceCompleted: (SearchService *) service withResult: (NSDictionary *)result{
    if (service.type == LyricsInfo) {
        NSString * lyrics = [result objectForKey:@"lyrics"];
        if ([lyrics length] > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.track.lyrics = lyrics;
                self.lyricsTextView.text = lyrics;
            });
        }
    }
}

- (void)serviceFailed: (SearchService *) service withError: (NSError *)error{
    if (service.type == LyricsInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lyricsTextView.text = @"No Found";
        });
    }
}

#pragma mark - IBAction

//toggle between "Pause" and "Listen"
- (IBAction)listen:(UIButton *)sender {
    if (!self.playing) {
        [self.player play];
        [self.listenButton setTitle:@"Pause" forState:UIControlStateNormal];
        self.playing = YES;
    }
    
    else {
        self.playing = NO;
        [self.player pause];
        [self.listenButton setTitle:@"Listen" forState:UIControlStateNormal];
    }
}

//navigate to the Track View page of iTunes
- (IBAction)viewTrack:(UIButton *)sender {
    WebViewController * webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webVC.urlString = self.track.trackViewURL;
    [self.navigationController pushViewController:webVC animated:YES];
}


//navigate to the Artist View page of iTunes
- (IBAction)viewArtist:(UIButton *)sender {
    WebViewController * webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webVC.urlString = self.track.artistViewURL;
    [self.navigationController pushViewController:webVC animated:YES];
}
@end
