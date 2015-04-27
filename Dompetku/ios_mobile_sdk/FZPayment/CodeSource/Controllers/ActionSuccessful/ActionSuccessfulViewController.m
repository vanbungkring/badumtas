//
//  TransferValidateViewController.m
//  iMobey
//
//  Created by Yvan Moté on 20/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "ActionSuccessfulViewController.h"

//Services
#import <FZAPI/ConnectionServices.h>

//Model
#import <FZAPI/UserSession.h>
#import <FZAPI/User.h>
#import <FZAPI/Account.h>
#import <FZBlackBox/FZTargetManager.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Image
#import <FZBlackBox/FZUIImageWithImage.h>

//BundleHelper
#import <FZBlackBox/BundleHelper.h>

//Draw
#import <QuartzCore/QuartzCore.h>

//Fonts
#import <FZBlackBox/FontHelper.h>

//Facade
#import <FZBlackBox/FlashizFacade.h>


/*
 #import "Reachability.h"
 #import <SystemConfiguration/SystemConfiguration.h>
 */

@interface ActionSuccessfulViewController ()
{
    
}

//View
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIButton *btnOk;
@property (retain, nonatomic) IBOutlet UIView *backgroundView;
@property (retain, nonatomic) IBOutlet UIButton *btnImageCenter;
@property (retain, nonatomic) IBOutlet UIImageView *imgBackground;

//Model
@property (retain, nonatomic) UIColor *backgroundColor;
@property (retain, nonatomic) NSString *titleView;
@property (retain, nonatomic) NSString *arrowImageName;
@property (retain, nonatomic) UIImage *arrowImage;
@property (retain, nonatomic) NSString *backgroundImageName;
@property (assign, nonatomic) FZBundleName bundlName;

@property (nonatomic, assign) BOOL isBtnImageCenterForcedHide;

//Error
@property (retain, nonatomic) Error *currentError;

@end

@implementation ActionSuccessfulViewController
@synthesize comeFromForgottenPassword;
@synthesize btnImageCenterName;
@synthesize delegate = _delegate;

#pragma mark - Init

- (id)initWithTitle:(NSString*)titleView andBackgroundColor:(UIColor *)backgroundColor andArrowImage:(UIImage *)image
{
    return [self initWithTitle:titleView andBackgroundColor:backgroundColor andArrowImage:image andError:nil];
}

- (id)initWithTitle:(NSString*)titleView andBackgroundColor:(UIColor *)backgroundColor andArrowImage:(UIImage *)image andError:(Error *) anError {
    self = [super initWithNibName:@"ActionSuccessfulViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        [self setBackgroundColor:backgroundColor];
        [self setTitleView:titleView];
        [self setArrowImage:image];
        if(anError){
            [self setBtnImageCenterName:@"x_big"];
            [self setIsBtnImageCenterForcedHide:NO];
        } else {
            [[self imgBackground] setImage:[FZUIImageWithImage imageNamed:@"icon_check_round" inBundle:FZBundlePayment]];
        }
        [self setComeFromForgottenPassword:NO];
        [self setCurrentError:anError];
        [self setCanDisplayMenu:NO];
    }
    return self;
}

- (id)initWithTitle:(NSString *)titleView andBackgroundColor:(UIColor *)backgroundColor andArrowImage:(UIImage*)image andBackgroundImage:(NSString *)bgdImageName inBundleName:(FZBundleName)aBundleName {
    return [self initWithTitle:titleView andBackgroundColor:backgroundColor andArrowImage:image andBackgroundImage:bgdImageName inBundleName:aBundleName andError:nil];
}

- (id)initWithTitle:(NSString *)titleView andBackgroundColor:(UIColor *)backgroundColor andArrowImage:(UIImage*)image andBackgroundImage:(NSString *)bgdImageName inBundleName:(FZBundleName)aBundleName andError:(Error *) anError
{
    self = [super initWithNibName:@"ActionSuccessfulViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        [self setBackgroundColor:backgroundColor];
        [self setTitleView:titleView];
        [self setArrowImage:image];
        if(anError){
            [self setBtnImageCenterName:@"x_big"];
            [self setIsBtnImageCenterForcedHide:NO];
        } else {
            [self setBackgroundImageName:bgdImageName];
        }
        [self setBundlName:aBundleName];
        [self setComeFromForgottenPassword:NO];
        [self setCurrentError:anError];
        [self setCanDisplayMenu:NO];
    }
    return self;
}

#pragma mark - View cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_lblTitle setText:[_titleView uppercaseString]];
    
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)setupView
{
    [_lblTitle setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:25.0f]];
    [[self backgroundView]setBackgroundColor:[_backgroundColor colorWithAlphaComponent:1.0f]];
    [[[self backgroundView] layer] setCornerRadius:4];
    [_btnOk setTitleColor:_backgroundColor forState:UIControlStateNormal];
    [_btnOk setTitleColor:_backgroundColor forState:UIControlStateHighlighted];
    [_btnOk setBackgroundColor:[[ColorHelper sharedInstance] whiteColor]];
    
    [[_btnOk titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:18.0f]];
    [_btnOk setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    
    [_btnOk setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    
    if(nil!=_arrowImage) {
        [_btnOk setImage:_arrowImage forState:UIControlStateNormal];
    }
    
    if([_arrowImageName length]>0) {
        [_btnOk setImage:[FZUIImageWithImage imageNamed:_arrowImageName inBundle:FZBundleBlackBox] forState:UIControlStateNormal];
    }
    
    _btnOk.layer.cornerRadius = 2;
    
    [_imgBackground setImage:[FZUIImageWithImage imageNamed:_backgroundImageName inBundle:_bundlName]];
    [[_imgBackground layer] setCornerRadius:4];
    [[_imgBackground layer] setMasksToBounds:YES];
    
    if(nil==btnImageCenterName){
        btnImageCenterName = @"icon_check_round";
    }
    
    UIImage *image = [FZUIImageWithImage imageNamed:btnImageCenterName inBundle:FZBundleBlackBox];
    
    [_btnImageCenter setBackgroundImage:image forState:UIControlStateNormal];
    [_btnImageCenter setBounds:CGRectMake([_btnImageCenter frame].origin.x + [_backgroundView frame].origin.x, [_btnImageCenter frame].origin.y, image.size.width, image.size.height)];
    
    CGRect btnImageCenterFrame = [_btnImageCenter frame];
    btnImageCenterFrame.origin.y = [[self view] bounds].size.width - [_btnImageCenter bounds].size.width/2;
    [_btnImageCenter  setFrame:btnImageCenterFrame];
    
    [_btnImageCenter setHidden:_isBtnImageCenterForcedHide];
    _isBtnImageCenterForcedHide = NO;
}

- (void)forceHideBtnImageCenter {
    _isBtnImageCenterForcedHide = YES;
}

#pragma mark - Action method

- (IBAction)validateAction:(id)sender {
    
    if([[FZTargetManager sharedInstance]mainTarget]!=FZBankSDKTarget){ //Applications
        // No need refresh for anonymous user
        {
            if(!comeFromForgottenPassword){
                
                NSString *currentUserKey = [[UserSession currentSession] userKey];
                
                //updating the user infos
                [ConnectionServices retrieveUserInfos:currentUserKey successBlock:^(id context) {
                    
                    [[UserSession currentSession] setUser:context];
                    
                } failureBlock:^(Error *error) {
                    
                    FZPaymentLog(@"update account balance error : %@",error);
                    
                    [self displayAlertForError:error];
                }];
            }
        }
    } else { //SDK
        
        FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
        
        if([facade respondsToSelector:@selector(isClosingSdkAfterUnknownError)]) {
            
            if([facade isClosingSdkAfterUnknownError] && [facade unknownErrorOccured]) {
                [facade setUnknownErrorOccured:NO];
                
                if ([_delegate respondsToSelector:@selector(paymentCheckViewControllerSdkClose)]) {
                    [facade showDebugLog:@"close SDK"];
                    [_delegate paymentCheckViewControllerSdkClose];
                }
            }
        }
        
    }
    /*
    if([[FZTargetManager sharedInstance]mainTarget]==FZBankSDKTarget){
        
        if(!([self currentError] && [[self currentError] errorCode] == 10010)) {
            if([[[FZTargetManager sharedInstance] delegateSDK] respondsToSelector:@selector(isClosingSdkAfterPaymentFailedOrSucceeded)]) {
                if([[[FZTargetManager sharedInstance] delegateSDK] isClosingSdkAfterPaymentFailedOrSucceeded]) {
                    if ([_delegate respondsToSelector:@selector(paymentCheckViewControllerSdkClose)]) {
                        [[[FZTargetManager sharedInstance] facade] showDebugLog:@"close SDK"];
                        [_delegate paymentCheckViewControllerSdkClose];
                    }
                }
            }
            
            if([[[FZTargetManager sharedInstance] delegateSDK] respondsToSelector:@selector(qrCodeisInvalid)]) {
                
                [[[FZTargetManager sharedInstance] delegateSDK] qrCodeisInvalid];
                
            }
            
            if([[[FZTargetManager sharedInstance] delegateSDK] respondsToSelector:@selector(isClosingSdkAfterUnknownError)]) {
                
                if([[[FZTargetManager sharedInstance] delegateSDK] isClosingSdkAfterUnknownError] && [[[FZTargetManager sharedInstance] facade] unknownErrorOccured]) {
                    [[[FZTargetManager sharedInstance] facade] setUnknownErrorOccured:NO];
                    [[[FZTargetManager sharedInstance] facade] showDebugLog:@"close SDK"];
                    [_delegate paymentCheckViewControllerSdkClose];
                }
            }
        } //else it means that there is no internet connection and the message has already been displayed
    }
     */
    
    if([_delegate respondsToSelector:@selector(didValidate:)]) {
        [_delegate didValidate:self];
    }
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_backgroundView release], _backgroundView = nil;
    [_titleView release],_titleView = nil;
    [_backgroundColor release],_backgroundColor = nil;
    [_lblTitle release];
    [_btnOk release];
    [_imgBackground release];
    [_backgroundImageName release];
    [_btnImageCenter release];
    [btnImageCenterName release];
    [_currentError release];
    [super dealloc];
}

@end
