//
//  LoginViewController.h
//  iMobey
//
//  Created by Yvan Moté on 08/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericViewController.h"

@class User;
@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

- (void)didConnectWithUser:(User *)user withUserKey:(NSString *)userKey;
- (void)didFailConnecting;
- (void)didClose:(LoginViewController *)loginViewController;

@end

@interface LoginViewController : GenericViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIView *loginViewHeader;
@property (retain, nonatomic) IBOutlet UIView *viewBanner;
@property (retain, nonatomic) IBOutlet UIButton *btnClose;
@property (retain, nonatomic) IBOutlet UIImageView *imgPaymentFlash;
@property (retain, nonatomic) IBOutlet UIImageView *imgLogo;
@property (retain, nonatomic) IBOutlet UIView *viewBody;

@property (nonatomic, assign) id <LoginViewControllerDelegate> delegate;

@property (retain, nonatomic) UITextField *usernameTextField;
@property (retain, nonatomic) UITextField *passwordTextField;

- (id)initWithMail:(NSString *)email andPassword:(NSString *)pwd;

- (void)hideHeaderView;
- (void)forceResize;
- (void)setupViewBanner;

- (IBAction)login:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)forgottenPassword:(id)sender;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
