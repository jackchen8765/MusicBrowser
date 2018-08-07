//
//  WebViewController.m
//  MusicBrowser
//
//  Created by Jack Chen on 8/4/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;


@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL * url = [NSURL URLWithString:self.urlString];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    //obsering the URL content loading progress
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    
    //initializing to the beginning
    self.progress.progress = 0.0;
}



- (void)dealloc{
    //removing self from observing the loading progress
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        //update the progress of the UIProgressView
        self.progress.progress = self.webView.estimatedProgress;
    }
    else {
        // make sure to call the superclass's implementation in the else block in case it is also implementing KVO
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma marke - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //loading is done.
    //hide the progress view
    [self.progress setHidden:YES];
}

- (void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.progress setHidden:NO];
}

@end
