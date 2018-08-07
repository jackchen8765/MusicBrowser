//
//  MusicBrowserUITests.m
//  MusicBrowserUITests
//
//  Created by Jack Chen on 7/31/18.
//  Copyright © 2018 Jack Chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MusicBrowserUITests : XCTestCase

@end

@implementation MusicBrowserUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//this tests automation
- (void) testSearchMusicAutomation {
    
    //start the app
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    //tap the search bar
    XCUIElement *songOrArtistNameSearchField = app.searchFields[@"Song or Artist Name"];
    [songOrArtistNameSearchField tap];
    
    //enter "Cars" in the search bar
    [songOrArtistNameSearchField typeText:@"cars"];
    [app typeText:@"\r"];
    
    //choose the cell with "Life Is a Highway" from found track cells
    [app.tables/*@START_MENU_TOKEN@*/.staticTexts[@"Life Is a Highway"]/*[[".cells.staticTexts[@\"Life Is a Highway\"]",".staticTexts[@\"Life Is a Highway\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    //on the track detail screen, tap the "Listen" button to listen the track
    [app.buttons[@"Listen"] tap];
    
    //on the track detail screen, tap the "TrackView" button
    //to navigate to the Track View screen in iTunes.
    [app.buttons[@"TrackView"] tap];
    
    //on the track View screen, tap the "Back" button
    //to come back to the track detail screen.
    XCUIElement *backButton = app.navigationBars[@"WebView"].buttons[@"Back"];
    [backButton tap];
    
    //on the track detail screen, tap the "ArtistView" button
    //to navigate to the artist view screen in iTunes.
    [app.buttons[@"ArtistView"] tap];
    
    //on the artist view screen, tap the "Back" button
    //to come back to the track detail screen.
    [backButton tap];
    
    //on the track detail screen, tap the button "iTune Music Search"
    //to come back to the iTunes Music Search screen
    [app.navigationBars[@"TrackDetailView"].buttons[@"iTune Music Search"] tap];
    
    
}

@end
