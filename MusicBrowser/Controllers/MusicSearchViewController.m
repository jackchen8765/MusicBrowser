//
//  MusicSearchViewController.m
//  MusicBrowser
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MusicSearchViewController.h"
#import "TrackDetailViewController.h"
#import "TrackCell.h"
#import "SearchService.h"
#import "LRUCache.h"
#import "CachePayLoad.h"
#import "Track.h"

@interface MusicSearchViewController ()

@property (nonatomic) SearchService * service;
@property (nonatomic) NSArray<Track*> * tracks;
@property (nonatomic) NSIndexPath * selectedIndexPath;
@end

@implementation MusicSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.service = [[SearchService alloc] init];
    
    
    //check if there was a previous saved search
    if (self.recentSearchResult != nil) {
        
        //the key of the payload holding the most recent search term
        CachePayload * mostRecent =  [self.recentSearchResult mostRecentPayload];
        if (mostRecent != nil) {
            self.searchBar.text = mostRecent.key;
            self.tracks = mostRecent.value;
            [self.tableView reloadData];
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper

- (void)doSearch{
    //trim the leading and trailing whitespace and new line characters
    NSString * trimmedTerm = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([trimmedTerm length] > 0) {
        trimmedTerm = [trimmedTerm lowercaseString];
        
        //check if the cache has a previous search result
        NSArray * cachedTracks =  [self.recentSearchResult valueForKey:trimmedTerm];
        if (cachedTracks != nil) {
            self.tracks = cachedTracks;
            [self.tableView reloadData];
            
            //this will move the search result to the head of LRUCache
            //and trigger the change event for the KVO of "searchTerm"
            self.searchTerm = trimmedTerm;
            return;
        }
        
        [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:YES];
        [self.service searchTracksFor:trimmedTerm completionHandler:^(NSArray<Track *> *tracks, NSError *error) {
            if (error == nil) {
                self.tracks = tracks;
                [self.tableView reloadData];
                
                //update the cache in a secondary thread
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //svae the result to the LRUCache
                    [self.recentSearchResult setValue:tracks forKey: trimmedTerm];
                    
                    
                    //trigger the change event for the KVO of "searchTerm"
                    self.searchTerm  = trimmedTerm;
                });
            }
            [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:NO];
        }];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    [self doSearch];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tracks.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell" forIndexPath:indexPath];

    Track * track = [self.tracks objectAtIndex:indexPath.row];
    
    //dowloading the artwork image of the track is done
    //via an open source Framework called SDWebImage which
    //asynchronously downloads the image and caches it for reuse
    //
    //this can be also done by implemented an Image Cache which asynchronously
    //downloads the image and caches it, if time allows.
    [cell.artWorkImageView sd_setImageWithURL:[NSURL URLWithString:track.imageURL]
                      placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    [cell.trackNameLabel setText:track.name];
    [cell.albumLabel setText:track.album];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"segueToTrackDetail" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TrackDetailViewController * detailVC = (TrackDetailViewController *) segue.destinationViewController;
    detailVC.track = self.tracks[self.selectedIndexPath.row];
}

@end
