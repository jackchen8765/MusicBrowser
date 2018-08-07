//
//  WebViewController.h
//  MusicBrowser
//
//  Created by Jack Chen on 8/4/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController<WKNavigationDelegate>

@property (nonatomic) NSString * urlString;
@property (weak, nonatomic) IBOutlet WKWebView *webView;


@end
