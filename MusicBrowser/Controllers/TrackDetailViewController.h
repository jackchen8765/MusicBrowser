//
//  TrackDetailViewController.h
//  MusicBrowser
//
//  Created by Jack Chen on 8/3/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Track;

@interface TrackDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UITextView *lyricsTextView;
@property (weak, nonatomic) IBOutlet UIButton *listenButton;
@property (weak, nonatomic) IBOutlet UIButton *trackViewButton;
@property (weak, nonatomic) IBOutlet UIButton *artistViewButton;

@property (nonatomic) Track * track;
- (IBAction)listen:(UIButton *)sender;
- (IBAction)viewTrack:(UIButton *)sender;
- (IBAction)viewArtist:(UIButton *)sender;

@end
