//
//  TermsOfUseViewController.m
//  iMobey
//
//  Created by Olivier Demolliens on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "TermsOfUseViewController.h"

//Color
#import "ColorHelper.h"

//Localizable
#import "LocalizationHelper.h"

//Error
#import <FZAPI/Error.h>

//Bundle Helper
#import "BundleHelper.h"



@interface TermsOfUseViewController () <UIWebViewDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsOfUseViewController
@synthesize url;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"TermsOfUseViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        // Custom initialization
        [self setTitleHeader:[LocalizationHelper stringForKey:@"termsOfUseViewController_header_title" withComment:@"TermsOfUseViewController" inDefaultBundle:FZBundleCoreUI]];
        [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
        [self setBackgroundColor:[[ColorHelper sharedInstance] blackColor]];
    }
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)viewDidLayoutSubviews {
    CGRect webViewFrame = [_webView frame];
    CGRect superViewFrame = [[[self view] superview] frame];
    webViewFrame.size.height = superViewFrame.size.height;
    [_webView setFrame:webViewFrame];
    [_webView setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - Setup view

-(void)setupView
{
    [self loadWebView];
    
    [self showCloseButton];
}

- (void)loadWebView {
    if([url length] > 0) {
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:requestURL];
    }
}

#pragma mark - CustomNavigationViewControllerAction

-(void)didGoBack:(CustomNavigationViewController *)controller {
    [[self navigationController]popViewControllerAnimated:YES];
}

- (void)didClose:(CustomNavigationViewController *)controller {

    [self dismissViewControllerAnimated:YES completion:^{}];
}



-(IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Webview Delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    Error *anError = [[Error alloc] init];
    
    if([error code] == NSURLErrorNotConnectedToInternet){
        [anError setErrorCode:FZ_NO_INTERNET_CONNECTION];
    }
    
    [self displayAlertForError:anError];
    
    [anError release];
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [url release];
    [_webView release];
    [super dealloc];
}

@end
