//
//  AccountBannerViewController.m
//  iMobey
//
//  Created by Matthieu Barile on 14/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "AccountBannerViewController.h"

//BundleHelper
#import <FZBlackBox/BundleHelper.h>

//Session
#import <FZAPI/UserSession.h>

//Service
#import <FZAPI/AvatarServices.h>

//Language
#import <FZBlackBox/LocalizationHelper.h>

//Currency
#import <FZAPI/CurrenciesManager.h>

//Framework
#import <MobileCoreServices/MobileCoreServices.h>

//AlertView
#import <FZBlackBox/ODCustomAlertView.h>

//BundleHelper
#import <FZBlackBox/BundleHelper.h>

//Util+Image
#import <FZBlackBox/FZUIImageWithImage.h>
#import <FZBlackBox/FZUIImageWithResize.h>
#import <FZAPI/FZUIImageWithFZBinaryArray.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Constants
#import <FZBlackBox/Constants.h>

//Tracker
#import <FZBlackBox/StatisticsFactory.h>


static NSString *balanceKeyPath = @"user.account.balance";
static NSString *userMailKeyPath = @"user.email";

typedef enum {
    FZAccountBannerFull,
    FZAccountBannerLight,
    FZAccountBannerShowAmount
} FZAccountBanner;

@interface AccountBannerViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    
}

//View
//private properties
@property (retain, nonatomic) IBOutlet UIImageView *imgAvatarMask;
@property (retain, nonatomic) IBOutlet UIButton *imageAvatar;
@property (retain, nonatomic) IBOutlet UILabel *lblYourBalance;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) FZAccountBanner mode;
@property (assign, nonatomic) UIActionSheet *actionSheet;

//private actions
- (IBAction)goToOrCloseHistoric:(id)sender;


//Model
@property (assign, nonatomic) BOOL isHistoryViewController;
@property (assign, nonatomic, getter = isChangingAvatarAllowed) BOOL allowChangeAvatar;


@end

@implementation AccountBannerViewController
@synthesize lblCurrentBalance;
@synthesize delegate;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"AccountBannerViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        _isHistoryViewController = NO;
        _mode = FZAccountBannerFull;
        _allowChangeAvatar = YES;
    }
    return self;
}

- (id)initLight
{
    self = [super initWithNibName:@"AccountBannerLightViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        _isHistoryViewController = NO;
        _mode = FZAccountBannerLight;
        _allowChangeAvatar = YES;
    }
    return self;
}

- (id)initShowAmount
{
    self = [super initWithNibName:@"AccountBannerShowAmountViewController" bundle:[BundleHelper retrieveBundle:FZBundleBlackBox]];
    if (self) {
        _isHistoryViewController = NO;
        _mode = FZAccountBannerShowAmount;
        _allowChangeAvatar = YES;
    }
    return self;
}

#pragma mark - Private methods

- (void)startObservingSessionUser {
    
    [[UserSession currentSession] addObserver:self forKeyPath:balanceKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    [[UserSession currentSession] addObserver:self forKeyPath:userMailKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    
    
    //add observer to start/stop the camera while displaying/hiding the side menu
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disableChangeAvatar)
                                                 name:willShowMenuNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(allowChangeAvatar)
                                                 name:willHideMenuNotification
                                               object:nil];
}

- (void)stopObservingSessionUser {
    [[UserSession currentSession] removeObserver:self forKeyPath:balanceKeyPath];
    [[UserSession currentSession] removeObserver:self forKeyPath:userMailKeyPath];
    
    //remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:willShowMenuNotification
                                                  object:nil];
    //remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:willHideMenuNotification
                                                  object:nil];
}

- (void)disableChangeAvatar {
    [self setAllowChangeAvatar:NO];
}

- (void)allowChangeAvatar {
    [self setAllowChangeAvatar:YES];
}

#pragma mark - Cycle life

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(_mode == FZAccountBannerLight){
        [_imgAvatarMask setImage:[FZUIImageWithImage imageNamed:@"mask_profile_mini" inBundle:FZBundleBlackBox]];
        
    }else if(_mode == FZAccountBannerFull){
        [_imgAvatarMask setImage:[FZUIImageWithImage imageNamed:@"mask_profile" inBundle:FZBundleBlackBox]];
    }
    
    [_lblYourBalance setText:[[LocalizationHelper stringForKey:@"AccountBannerViewController_YourBalance" withComment:@"AccountBannerViewController" inDefaultBundle:FZBundlePayment] uppercaseString]];
    [_lblYourBalance setTextColor:[[ColorHelper sharedInstance] accountBannerViewController_lblYourBalance_textColor]];
    
    [lblCurrentBalance setTextColor:[[ColorHelper sharedInstance] accountBannerViewController_lblCurrentBalance_textColor]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatarLoaded:) name:kAvatarLoadedNotification object:nil];
    
    [self startObservingSessionUser];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadAvatarAndHideSpinner:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_actionSheet dismissWithClickedButtonIndex:-1 animated:NO];
    
}

#pragma mark - Observer

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:balanceKeyPath]) {
        [self loadBalanceFromSession];
    }
    else if([keyPath isEqualToString:userMailKeyPath]){
        [self loadAvatarAndHideSpinner:NO];
    }
}

#pragma mark - UIActionSheetDelegate method

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if([delegate respondsToSelector:@selector(willTakePicture:)]) {
            [delegate willTakePicture:self];
        }
        [self loadCapture:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == 1) {
        [self loadCapture:UIImagePickerControllerSourceTypePhotoLibrary];
    }  else if (buttonIndex == 2) {
        if([delegate respondsToSelector:@selector(didCancelTakePicture:)]) {
            [delegate didCancelTakePicture:self];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    CGSize imageSize = [image size];
    
    //We resize the image taken from the picker
    CGFloat maxWidth = 100.0;
    
    UIImage *resizedImage = [FZUIImageWithResize resized:image image:CGSizeMake(maxWidth, imageSize.height*maxWidth/imageSize.width) interpolationQuality:kCGInterpolationMedium];
    
    [self uploadImage:resizedImage];
    
    [[UserSession currentSession] reloadAvatarWithDefaultImage:[FZUIImageWithImage imageNamed:@"logo_default.png" inBundle:FZBundleAPI]];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    if([delegate respondsToSelector:@selector(didTakePicture:)]) {
        [delegate didTakePicture:self];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __block AccountBannerViewController *weakSelf = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if([delegate respondsToSelector:@selector(didCancelTakePicture:)]) {
            [delegate didCancelTakePicture:weakSelf];
        }
    }];
    
    
}

#pragma mark - Load methods

-(void)uploadImage:(UIImage*)image
{
    [_activityIndicator setHidden:NO];
    
    NSString *currentUserKey = [[UserSession currentSession] userKey];
    
    //send the new avatar to the server
    [AvatarServices setAvatarWithUserKey:currentUserKey avatar:image token:nil successBlock:^(id context) {
        FZPaymentLog(@"success uploading avatar");
        
        [[UserSession currentSession] reloadAvatarWithDefaultImage:[FZUIImageWithImage imageNamed:@"logo_default.png" inBundle:FZBundleAPI]];
    } failureBlock:^(Error *error) {
        [_activityIndicator setHidden:YES];
        FZPaymentLog(@"error uploading avatar");
    }];
}

-(void)loadCapture:(UIImagePickerControllerSourceType)mode
{
    if (![UIImagePickerController isSourceTypeAvailable:mode]) {
        
        NSString *title = [LocalizationHelper stringForKey:@"app_error" withComment:@"Global" inDefaultBundle:FZBundlePayment];
        
        NSString *message = [LocalizationHelper stringForKey:@"app_error_mode" withComment:@"Global" inDefaultBundle:FZBundlePayment];
        
        NSString *cancelButtonTitle = [LocalizationHelper stringForKey:@"app_ok" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
        
        //Simulator
        ODCustomAlertView *alertView = [[[ODCustomAlertView alloc] initWithTitle:title
                                                                         message:message
                                                                        delegate:nil
                                                               cancelButtonTitle:cancelButtonTitle
                                                               otherButtonTitles: nil] autorelease];
        
        [alertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor blackColor]];
        [alertView show];
        
    }else{
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = mode;
        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:^{}];
        
        [picker release];
        
    }
}

-(IBAction)loadingNewAvatar:(id)sender {
    
    if([self isChangingAvatarAllowed] && [self isChangingAvatarRules]){
        if (delegate != nil && [delegate respondsToSelector:@selector(showChoice:)]) {
            [delegate showChoice:self];
        }
        
        
        [[StatisticsFactory sharedInstance] checkPointAddAvatar];
        
        NSString *title = [LocalizationHelper stringForKey:@"accountBannerViewController_action_sheet" withComment:@"AccountBannerViewController" inDefaultBundle:FZBundleCoreUI];
        
        NSString *cancelButtonTitle = [LocalizationHelper stringForKey:@"app_cancel" withComment:@"Global" inDefaultBundle:FZBundleBlackBox];
        
        NSString *fromCameraTitle = [LocalizationHelper stringForKey:@"accountBannerViewController_from_camera" withComment:@"AccountBannerViewController" inDefaultBundle:FZBundleCoreUI];
        
        NSString *fromLibraryTitle = [LocalizationHelper stringForKey:@"accountBannerViewController_from_library" withComment:@"AccountBannerViewController" inDefaultBundle:FZBundleCoreUI];
        
        _actionSheet = [[[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:fromCameraTitle, fromLibraryTitle, nil]autorelease];
        
        _actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        
        // TODO :crap cast test
        if([delegate isKindOfClass:NSClassFromString(@"HistoryViewController")]){
            [_actionSheet showInView:[(UIViewController*)delegate view]];
        }else{
            UIViewController *customTabBarViewController = [[[self parentViewController] parentViewController] parentViewController];
            
            [_actionSheet showFromToolbar:[customTabBarViewController view]];
        }
    
    }
}

-(void) loadAvatarAndHideSpinner:(BOOL)hide{
    if([[UserSession currentSession]isUserConnected]){
        NSLog(@"connected");
        dispatch_queue_t backgroundQueue = dispatch_queue_create("com.flashiz.account.banner", 0);
        
        dispatch_async(backgroundQueue, ^{
            
            if([[[[UserSession currentSession] user] email] length]){
                [AvatarServices avatarWithUserName:[[[UserSession currentSession] user] username]
                                      successBlock:^(id context) {
                                          
                                          FZUIImageWithFZBinaryArray *image = [FZUIImageWithFZBinaryArray imageFromBinaryArray:context withDefautImage:[FZUIImageWithImage imageNamed:@"logo_default.png" inBundle:FZBundleAPI]];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [[self imageAvatar] setImage:image forState:UIControlStateNormal];
                                              
                                              if(hide){
                                                  [_activityIndicator setHidden:YES];
                                              }
                                          });
                                          
                                          dispatch_release(backgroundQueue);
                                          
                                      } failureBlock:^(Error *error) {
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              //By default we reset avatar image
                                              [[self imageAvatar] setImage:nil forState:UIControlStateNormal];
                                          });
                                          
                                          dispatch_release(backgroundQueue);
                                          
                                          FZPaymentLog(@"error loading avatar");
                                      }];
            }
            
        });
        
        //By default we set the image with no avatar png
        [_imageAvatar setImage:[FZUIImageWithImage imageNamed:@"arrow_right_white" inBundle:FZBundleBlackBox] forState:UIControlStateNormal];
        
        UIImage *avatarImage = [[UserSession currentSession] avatarWithDefaultImage:[FZUIImageWithImage imageNamed:@"logo_default.png" inBundle:FZBundleAPI]];
        
        if(nil!=avatarImage) {
            [[self imageAvatar] setImage:[[UserSession currentSession] avatarWithDefaultImage:[FZUIImageWithImage imageNamed:@"logo_default.png" inBundle:FZBundleAPI]] forState:UIControlStateNormal];
        }
        
        if(hide){
            [_activityIndicator setHidden:YES];
        }
        
    }else{
        NSLog(@"no need load avatar");
    }
    
}

-(void)loadBalanceFromSession{
    
    
    if([[UserSession currentSession] isUserConnected]){
        [[self lblCurrentBalance] setText:[[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",[[[[UserSession currentSession] user] account] balance]] currency:[[[[UserSession currentSession] user] account] currency]]];
    } else {
        [[self lblCurrentBalance] setText:@""];
    }
    
}

-(void)setBalance:(float)balance {
    
    if([[UserSession currentSession] isUserConnected]){
        [[self lblCurrentBalance] setText:[[CurrenciesManager currentManager] formattedAmount:[NSString stringWithFormat:@"%.2f",balance] currency:[[[[UserSession currentSession] user] account] currency]]];
    } else {
        [[self lblCurrentBalance] setText:@""];
    }
    
}

#pragma mark - Actions

- (IBAction)goToOrCloseHistoric:(id)sender {
    if(!_isHistoryViewController) {
        [[StatisticsFactory sharedInstance] checkPointViewHistory];
        if([delegate respondsToSelector:@selector(goToOrCloseHistoric)]){
            [delegate goToOrCloseHistoric];
        }
    } else {
        [[[self parentViewController] navigationController] popViewControllerAnimated:YES];
    }
}



#pragma mark - Actions

-(void)avatarLoaded:(NSNotification*)aNotification
{
    [[self imageAvatar] setImage:[aNotification object] forState:UIControlStateNormal];
    [_activityIndicator setHidden:YES];
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvatarLoadedNotification object:nil];
    
    [self stopObservingSessionUser];
    
    if(_imageAvatar != nil){
        [_imageAvatar release];
    }
    
    if(_lblYourBalance != nil){
        [_lblYourBalance release];
    }
    
    if(lblCurrentBalance != nil){
        [lblCurrentBalance release];
    }
    
    if(_btnGoToOrCloseHistoric != nil){
        [_btnGoToOrCloseHistoric release];
    }
    
    if(_activityIndicator != nil){
        [_activityIndicator release];
    }
    
    if(_imgAvatarMask != nil){
        [_imgAvatarMask release];
    }

    [super dealloc];
}

@end
