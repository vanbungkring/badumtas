//
//  ShowEULAViewController.m
//  FZBlackBox
//
//  Created by julian Clémot on 06/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import "ShowEULAViewController.h"

//BundleHelper
#import <FZBlackBox/BundleHelper.h>

//LocalizationHelper
#import "LocalizationHelper.h"

#import <FZBlackBox/FZTargetManager.h>

@interface ShowEULAViewController ()
@property (retain, nonatomic) IBOutlet UIWebView *webViewEula;
@property (retain, nonatomic) IBOutlet UIButton *buttonAcceptEula;
@property (retain, nonatomic) IBOutlet UIButton *buttonRefuseEula;

@property (nonatomic, retain) NSString *urlOfEula;

@end

@implementation ShowEULAViewController

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"ShowEULAViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        
    }
    return self;
}

- (id)initWithUrl:(NSString *)urlOfEula
{
    self = [super initWithNibName:@"ShowEULAViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        [self setUrlOfEula:urlOfEula];
    }
    return self;
}

#pragma mark - Cycle view life

- (void)viewDidLoad
{
    [super viewDidLoad];
     NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:[self urlOfEula]]];
    [[self webViewEula] loadRequest:requestURL];
    
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Show Eula ViewController"];
    
    [_buttonAcceptEula setTitle:[LocalizationHelper stringForKey:@"accept" withComment:@"ShowEULAViewController" inDefaultBundle:FZBundlePayment] forState:UIControlStateNormal];
    [_buttonRefuseEula setTitle:[LocalizationHelper stringForKey:@"cancel" withComment:@"ShowEULAViewController" inDefaultBundle:FZBundlePayment] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_urlOfEula release];
    [_webViewEula release];
    [_buttonAcceptEula release];
    [_buttonRefuseEula release];
    [super dealloc];
}

#pragma mark - Actions

- (IBAction)actionAcceptEula:(id)sender
{
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"User has accepted the EULA"];
    if([[self delegateEula] respondsToSelector:@selector(didAcceptEula)]){
        [[self delegateEula] didAcceptEula];
    }
}

- (IBAction)actionRefuseEula:(id)sender
{
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"User has refused the EULA"];
    if([[self delegateEula] respondsToSelector:@selector(didRefuseEula)]){
        [[self delegateEula] didRefuseEula];
    }
}

#pragma mark - Lock rotation

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}


@end
