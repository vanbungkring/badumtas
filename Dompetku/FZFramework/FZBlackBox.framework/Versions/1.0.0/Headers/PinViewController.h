//
//  PinViewController.h
//  iMobey
//
//  Created by Yvan Moté on 09/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "PinViewController.h"
#import "HeaderViewController.h"

@protocol PinViewControllerDelegate <NSObject>

- (void)pinViewControllerDidClose:(PinViewController *)pinViewController;
- (void)pinViewControllerDidBack:(PinViewController *)pinViewController;

@optional
- (void)pinViewController:(PinViewController *)pinViewController didEnterPinCode:(NSString *)code;


@end

@interface PinViewController : HeaderViewController <UITextFieldDelegate>

@property (nonatomic, copy) PinCompletionBlock pinCompletionBlock;
@property (nonatomic, assign) id <PinViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL fromWindow;
@property (nonatomic, assign) BOOL showCloseButton;
@property (assign, nonatomic) int wrongPinCode;
@property (nonatomic, retain, readonly) NSString *currentPinCode;

@property (assign, nonatomic) BOOL noTitleMode;
@property (nonatomic, assign) BOOL changePinEngaged;

@property (nonatomic, assign) BOOL debugMemory;

- (id)initWithModeSmall;

- (id)initWithCompletionBlock:(PinCompletionBlock)completionBlock andNavigationTitle:(NSString*)navtitle  andTitle:(NSString*)title andTitleHeader:(NSString *)headerTitle andDescription:(NSString*)description animated:(BOOL)animated modeSmall:(BOOL)isSmall;

- (void)resetPinCode;

- (void)dismissKeyboards;
- (void)removeBackButton;
- (void)setupBackButton;

- (void)setCompletionBlock:(PinCompletionBlock)completionBlock andNavigationTitle:(NSString*)navtitle  andTitle:(NSString*)title andTitleHeader:(NSString *)headerTitle andDescription:(NSString*)description animated:(BOOL)animated;
- (void)forceClose;

- (int)wrongPinCode;
- (void)setWrongPinCode:(int)time;

@end
