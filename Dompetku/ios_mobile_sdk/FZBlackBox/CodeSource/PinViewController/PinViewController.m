//
//  PinViewController.m
//  iMobey
//
//  Created by Yvan Moté on 09/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "PinViewController.h"

//BundleHelper
#import "BundleHelper.h"

//Color
#import "ColorHelper.h"

//Draw
#import <QuartzCore/QuartzCore.h>

//ViewControllers
#import "LoginViewController.h"
@class ActionSuccessfulViewController;

#import <FZAPI/UserSession.h>

//ODDeviceUtil
#import "ODDeviceUtil.h"

#import "TPKeyboardAvoidingScrollView.h"

//Fonts
#import "FontHelper.h"

//Util
#import "FZUIImageWithImage.h"

//TargetManager
#import "FZTargetManager.h"

//Tracker
#import "StatisticsFactory.h"

#define kGrLayerName @"grandientLayer"
#define kNoTitleViewDelta 25.0f
#define kNotificationClose @"receiveDismissAction"

#ifdef __IPHONE_7_0
# define STATUS_STYLE UIStatusBarStyleLightContent
#else
# define STATUS_STYLE UIStatusBarStyleBlackTranslucent
#endif

@interface PinViewController ()

//View
@property (retain, nonatomic) IBOutlet UILabel *personnalCodeLabel;
@property (retain, nonatomic) IBOutlet UILabel *personnalCodeInformationLabel;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;
@property (retain, nonatomic) IBOutlet UIImageView *imgViewBackgroundTop;

@property (retain, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldList;
@property (retain, nonatomic) UIButton *btnBack;
@property (assign, nonatomic) UITextField *lastTextFieldShowed;

@property (retain, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *view4Digits;

//Model
@property (retain, nonatomic) IBOutlet UIView *viewTop;
@property (retain, nonatomic) NSString *titleNavigBar;
@property (retain, nonatomic) NSString *titleView;
@property (retain, nonatomic) NSString *descriptView;
@property (assign, nonatomic) BOOL animated;
@property (assign, nonatomic) BOOL dismiss;

//PinCode override
@property (nonatomic, retain) NSString *currentPinCode;

@end

@implementation PinViewController

#pragma mark - Init

@synthesize fromWindow;
@synthesize wrongPinCode;
@synthesize noTitleMode;

- (id)init
{
    self = [super initWithNibName:@"PinViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        
    }
    return self;
}

- (id)initWithModeSmall {
    self = [super initWithNibName:@"PinViewControllerSmall" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if(self){
        
    }
    return self;
}

- (id)initWithCompletionBlock:(PinCompletionBlock)completionBlock andNavigationTitle:(NSString*)navtitle  andTitle:(NSString*)title andTitleHeader:(NSString *)headerTitle andDescription:(NSString*)description animated:(BOOL)animated modeSmall:(BOOL)isSmall
{
    if(isSmall){
        self = [super initWithNibName:@"PinViewControllerSmall" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    } else {
        self = [super initWithNibName:@"PinViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    }
    if(self) {
        [self setPinCompletionBlock:completionBlock];
        [self setTitleView:title];
        [self setDescriptView:description];
        [self setTitleNavigBar:navtitle];
        [self setTitleHeader:headerTitle];
        [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
        [self setBackgroundColor:[[ColorHelper sharedInstance] blackColor]];
        [self setAnimated:animated];
        _dismiss = NO;
        fromWindow = NO;
        wrongPinCode = 0;
        noTitleMode = NO;
    }
    return self;
}

#pragma mark - View Cycle Life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didShowKeyboard:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [self setupView];
    
    if (!_dismiss && !_animated) {
        [[_textFieldList objectAtIndex:0] becomeFirstResponder];
        [(UITextField *)[_textFieldList objectAtIndex:0] setTag:0];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(noTitleMode){
        [self noTitleView];
        noTitleMode = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_changePinEngaged) {
        // the user is not connected so the app/SDK is locked
        [[UserSession currentSession] setLocked:YES];
    }
    
    if (!_dismiss && _animated) {
        [[_textFieldList objectAtIndex:0] becomeFirstResponder];
        [(UITextField *)[_textFieldList objectAtIndex:0] setTag:0];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupView {
    
    UIColor *whiteColor = [[ColorHelper sharedInstance] whiteColor];
    
    [self setTitleColor:whiteColor];
    
    UIColor *blackColor = [[ColorHelper sharedInstance] blackColor];
    
    [self setBackgroundColor:blackColor];
    
    [_personnalCodeInformationLabel setText:_descriptView];
    [_personnalCodeLabel setText:[_titleView uppercaseString]];
    
    for (UITextField *textField in _textFieldList) {
        [textField setText:@""];
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        
        UIColor *colorThree = [[ColorHelper sharedInstance] pinViewController_colorThree];
        
        [textField setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:25.0f]];
        [textField setBackgroundColor:colorThree];
        [[textField layer]setCornerRadius:2];
        [textField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setTextAlignment:NSTextAlignmentCenter];
        [textField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    }
    
    NSArray *viewControllers = [[self navigationController] viewControllers];
    
    //Trick for the SDK to display the close button and the title in the navigation bar
    /* if([viewControllers count]>1) {
     
     [[self navigationItem] setHidesBackButton:YES];
     
     NSString *closeButtonActionString = [[_closeButton actionsForTarget:self
     forControlEvent:UIControlEventTouchUpInside] objectAtIndex:0];
     
     SEL closeButtonAction = NSSelectorFromString(closeButtonActionString);
     
     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[_closeButton imageForState:UIControlStateNormal]
     style:UIBarButtonItemStylePlain
     target:self
     action:closeButtonAction];
     
     [[self navigationItem] setRightBarButtonItem:barButton];
     
     [barButton release];
     
     [self setTitle:[_personnalCodeLabel text]];
     }*/
    
    [_closeButton setUserInteractionEnabled:_showCloseButton];
    [_closeButton setHidden:!_showCloseButton];
    
    [_view4Digits setScrollEnabled:NO];
    
    [_personnalCodeInformationLabel setFont:[[FontHelper sharedInstance] fontHelveticaNeueLightWithSize:14.0f]];
    [_personnalCodeLabel setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:24.0f]];
    
    [_imgViewBackgroundTop setImage:[FZUIImageWithImage imageNamed:@"img_pincode" inBundle:FZBundleBlackBox]];
}


#pragma mark - Keyboard tracking

- (void)willShowKeyboard:(NSNotification *)notification {
    [UIView setAnimationsEnabled:NO];
}

- (void)didShowKeyboard:(NSNotification *)notification {
    [UIView setAnimationsEnabled:YES];
}

#pragma mark - Public methods

-(void)dismissKeyboards
{
    _dismiss = YES;
    for (UITextField *textField in _textFieldList) {
        [textField resignFirstResponder];
    }
}

- (void)setCompletionBlock:(PinCompletionBlock)completionBlock andNavigationTitle:(NSString*)navtitle  andTitle:(NSString*)title andTitleHeader:(NSString *)headerTitle andDescription:(NSString*)description animated:(BOOL)animated
{
    if (completionBlock != nil) {
        [self setPinCompletionBlock:completionBlock];
    }
    
    [self setTitleView:title];
    [self setDescriptView:description];
    [self setTitleNavigBar:navtitle];
    [self setTitleHeader:headerTitle];
    [self setTitleColor:[[ColorHelper sharedInstance] whiteColor]];
    [self setBackgroundColor:[[ColorHelper sharedInstance] blackColor]];
    [self setAnimated:animated];
    
#warning can be optimized
    [self setupView];
}

- (void)forceClose {
    [self close:nil];
}

#pragma mark - Private methods

-(IBAction)close:(id)sender
{
    UserSession *userSession = [UserSession currentSession];
    [userSession storeUserKey:@""];
    [userSession setConnected:NO];
    
    //the user has close the pin code view so he is now disconnected so the app is unlocked
    [userSession setLocked:NO];
    
    [[StatisticsFactory sharedInstance] checkPointConnectPincodeQuit];
    if (fromWindow) {
        if([self presentingViewController]!=nil) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationClose object:[NSNumber numberWithBool:YES]];
        }
        else {
            [self.view removeFromSuperview];
        }
       

        //[[[FZTargetManager sharedInstance] multiTarget] setPresent:NO];
        //TODO: can be optimized
        [[[[UIApplication sharedApplication] delegate] autoCloseWindow] setPresent:NO];
        
    } else {
        
        if([self presentingViewController]!=nil) {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget) {
                    
                    FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
                    
                    if ([facade respondsToSelector:@selector(didClose:)]) {
                        [facade didClose:self];
                    }
                }
            }];
        }
        else {
            [[self navigationController] popToRootViewControllerAnimated:YES];
        }
    }
    
    [self removeBackButton];
    
    if([_delegate respondsToSelector:@selector(pinViewControllerDidClose:)]){
        [_delegate pinViewControllerDidClose:self];
    }
	
}

-(void)setupBackButton
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *tempWindow = nil;
    
    if([windows count]>1) {
        tempWindow = [windows objectAtIndex:1];
    }
    
    if(nil==tempWindow) {
        return;
    }
    
    int height = 106;
    int width = 53;
    
    [self removeBackButton];
    
    [self setBtnBack:[UIButton buttonWithType:UIButtonTypeCustom]];
    [_btnBack setFrame:CGRectMake(tempWindow.frame.size.width-height, tempWindow.frame.size.height-width, height, width)];
    [_btnBack setBackgroundColor:[UIColor clearColor]];
    [_btnBack addTarget:self action:@selector(previousTextField) forControlEvents:UIControlEventTouchUpInside];
    [tempWindow addSubview:_btnBack];
}

-(void)removeBackButton
{
    NSArray *subLayers = [[_btnBack layer] sublayers];
    [subLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [_btnBack removeFromSuperview];
    
    [self setBtnBack:nil];
}

-(void)previousTextField
{
    if (_lastTextFieldShowed != nil && [_lastTextFieldShowed tag]>0) {
        [[_textFieldList objectAtIndex:[_lastTextFieldShowed tag]-1] becomeFirstResponder];
    }
}

#pragma mark - Public method

- (void)resetPinCode {
    
    [[_textFieldList objectAtIndex:0] becomeFirstResponder];
    for (UITextField *textField in _textFieldList) {
        [textField setText:@""];
        [textField setBackgroundColor:[[ColorHelper sharedInstance] pinViewController_textField_backgroundColor]];
    }
    wrongPinCode++;
}

- (void)setTextFieldFont:(UIFont *)font {
    for(UITextField *textField in _textFieldList) {
        [textField setFont:font];
    }
}

- (void)noTitleView {
    
    [_personnalCodeLabel setHidden:YES];
    [_closeButton setHidden:YES];
    
    CGRect personnalCodeInformationLabelFrame = [_personnalCodeInformationLabel frame];
    personnalCodeInformationLabelFrame.origin.y -= kNoTitleViewDelta;
    [_personnalCodeInformationLabel setFrame:personnalCodeInformationLabelFrame];
    
    CGRect viewTopFrame = [_viewTop frame];
    viewTopFrame.size.height -= kNoTitleViewDelta;
    [_viewTop setFrame:viewTopFrame];
    
    CGRect view4DigitsFrame = [_view4Digits frame];
    view4DigitsFrame.origin.y -= kNoTitleViewDelta;
    [_view4Digits setFrame:view4DigitsFrame];
    
    CGRect viewFrame = [[self view] frame];
    viewFrame.size.height -= kNoTitleViewDelta;
    [[self view] setFrame:viewFrame];
}

#pragma mark - UITextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setupBackButton];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self removeBackButton];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _lastTextFieldShowed = textField;
    for (UITextField *textField_ in _textFieldList) {
        
        if ([textField_ tag]>= [textField tag]) {
            [textField_ setText:@""];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            
            //set gradient color
            CAGradientLayer *grLayer = [CAGradientLayer layer];
            [grLayer setFrame:textField.layer.bounds];
            
            NSArray *colors =  [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,nil];
            [grLayer setColors:colors];
            
            __block NSInteger indexOfGrLayerToRemove = -1;
            
            //remove blue gradient layer
            [[[textField_ layer] sublayers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if([[obj name] isEqualToString:kGrLayerName]){
                    indexOfGrLayerToRemove = idx;
                    //NSLog(@"idx : %d",idx);
                    *stop = YES;
                }
            }];
            if(indexOfGrLayerToRemove >= 0){
                [[[[textField_ layer] sublayers] objectAtIndex:indexOfGrLayerToRemove] removeFromSuperlayer];
            }
            
            //insert white gradient layer
            [[textField_ layer] insertSublayer:grLayer atIndex:indexOfGrLayerToRemove];
            
            [textField_ setBackgroundColor:[[ColorHelper sharedInstance] pinViewController_textField_backgroundColor]];
            [UIView commitAnimations];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string length]==1) {
        [textField setText:string];
        
        if ([textField tag]<3) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            
            //set gradient color
            CAGradientLayer *grLayer = [CAGradientLayer layer];
            [grLayer setFrame:textField.layer.bounds];
            
            UIColor *color1     = [[ColorHelper sharedInstance] pinViewController_gradient_top];
            UIColor *color2     = [[ColorHelper sharedInstance] pinViewController_gradient_bottom];
            
            NSArray *colors =  [NSArray arrayWithObjects:(id)[color1 CGColor],(id)[color2 CGColor],nil];
            
            [grLayer setColors:colors];
            
            NSNumber *stop1  = [NSNumber numberWithFloat:0.2];
            NSNumber *stop2  = [NSNumber numberWithFloat:0.8];
            
            NSArray *locations = [NSArray arrayWithObjects:stop1,stop2,nil];
            
            [grLayer setLocations:locations];
            [grLayer setName:kGrLayerName];
            //assign gradient to the textfield
            [[textField layer] insertSublayer:grLayer atIndex:0];
            
            [textField setBackgroundColor:[[ColorHelper sharedInstance] pinViewController_textField_2_backgroundColor]];
            [UIView commitAnimations];
            
            [[_textFieldList objectAtIndex:([textField tag]+1)] becomeFirstResponder];
            
        }else{
            
            [_textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
            
            NSMutableString *tempStr = [NSMutableString string];
            
            for (UITextField *textField in _textFieldList) {
                [tempStr appendString:[textField text]];
            }
            
            if([tempStr length]>=4){
                
                [self setCurrentPinCode:[NSString stringWithString:tempStr]];
                
                if([_delegate respondsToSelector:@selector(pinViewController:didEnterPinCode:)]) {
                    
                    // TODO : WTF is THAT?????????
                    //maybe : http://stackoverflow.com/questions/21237730/snapshotting-a-view-that-has-not-been-rendered-results-in-an-empty-snapshot-in-x ??
                    double delayInSeconds = 0.2;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [_delegate pinViewController:self didEnterPinCode:[self currentPinCode]];
                    });
                    
                }
                else if (nil!=_pinCompletionBlock) {
                    [textField resignFirstResponder];
                    
                    // TODO : WTF is THAT?????????
                    //maybe : http://stackoverflow.com/questions/21237730/snapshotting-a-view-that-has-not-been-rendered-results-in-an-empty-snapshot-in-x ??
                    double delayInSeconds = 0.2;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        _pinCompletionBlock([self currentPinCode]);
                    });
                }
            } else {
                [[_textFieldList objectAtIndex:0] becomeFirstResponder];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - CustomNavigationViewControllerAction

-(void)didGoBack:(CustomNavigationViewController *)controller {
    
    [[StatisticsFactory sharedInstance] checkPointCreatePincodeQuit];
    
    if([_delegate respondsToSelector:@selector(pinViewControllerDidBack:)]) {
        [_delegate pinViewControllerDidBack:self];
    }
}

- (void)didClose:(CustomNavigationViewController *)controller {
    if([_delegate respondsToSelector:@selector(pinViewControllerDidClose:)]) {
        
        [_delegate pinViewControllerDidClose:self];
    }
}

#pragma mark - Status bar

- (UIStatusBarStyle)preferredStatusBarStyle{
    return STATUS_STYLE;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self setCloseButton:nil];
    
    [self removeBackButton];
    
    _lastTextFieldShowed = nil;
    
    [self setTitleView:nil];
    [self setDescriptView:nil];
    
    [_personnalCodeLabel release];
    [_personnalCodeInformationLabel release];
    
    [self setPinCompletionBlock:nil];
    
    [_textFieldList makeObjectsPerformSelector:@selector(setDelegate:) withObject:nil];
    [_textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
    
    [self setTextFieldList:nil];
    [_view4Digits release];
    [_viewTop release];
    
    [_currentPinCode release], _currentPinCode = nil;
    
    [_imgViewBackgroundTop release];
    [super dealloc];
}

@end
