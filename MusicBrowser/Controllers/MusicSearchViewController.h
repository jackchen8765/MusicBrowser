//
//  MusicSearchViewController.h
//  MusicBrowser
//
//  Created by Jack Chen on 8/1/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRUCache;

@interface MusicSearchViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) LRUCache * recentSearchResult;
@property (nonatomic) NSString * searchTerm;

@end

