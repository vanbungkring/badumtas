//
//  LoginViewController.m
//  iMobey
//
//  Created by Yvan Moté on 08/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "LoginViewController.h"

//Navigation

//Service
#import <FZAPI/ConnectionServices.h>
#import <FZAPI/AvatarServices.h>
#import <FZAPI/InvoiceServices.h>

#import <FZAPI/User.h>

//Server constants
#import <FZAPI/ServerConstants.h>

//Log
#import <FZAPI/UserSession.h>

//Cell
#import "LoginCell.h"

//TableView
//#import <FZBlackBox/TPKeyboardAvoidingTableView.h>

//Controller
#import "PinViewController.h"

//AutoCloseWindow
//#import "AutoCloseWindow.h"

//Color
#import <FZBlackBox/ColorHelper.h>

//Currency
#import <FZAPI/CurrenciesManager.h>

//AlertView
#import <FZBlackBox/ODCustomAlertView.h>

//ODDevice
#import <FZBlackBox/ODDeviceUtil.h>

//Localization
#import <FZBlackBox/LocalizationHelper.h>

//Fonts
#import <FZBlackBox/FontHelper.h>

//SDKProxyHelper
#import <FZBlackBox/SDKProxyHelper.h>

#import <FZBlackBox/CustomTabBarViewController.h>

//Bundle helper
#import <FZBlackBox/BundleHelper.h>

//Image
#import <FZBlackBox/FZUIImageWithImage.h>

//Target
#import <FZBlackBox/FZTargetManager.h>

//Vendor
#import <FZBlackBox/TPKeyboardAvoidingTableView.h>

//UrlSchemeManager
#import <FZBlackBox/FZUrlSchemeManager.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>

//Navigation
#import <FZBlackBox/FZPortraitNavigationController.h>

@class InitialViewController;

#define kRegisterTextFieldUser 100000
#define kRegisterTextFieldPassword 100001

#define kNotificationClose @"receiveDismissAction"

#ifdef __IPHONE_7_0
# define STATUS_STYLE UIStatusBarStyleLightContent
#else
# define STATUS_STYLE UIStatusBarStyleBlackTranslucent
#endif

@interface LoginViewController () <UITextFieldDelegate> {
    
}

//View
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIButton *btnConnect;
@property (retain, nonatomic) IBOutlet UIButton *btnForgottenPassword;
@property (retain, nonatomic) IBOutlet UIButton *buttonRegister;
@property (retain, nonatomic) IBOutlet UIButton *btnLoginWithFlashiz;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewLogo;


//Controllers
// TODO: memory management
@property (retain, nonatomic) PinViewController *pinViewController;

//Model
@property (retain, nonatomic) NSMutableArray *arrayCell;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *userPassword;
@property (retain, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableview;
@property (assign, nonatomic) BOOL loginInProgress;

@property (retain, nonatomic) NSString *mailFromForgottenPassword;
@property (retain, nonatomic) NSString *pwdFromForgottenPassword;

@property (assign, nonatomic) int connectionTries;

@end

@implementation LoginViewController {
    BOOL needToHideLoginHeaderView;
    CGFloat resizeStep;
}

@synthesize loginViewHeader;
@synthesize usernameTextField;
@synthesize passwordTextField;

#pragma mark - Init

- (id)init {
    self = [super initWithNibName:@"LoginViewController" bundle:[BundleHelper retrieveBundle:FZBundlePayment]];
    if (self) {
        // Custom initialization
        _arrayCell = [[NSMutableArray alloc]init];
        [self setMailFromForgottenPassword:nil];
        [self setPwdFromForgottenPassword:nil];
    }
    return self;
}

- (id)initWithMail:(NSString *)email andPassword:(NSString *)pwd {
    self = [super initWithNibName:@"LoginViewController" bundle:[BundleHelper retrieveBundle:FZBundlePayment]];
    if (self) {
        // Custom initialization
        _arrayCell = [[NSMutableArray alloc]init];
        [self setMailFromForgottenPassword:email];
        [self setPwdFromForgottenPassword:pwd];
    }
    return self;
}

#pragma mark - View Cycle Life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupView];
    
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /** Fast dev area **/
    
    usernameTextField.text = @"flashizqat.fiz@yopmail.com";
    passwordTextField.text = @"azer1234";
    
    /********************/
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return STATUS_STYLE;
}

-(void)setupView
{
    self.title = [LocalizationHelper stringForKey:@"loginViewController_navigation_title" withComment:@"LoginViewController" inDefaultBundle:FZBundlePayment];
    
    [_headerView setBackgroundColor:[[ColorHelper sharedInstance] loginViewController_headerView_backgroundColor]];
    
    [_imageViewLogo setImage:[FZUIImageWithImage imageNamed:@"header_logo" inBundle:FZBundleBlackBox]];
    
    [_btnConnect setTitle:[[LocalizationHelper stringForKey:@"initial_connect" withComment:@"InitialViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [[_btnConnect titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:12.0f]];
    [_btnConnect setTitleColor:[[ColorHelper sharedInstance] loginViewController_btnConnect_titleColor] forState:UIControlStateNormal];
    [_btnConnect setImage:[FZUIImageWithImage imageNamed:@"icon_connect" inBundle:FZBundleBlackBox] forState:UIControlStateNormal];
    
    [_btnClose setImage:[FZUIImageWithImage imageNamed:@"icon_cross" inBundle:FZBundleBlackBox] forState:UIControlStateNormal];
    
    [_tableview setSeparatorColor:[UIColor whiteColor]];
    
    [_bottomView setBackgroundColor:[[ColorHelper sharedInstance] loginViewController_bottomView_backgroundColor]];
    
    [_btnLogin setBackgroundColor:[[ColorHelper sharedInstance] loginViewController_btnLogin_backgroundColor]];
    [_btnLogin setTitle:[[LocalizationHelper stringForKey:@"app_validate" withComment:@"Global" inDefaultBundle:FZBundleBlackBox] uppercaseString] forState:UIControlStateNormal];
    [_btnLogin setTitleColor:[[ColorHelper sharedInstance] loginViewController_btnLogin_titleColor] forState:UIControlStateNormal];
    [[_btnLogin titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedWithSize:22.0f]];
    
    [self setupViewBanner];
    
    //Forgotten password
    [_btnForgottenPassword setTitleColor:[[ColorHelper sharedInstance] loginViewController_btnForgottenPassword_titleColor] forState:UIControlStateNormal];
    [_btnForgottenPassword setTitle:[[LocalizationHelper stringForKey:@"loginViewController_btnForgottenPassword_title" withComment:@"LoginViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [[_btnForgottenPassword titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:14.0f]];
    
    NSDictionary *dico = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInteger:NSUnderlineStyleSingle], nil] forKeys:[NSArray arrayWithObjects:NSUnderlineStyleAttributeName, nil]];
    
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:[[_btnForgottenPassword titleLabel] text] attributes:dico];
    [_btnForgottenPassword setAttributedTitle:attributes forState:UIControlStateNormal];
    
    [dico release];
    [attributes release];
    
    //register SDK only
    [_buttonRegister setTitleColor:[[ColorHelper sharedInstance] loginViewController_btnForgottenPassword_titleColor] forState:UIControlStateNormal];
    [_buttonRegister setTitle:[[LocalizationHelper stringForKey:@"initial_create_account" withComment:@"LoginViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [[_buttonRegister titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:14.0f]];
    
    NSDictionary *dico2 = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInteger:NSUnderlineStyleSingle], nil] forKeys:[NSArray arrayWithObjects:NSUnderlineStyleAttributeName, nil]];
    
    NSMutableAttributedString *attributes2 = [[NSMutableAttributedString alloc] initWithString:[[_buttonRegister titleLabel] text] attributes:dico2];
    [_buttonRegister setAttributedTitle:attributes2 forState:UIControlStateNormal];
    
    [dico2 release];
    [attributes2 release];
    
    BOOL hideButtonRegister = !([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget);
    [_buttonRegister setHidden:hideButtonRegister];
    
    //register SDK only
    [_btnLoginWithFlashiz setTitleColor:[[ColorHelper sharedInstance] loginViewController_btnForgottenPassword_titleColor] forState:UIControlStateNormal];
    [_btnLoginWithFlashiz setTitle:[[LocalizationHelper stringForKey:@"loginviewController_link_with_flashiz" withComment:@"LoginViewController" inDefaultBundle:FZBundlePayment] uppercaseString] forState:UIControlStateNormal];
    [[_btnLoginWithFlashiz titleLabel] setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:14.0f]];
    
    NSDictionary *dico3 = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInteger:NSUnderlineStyleSingle], nil] forKeys:[NSArray arrayWithObjects:NSUnderlineStyleAttributeName, nil]];
    
    NSMutableAttributedString *attributes3 = [[NSMutableAttributedString alloc] initWithString:[[_btnLoginWithFlashiz titleLabel] text] attributes:dico3];
    [_btnLoginWithFlashiz setAttributedTitle:attributes3 forState:UIControlStateNormal];
    
    [dico3 release];
    [attributes3 release];
    
    //login with Flashiz SDK only
    BOOL hideBtnLoginWithFlashiz = !([[FZTargetManager sharedInstance] mainTarget] == FZSDKTarget);
    [_btnLoginWithFlashiz setHidden:hideBtnLoginWithFlashiz];
}

- (void)setupViewBanner {
    //do nothing for flashiz
}

- (void)viewDidLayoutSubviews {
    CGRect loginViewFrame = [[self view] frame];
    
    loginViewFrame.origin.y+=resizeStep;
    loginViewFrame.size.height-=resizeStep;
    
    [[self view] setFrame:loginViewFrame];
}

#pragma mark - Public methods

- (void)hideHeaderView {
    [loginViewHeader setHidden:YES];
    
    needToHideLoginHeaderView = YES;
}

- (void)forceResize {
    //Trick for SDK merchant in modal mode
    resizeStep = 20.0;
}

#pragma mark - Private methods

- (void)hideKeyboard {
    for(LoginCell *cell in _arrayCell){
        [[cell textFieldCell] resignFirstResponder];
    }
}

#pragma mark - UITextField delegate methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField returnKeyType]==UIReturnKeyDone) {
        [textField resignFirstResponder];
        [self login:nil];
    } else {
        [self.tableview focusNextTextField];
    }
    return YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginCell *cell = [LoginCell dequeueReusableCellWithtableView:tableView];
    
    if (cell == nil) {
        cell = [LoginCell loadCellWithOwner:self inDefault:
                FZBundlePayment];
    }
    
    [_arrayCell addObject:cell];
    
    [[cell textFieldCell]setTag:indexPath.row];
    [[cell textFieldCell]setDelegate:self];
    
    if (indexPath.row==0) {
        
        [cell setLeftImageName:@"icon_id" andPlaceholderText:[LocalizationHelper stringForKey:@"app_email" withComment:@"Global" inDefaultBundle:FZBundleBlackBox] andRightImageName:nil];
        
        [self setUsernameTextField:[cell textFieldCell]];
        [usernameTextField setKeyboardType:UIKeyboardTypeEmailAddress];
        [usernameTextField setReturnKeyType:UIReturnKeyNext];
        [usernameTextField setTag:kRegisterTextFieldUser];
        [usernameTextField setClearsOnBeginEditing:NO];
        [usernameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [usernameTextField setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:18.0f]];
        
    }else if(indexPath.row==1){
        
        [cell setLeftImageName:@"icon_password" andPlaceholderText:[LocalizationHelper stringForKey:@"app_password" withComment:@"Global" inDefaultBundle:FZBundleBlackBox] andRightImageName:@"icon_eye"];
        
        [self setPasswordTextField:[cell textFieldCell]];
        [passwordTextField setReturnKeyType:UIReturnKeyDone];
        [passwordTextField setTag:kRegisterTextFieldPassword];
        [passwordTextField setSecureTextEntry:YES];
        [passwordTextField setClearsOnBeginEditing:YES];
        [passwordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [passwordTextField setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:18.0f]];
    }
    
    if([_mailFromForgottenPassword length] > 0 && [_pwdFromForgottenPassword length] > 0) {
        [usernameTextField setText:_mailFromForgottenPassword];
        [passwordTextField setText:_pwdFromForgottenPassword];
        
        if ([self stringIsValidEmail:[usernameTextField text]] && [self stringIsValidPassword: [passwordTextField text]]) {
            [self validButton];
        } else {
            [self unvalidButton];
        }
    }
    
    return cell;
}

#pragma mark - Action methods

-(void) askPinCodeWithUserKey:(NSString *)userKey{
    
    FZTarget currentTarget = [[FZTargetManager sharedInstance] mainTarget];
    BOOL isFZSDK = currentTarget == FZSDKTarget;
    
    PinCompletionBlock pinCompletionBlock = ^(NSString *pinCode) {
        
        __block PinViewController *pinViewControllerSecond = [[self multiTargetManager] pinViewController];
        
        PinCompletionBlock pinCompletionBlockSecond = ^(NSString *pinCodeSecond) {
            if ([pinCode isEqualToString:pinCodeSecond]) {
                
                [pinViewControllerSecond showForUserNotConnectedWaitingViewWithMessage:[LocalizationHelper stringForKey:@"app_please_wait" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]];
                [[StatisticsFactory sharedInstance] checkPointCreatePincodeDone];
                [ConnectionServices sendPIN:pinCode withUserKey:userKey withToken:@"" successBlock:^(id context) {
                    
                    [ConnectionServices retrieveUserInfosLight:userKey successBlock:^(User *user) {
                        
                        [pinViewControllerSecond hideWaitingView];
                        
                        UserSession *userSession = [UserSession currentSession];
                        [userSession setConnected:YES];
                        
                        // the user is connected so the app/SDL is unlocked
                        [userSession setLocked:NO];
                        
                        [userSession storeUserKey:userKey];
                        [userSession setUser:user];
                        
                        if (!isFZSDK && ![userSession isLinkWithFlashizProcess]) {
                            [[[FZTargetManager sharedInstance]facade]displayTabBarFrom:_pinViewController andDismissIt:YES animated:NO];
                        } //else do not display the tab bar for the european SDK                      
                        
                        [[CurrenciesManager currentManager] setDefaultCurrency:[[[[UserSession currentSession] user] account] currency]];
                        //FZBlackBoxLog(@"Now set default currency to : %@",[[[[UserSession currentSession] user] account] currency]);
                        
                        if([[[UserSession currentSession] user] isCompany]){
                            [[[[FZTargetManager sharedInstance]facade]tabBarController] setCustomTabBarForProfessional];
                        } else {
                            if (!isFZSDK) {
                                [[[[FZTargetManager sharedInstance]facade]tabBarController] setCustomTabBarForClient];
                            }
                        }
                        
                        //force reload avatar
                        [AvatarServices avatarWithMail:[user email] successBlock:^(id context) {
                            FZBlackBoxLog(@"Retrieve avatar success");
                            [[UserSession currentSession] reloadAvatarWithDefaultImage:[FZUIImageWithImage imageNamed:@"logo_default.png" inBundle:FZBundleAPI]];
                        } failureBlock:^(Error *error) {
                            FZBlackBoxLog(@"Retrieve avatar failed");
                        }];
                        
                        //set valid urls
                        if([[FZTargetManager sharedInstance] mainTarget] == FZBankSDKTarget) {
                            NSMutableArray *urlList = [[NSMutableArray alloc] init];
                            [urlList addObject:@"http://www.flashiz.com/fr/infos/"];
                            [urlList addObject:@"http://www.flashiz.com/en/infos/"];
                            [urlList addObject:@"http://www.flashiz.com/es/infos/"];
                            [urlList addObject:@"http://www.flashiz.com/de/infos/"];
                            [urlList addObject:@"http://www.flashiz.com/nl/infos/"];
                            [[UserSession currentSession] setValidUrls:urlList];
                            [urlList release];
                        } else {
                            [InvoiceServices urlListSuccessBlock:^(id context) {
                                [[UserSession currentSession] setValidUrls:context];
                            } failureBlock:^(Error *error) {
                                ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:[LocalizationHelper stringForKey:@"paymentViewController_not_flashiz_invoice_alert_title" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                                                message:[error localizedError]
                                                                                               delegate:nil
                                                                                      cancelButtonTitle:[LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox]
                                                                                      otherButtonTitles:nil];
                                [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                                [alertView show];
                                [alertView release];
                            }];
                        }
                        
                        if([userSession isLinkWithFlashizProcess]){
                            
                            [userSession setConnected:NO];
                            
                            [userSession setLinkWithFlashiz:NO];
                            
                            //keep the session for the next connection
                            InitialViewController *viewControllerInitial = (InitialViewController*)[[[FZTargetManager sharedInstance] facade] appController];
                            [viewControllerInitial setLaunch:YES];
              
                            [self dismissViewControllerAnimated:NO completion:^{}];
                            
                            [FZUrlSchemeManager backToTheHostApplicationWithUserkey:userKey];
                            
                        } else {
                            
                            if (isFZSDK) {
                                
                                FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
                                
                                if([facade respondsToSelector:@selector(didConnectWithUser:withUserKey:)]) {
                                    [facade didConnectWithUser:user withUserKey:userKey];
                                                                        
                                    [[self navigationController] popViewControllerAnimated:NO];// remove the second pin code
                                    [[self navigationController] popViewControllerAnimated:NO];// remove the first pin code
                                }
                            }
                            
                            /*if([[FZTargetManager sharedInstance] customerUrlScheme]) {
                                [SDKProxyHelper backToTheHostApplicationWithCustomerUrlScheme:[[FZTargetManager sharedInstance] customerUrlScheme] userKey:[[UserSession currentSession] userKey] environment:[[UserSession currentSession] shortEnvironmentValue]];
                            }*/
                        }
                        
                    } failureBlock:^(Error *error) {
                        [pinViewControllerSecond hideWaitingView];
                        
                        NSString *title = [LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                        NSString *message = [LocalizationHelper stringForKey:@"app_error_loading" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                        NSString *cancelButton = [LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                        
                        ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:title
                                                                                        message:message
                                                                                       delegate:nil
                                                                              cancelButtonTitle:cancelButton
                                                                              otherButtonTitles:nil];
                        [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                        [alertView show];
                        [alertView release];
                        
                        if([_delegate respondsToSelector:@selector(didFailConnecting)]) {
                            [_delegate didFailConnecting];
                        }
                    }];
                    
                } failureBlock:^(Error *error) {
                    
                    [pinViewControllerSecond hideWaitingView];
                    
                    [self displayAlertForError:error];
                    
                    if([_delegate respondsToSelector:@selector(didFailConnecting)]) {
                        [_delegate didFailConnecting];
                    }
                }];
            } else {
                NSString *title = [LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                NSString *message = [LocalizationHelper stringForKey:@"pin_not_matching" withComment:@"Global" inDefaultBundle:FZBundlePayment];
                NSString *cancelButton = [LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                
                ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:title
                                                                                message:message
                                                                               delegate:nil
                                                                      cancelButtonTitle:cancelButton
                                                                      otherButtonTitles:nil];
                [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                [alertView show];
                [alertView release];
                [self askPinCodeWithUserKey:userKey];
            }
        };
        
        NSString *navigationTitle = [LocalizationHelper stringForKey:@"pinViewController_navigation_title" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment];
        NSString *title =  [LocalizationHelper stringForKey:@"pinViewController_your_personnal_code" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment];
        NSString *description = [LocalizationHelper stringForKey:@"pinViewController_your_personnal_code_confirm" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment];
        
        pinViewControllerSecond = [[self multiTargetManager] pinViewControllerWithCompletionBlock:pinCompletionBlockSecond navigationTitle:navigationTitle title:title titleHeader:@"" description:description animated:NO modeSmall:NO];
        
        [[self navigationController]pushViewController:pinViewControllerSecond animated:YES];
        [pinViewControllerSecond setupBackButton];
    };
    
    NSString *navigationTitle = [LocalizationHelper stringForKey:@"pinViewController_navigation_title" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment];
    NSString *title = [LocalizationHelper stringForKey:@"pinViewController_your_personnal_code" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment];
    NSString *description = [LocalizationHelper stringForKey:@"pinViewController_your_personnal_code_inforamtion" withComment:@"PinViewController" inDefaultBundle:FZBundlePayment];
    
    _pinViewController = [[self multiTargetManager] pinViewControllerWithCompletionBlock:pinCompletionBlock navigationTitle:navigationTitle title:title titleHeader:@"" description:description animated:NO modeSmall:NO];
    
    [[self navigationController] pushViewController:_pinViewController animated:YES];
    
    [_pinViewController setupBackButton];
}

- (IBAction)login:(id)sender {
    [[StatisticsFactory sharedInstance] checkPointConnectValidateLogin];
    
    if(_loginInProgress) {
        return;
    }
    
    [self setUserName:[usernameTextField text]];
    [self setUserPassword:[passwordTextField text]];
    
    
    if(![self stringIsValidEmail:_userName]){
        return;
    }
    
    if(![self stringIsValidPassword:_userPassword]){
        return;
    }
    
    if([_userName length]==0) {
        
        
        //Deprecated
        /*NSString *title = [LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
         NSString *message = [LocalizationHelper stringForKey:@"loginviewController_alertview_user_empty" withComment:@"LoginViewController" inDefaultBundle:FZBundlePayment];
         NSString *cancelButton = [LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
         
         
         ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:title
         message:message
         delegate:nil
         cancelButtonTitle:cancelButton
         otherButtonTitles:nil];
         [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
         [alertView show];
         [alertView release];*/
        
        return;
    }
    
    if([_userPassword length]==0) {
        
        
        
        //Deprecated
        /*NSString *title = [LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
         NSString *message = [LocalizationHelper stringForKey:@"loginviewController_alertview_password_empty" withComment:@"LoginViewController" inDefaultBundle:FZBundlePayment];
         NSString *cancelButton = [LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
         
         ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:title
         message:message
         delegate:nil
         cancelButtonTitle:cancelButton
         otherButtonTitles:nil];
         [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
         [alertView show];
         [alertView release];*/
        
        return;
    }
    
    _loginInProgress = YES;
    
    [self hideKeyboard];
    
    NSString *message = [LocalizationHelper stringForKey:@"app_please_wait" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
    
    [self showForUserNotConnectedWaitingViewWithMessage:message];
    
    NSString *device = [ODDeviceUtil currentDeviceModelName];
    NSString *deviceName = [[UIDevice currentDevice] name];
    
    NSString *correctedUserName = [[UserSession currentSession] emailAfterStoredEnvironmentWithTypedEmail:_userName];
    
    [ConnectionServices connect:correctedUserName
                       password:_userPassword
                      firstTime:YES
                     withDevice:device
                 withDeviceName:deviceName
                   successBlock:^(id context) {
                       
                       [self hideWaitingView];
                       
                       NSString *userKey = (NSString *)context;
                       
                       FZBlackBoxLog(@"connection success user key : %@",context);
                       
                       if([userKey length]>0) {
                           [self askPinCodeWithUserKey:userKey];
                       } else {
                           
                           NSString *title = [LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                           NSString *message = [LocalizationHelper stringForKey:@"user_invalid" withComment:@"LoginViewController" inDefaultBundle:FZBundlePayment];
                           NSString *cancelButton = [LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
                           
                           ODCustomAlertView *alertView = [[ODCustomAlertView alloc] initWithTitle:title                                                                                           message:message
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:cancelButton
                                                                                 otherButtonTitles:nil];
                           [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
                           [alertView show];
                           [alertView release];
                       }
                       
                       //login has been performed
                       _loginInProgress = NO;
                       
                   } failureBlock:^(Error *error) {
                       // TODO
#warning HOT FIX
                       _connectionTries++;
                       if(_connectionTries > 3) {
                           [error setErrorCode:1111]; //Hot fix : ios-623 -> need error code from the server
                       }
                       
                       [self displayAlertForError:error];
                       
                       //login has been performed
                       _loginInProgress = NO;
                       
                       [self hideWaitingView];
                   }];
}

- (IBAction)back:(id)sender
{
    [[StatisticsFactory sharedInstance] checkPointConnectQuitLogin];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (![[FZTargetManager sharedInstance] isApplicationUsingSDK]) {
            if([_delegate respondsToSelector:@selector(didClose:)]) {
                [_delegate didClose:[[self retain] autorelease]];
            }
        } else {
            FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
            
            if ([facade respondsToSelector:@selector(didClose:)]) {
                [facade didClose:self];
            }
        }
        
    }];
}

- (IBAction)forgottenPassword:(id)sender {
    [[StatisticsFactory sharedInstance] checkPointConnectForgottenPassword];
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self closeSDKLoadingView];
        
        NSString *userName = @"";
        
        if ([usernameTextField text]!=nil) {
            userName = [usernameTextField text];
        }
        [SDKProxyHelper openForgottenPasswordProcessWithMail:userName];
    }];
}

- (IBAction)registerWithFlashizApp:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self closeSDKLoadingView];
        
        [SDKProxyHelper openRegisterProcess];
    }];
}

- (IBAction)linkWithYourFlashizAccount:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{

        [self closeSDKLoadingView];
        
        [SDKProxyHelper openLinkToFlashizApplicationWithCustomerScheme:[[FZTargetManager sharedInstance] customerScheme] customerHost:[[FZTargetManager sharedInstance] customerHost]];
    }];
}

- (void)closeSDKLoadingView {
    //Close SDK loading view if needed
    if ([[FZTargetManager sharedInstance] isApplicationUsingSDK]) {
        FZFlashizFacade *facade = [[FZTargetManager sharedInstance] facade];
        
        if ([facade respondsToSelector:@selector(hideLoadingView)]) {
            [facade hideLoadingView];
        }
    }
}

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if([textField tag] == kRegisterTextFieldPassword){
        [_bottomView setBackgroundColor:[[ColorHelper sharedInstance] loginViewController_bottomView_backgroundColor]];
        [_btnLogin setBackgroundColor:[[ColorHelper sharedInstance] loginViewController_btnLogin_backgroundColor]];
        [_btnLogin setTitleColor:[[ColorHelper sharedInstance] loginViewController_btnLogin_titleColor] forState:UIControlStateNormal];
        [_btnForgottenPassword setTitleColor:[[ColorHelper sharedInstance] loginViewController_btnForgottenPassword_titleColor] forState:UIControlStateNormal];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *aText = nil;
    
    // TODO : what we have this code ?
    if([string length] > 0 && range.location >= [[textField text] length] - 1){//add char at the end of the string
        aText = [NSString stringWithFormat:@"%@%@",[textField text],string];
    } else if([string length] > 0 && range.location < [[textField text] length] - 1) {//add char at the middle or begining of the string
        aText = [NSString stringWithFormat:@"%@%@%@",[[textField text] substringToIndex:range.location],string,[[textField text] substringFromIndex:range.location]];
    } else if(range.location >= [[textField text] length] - 1){//remove last char of the string
        aText = [[textField text] substringToIndex:[[textField text] length] - 1];
    } else {//remove a char at the middle of the string
        aText =[NSString stringWithFormat:@"%@%@",[[textField text] substringToIndex:range.location],[[textField text] substringFromIndex:range.location + 1]];
    }
    
    if([textField tag] == kRegisterTextFieldUser){
        if([self stringIsValidEmail:aText] && [self stringIsValidPassword:[[[_arrayCell objectAtIndex:1] textFieldCell] text]]) {
            [self validButton];
        } else {
            [self unvalidButton];
        }
    } else if([textField tag] == kRegisterTextFieldPassword) {
        if([self stringIsValidPassword:aText] && [self stringIsValidEmail:[[[_arrayCell objectAtIndex:0] textFieldCell] text]]) {
            [self validButton];
        } else {
            [self unvalidButton];
        }
    }
    return YES;
}

- (void)validButton {
    [_bottomView setBackgroundColor:[[ColorHelper sharedInstance] loginViewController_bottomView_valid_backgroundColor]];
    [_btnLogin setBackgroundColor:[[ColorHelper sharedInstance] loginViewController_btnLogin_valid_backgroundColor]];
    [_btnLogin setTitleColor:[[ColorHelper sharedInstance] loginViewController_btnLogin_valid_titleColor] forState:UIControlStateNormal];
    
    if(![[[FZTargetManager sharedInstance]brandName]isEqualToString:@"leclerc"]){
        [[_btnForgottenPassword titleLabel] setTextColor:[[ColorHelper sharedInstance] whiteColor]];
    }
    
    [[_btnLoginWithFlashiz titleLabel] setTextColor:[[ColorHelper sharedInstance] whiteColor]];
    [[_buttonRegister titleLabel] setTextColor:[[ColorHelper sharedInstance] whiteColor]];
}

- (void)unvalidButton {
    [_bottomView setBackgroundColor:[[ColorHelper sharedInstance] loginViewController_bottomView_backgroundColor]];
    [_btnLogin setBackgroundColor:[[ColorHelper sharedInstance] loginViewController_btnLogin_backgroundColor]];
    [_btnLogin setTitleColor:[[ColorHelper sharedInstance] loginViewController_btnLogin_titleColor] forState:UIControlStateNormal];
    [[_btnForgottenPassword titleLabel] setTextColor:[[ColorHelper sharedInstance] loginViewController_btnForgottenPassword_titleColor]];
    [[_btnLoginWithFlashiz titleLabel] setTextColor:[[ColorHelper sharedInstance] loginViewController_btnForgottenPassword_titleColor]];
    [[_buttonRegister titleLabel] setTextColor:[[ColorHelper sharedInstance] loginViewController_btnForgottenPassword_titleColor]];
}

#pragma mark - Check Methods

- (BOOL)stringIsValidEmail:(NSString *)checkString
{
    if (checkString==nil) {
        return NO;
    }
    
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)stringIsValidPassword:(NSString *)checkString
{
    if (checkString==nil) {
        return NO;
    }
    
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789@"] invertedSet];
    
    if ([checkString rangeOfCharacterFromSet:set].location != NSNotFound) {
        //Contains illegal value
        return NO;
    }else{
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *characters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
        
        if ([checkString rangeOfCharacterFromSet:numbers].location == NSNotFound || [checkString rangeOfCharacterFromSet:characters].location == NSNotFound) {
            //Does not contains numeric value
            return NO;
        }else{
            
            if ([checkString length]>=8) {
                return YES;
            }else{
                return NO;
            }
        }
    }
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [usernameTextField release], usernameTextField = nil;
    [passwordTextField release], passwordTextField = nil;
    
    if (_userName) {
        [_userName release],_userName = nil;
    }
    
    if (_userPassword) {
        [_userPassword release],_userPassword = nil;
    }
    
    [_arrayCell release],_arrayCell = nil;
    
    [_tableview release];
    [_btnLogin release];
    [_headerView release];
    [_bottomView release];
    [_btnConnect release];
    [_btnForgottenPassword release];
    [loginViewHeader release];
    [_viewBanner release];
    [_imgPaymentFlash release];
    [_imgLogo release];
    [_viewBody release];
    [_buttonRegister release], _buttonRegister = nil;
    [_btnLoginWithFlashiz release], _btnLoginWithFlashiz = nil;
    [_btnClose release], _btnConnect = nil;
    
    [_imageViewLogo release];
    [super dealloc];
}

@end
