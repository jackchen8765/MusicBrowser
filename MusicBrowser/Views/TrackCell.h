//
//  TrackCell.h
//  MusicBrowser
//
//  Created by Jack Chen on 8/4/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *artWorkImageView;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;


@end
