//
//  AllLoyaltyProgramsNavBarOpenedViewController.m
//  iMobey
//
//  Created by Matthieu Barile on 16/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "AllLoyaltyProgramsNavBarOpenedViewController.h"

//Constants
#import <FZBlackBox/Constants.h>

//Localizable
#import <FZBlackBox/LocalizationHelper.h>

//Color
#import <FZBlackBox/ColorHelper.h>

//Util
#import <FZBlackBox/FZUIImageWithImage.h>

//Helper
#import <FZBlackBox/BundleHelper.h>

@interface AllLoyaltyProgramsNavBarOpenedViewController () <UITextFieldDelegate>
{
    
}

//private properties
@property (retain, nonatomic) IBOutlet UIButton *btnNearProgramsOpened;
@property (retain, nonatomic) IBOutlet UIButton *btnSuggestedProgramsOpened;
@property (retain, nonatomic) IBOutlet UITextField *textFieldSearchInAllProgramsOpened;
@property (retain, nonatomic) IBOutlet UIImageView *btnSearch;

//private actions
- (IBAction)showNearProgramsOpened:(id)sender;
- (IBAction)showSuggestedProgramsOpened:(id)sender;
- (IBAction)searchInAllPrograms:(id)sender;

@end

@implementation AllLoyaltyProgramsNavBarOpenedViewController

//public properties
@synthesize delegate;

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"AllLoyaltyProgramsNavBarOpenedViewController" bundle:[BundleHelper retrieveBundle:FZBundleRewards]];
    if (self) {
        
    }
    return self;
}

#pragma mark - Cycle life

- (void)viewDidLoad
{
    [super viewDidLoad];
    //add observer to start/stop the camera while displaying/hiding the side menu
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShowMenu:)
                                                 name:willShowMenuNotification
                                               object:nil];
    
    //set placeholder color
    NSMutableAttributedString *attributesString = [[NSMutableAttributedString alloc] initWithAttributedString:[_textFieldSearchInAllProgramsOpened attributedPlaceholder]];
    [attributesString addAttribute:NSForegroundColorAttributeName value:[[ColorHelper sharedInstance] monochromeTwoColor] range:NSMakeRange(0, [_textFieldSearchInAllProgramsOpened.text length])];
    //Set new text with extracted attributes
    _textFieldSearchInAllProgramsOpened.attributedPlaceholder = attributesString;
    [attributesString release];
    
    //Set placeholder font
    //[_textFieldSearchInAllProgramsOpened setValue:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:18.0f] forKeyPath:@"_placeholderLabel.font"];
    
    //placeholder text
    [_textFieldSearchInAllProgramsOpened setPlaceholder:[[LocalizationHelper stringForKey:@"rewards_search" withComment:@"FidelizHomeViewController" inDefaultBundle:FZBundleRewards]uppercaseString]];
    
    //Descope
    [_btnNearProgramsOpened setHidden:YES];
    [_btnSuggestedProgramsOpened setHidden:YES];
    [self.view setAutoresizesSubviews:YES];
    
    [_btnNearProgramsOpened setImage:[FZUIImageWithImage imageNamed:@"btn_program_around_off" inBundle:FZBundleRewards] forState:UIControlStateNormal];
    
     [_btnSuggestedProgramsOpened setImage:[FZUIImageWithImage imageNamed:@"btn_program_mystore_off" inBundle:FZBundleRewards] forState:UIControlStateNormal];
    
    [_btnSearch setImage:[FZUIImageWithImage imageNamed:@"btn_search" inBundle:FZBundleBlackBox]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Actions

- (IBAction)showNearProgramsOpened:(id)sender {
    [_textFieldSearchInAllProgramsOpened resignFirstResponder];
    if ([delegate respondsToSelector:@selector(showNearProgramsOpened)]) {
        [delegate showNearProgramsOpened];
    }
}

- (IBAction)showSuggestedProgramsOpened:(id)sender {
    [_textFieldSearchInAllProgramsOpened resignFirstResponder];
    if ([delegate respondsToSelector:@selector(showSuggestedProgramsOpened)]) {
        [delegate showSuggestedProgramsOpened];
    }
}

- (IBAction)searchInAllPrograms:(id)sender {
    if ([delegate respondsToSelector:@selector(searchInAllPrograms:)]) {
        [delegate searchInAllPrograms:sender];
    }
}

#pragma mark - Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)willShowMenu:(NSNotification *)notification
{
    [_textFieldSearchInAllProgramsOpened resignFirstResponder];
}

#pragma mark - MM

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:willShowMenuNotification
                                                  object:nil];

    [_btnNearProgramsOpened release];
    [_btnSuggestedProgramsOpened release];
    [_textFieldSearchInAllProgramsOpened release];
    [_btnSearch release];
    [super dealloc];
}
@end
