//
//  MainPageLoadingViewController.m
//  FZBlackBox
//
//  Created by julian Clémot on 06/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import "MainPageLoadingViewController.h"
//BundleHelper
#import <FZBlackBox/BundleHelper.h>
//Domain
#import <FZAPI/User.h>
#import <FZAPI/UserSession.h>

#import "ShowEULAViewController.h"

#import "ShowEulaDelegate.h"

#import <FZBlackBox/FZTargetManager.h>

#import <QuartzCore/QuartzCore.h>

//ImageHelper
#import <FZBlackBox/FZUIImageWithImage.h>

//Color
#import <FZBlackBox/ColorHelper.h>

#import "FZUIColorCreateMethods.h"

#define kBoltLayer @"bolt"

#ifdef __IPHONE_7_0
# define STATUS_STYLE UIStatusBarStyleLightContent
#else
# define STATUS_STYLE UIStatusBarStyleBlackTranslucent
#endif

@interface MainPageLoadingViewController ()

@property (retain, nonatomic) IBOutlet UIImageView *imageViewPoweredByFlashiz;

@end

@implementation MainPageLoadingViewController

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"MainPageLoadingViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        
    }
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"Show loading ViewController"];

    [_imageViewPoweredByFlashiz setImage:[FZUIImageWithImage imageNamed:@"powered_white" inBundle:FZBundleBankSDK]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self showAnimation:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self showAnimation:NO];
}


#pragma mark - Animation

-(CAGradientLayer*)gradient
{
    //set gradient color
    CAGradientLayer *grLayer = [CAGradientLayer layer];
    [grLayer setFrame: [[[self view] layer] bounds]];
    [grLayer setName:kBoltLayer];
    
    UIColor *color1     = [[ColorHelper sharedInstance] pinViewController_gradient_top];
    UIColor *color2     = [[ColorHelper sharedInstance] pinViewController_gradient_bottom];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)[color1 CGColor],(id)[color2 CGColor],nil];
    
    [grLayer setColors:colors];
    
    NSNumber *stop1  = [NSNumber numberWithFloat:0.2];
    NSNumber *stop2  = [NSNumber numberWithFloat:0.8];
    
    NSArray *locations = [NSArray arrayWithObjects:stop1,stop2,nil];
    
    [grLayer setLocations:locations];
    [grLayer setName:@"test"];
    
    //assign gradient to the view background
    
    [[[self view] layer] insertSublayer:grLayer atIndex:0];
    
    return grLayer;
}

-(void)showAnimation:(bool)animated
{
    if(animated){
        
        [self gradient];
        
        UIImage *image = [FZUIImageWithImage imageNamed:@"bolt_white" inBundle:FZBundleBlackBox];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        
        CGRect screen = [[UIScreen mainScreen] applicationFrame];
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
            screen.size.height += 20;
        }
        
        CGPoint center = CGPointMake(screen.size.width/2,screen.size.height/2);
        
        [imageView setCenter:center];
        [[self view]addSubview:imageView];
        
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationRepeatCount:INFINITY];
        [UIView setAnimationRepeatAutoreverses:YES];
        imageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
        
        [imageView setAlpha:0.0];
        
        [UIView setAnimationDuration:1.0];
        imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [imageView setAlpha:0.5];
        
        [UIView commitAnimations];
        
        [imageView release];
    }else{
        //Clean layer animation when release
        [[[self view]layer] removeAllAnimations];
    }
}

#pragma mark - Private methods

- (void)showNext
{
    
}

#pragma mark - Status bar

- (UIStatusBarStyle)preferredStatusBarStyle{
    return STATUS_STYLE;
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self showAnimation:NO];
    
    if(_imageViewPoweredByFlashiz){
        [_imageViewPoweredByFlashiz release], _imageViewPoweredByFlashiz = nil;
    }
    [super dealloc];
}
@end
