//
//  LoginCell.m
//  iMobey
//
//  Created by Olivier Demolliens on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "LoginCell.h"

//BundleHelper
#import "BundleHelper.h"

//Color
#import "ColorsConstants.h"
#import "ColorHelper.h"

//Image
#import "FZUIImageWithImage.h"

//Font
#import "FontHelper.h"

//PlaceHolderFontTextField
#import "PlaceHolderFontTextField.h"

@interface LoginCell() <UITextFieldDelegate>
{
    
}
@property (retain, nonatomic) IBOutlet UIImageView *imgViewLeft;
@property (retain, nonatomic) IBOutlet UIButton *imgViewRight;
@property (retain, nonatomic) IBOutlet UITextField *textField;
@property (retain, nonatomic) NSString *imgRightName;

@end

@implementation LoginCell

#pragma mark - Customize

-(void)awakeFromNib
{
    //No selected color cell
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    view.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = view;
    [view release];
    //
}

#pragma mark - Skin

-(void)redSkin
{
    [_textField setTextColor:[UIColor redColor]];
    [_textField setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:16.0f]];

}

-(void)blueSkin
{
    [_textField setTextColor:[[ColorHelper sharedInstance] loginCell_textField_textColor]];
    [_textField setFont:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:16.0f]];
}


#pragma mark - Manual Accessor

-(UITextField*)textFieldCell
{
    return _textField;
}

#pragma mark - Data

-(void)setLeftImageName:(NSString*)leftImageName andPlaceholderText:(NSString*)placeholderText andRightImageName:(NSString*)rightImageName
{
    [_textField setPlaceholder:[placeholderText uppercaseString]];
    
    //set placeholder color
    NSMutableAttributedString *attributesString = [[NSMutableAttributedString alloc] initWithAttributedString:[_textField attributedPlaceholder]];
    [attributesString addAttribute:NSForegroundColorAttributeName value:[[ColorHelper sharedInstance] monochromeTwoColor] range:NSMakeRange(0, [_textField.text length])];
    // Set new text with extracted attributes
    _textField.attributedPlaceholder = attributesString;
    [attributesString release];
    
    //set placeholder font
    [_textField setValue:[[FontHelper sharedInstance] fontFuturaCondensedLightWithSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
    
    if (leftImageName != nil) {
        UIImage *image = [FZUIImageWithImage imageNamed:leftImageName inBundle:FZBundleBlackBox];
        [_imgViewLeft setImage:image];
    }else{
        [_imgViewLeft setImage:nil];
    }
    
    if (rightImageName != nil) {
        [_imgViewRight setHidden:NO];
        [_textField setSecureTextEntry:YES];

        UIImage *image = [FZUIImageWithImage imageNamed:rightImageName inBundle:FZBundleBlackBox];
        [_imgViewRight setImage:image forState:UIControlStateNormal];
        [self setImgRightName:rightImageName];
    }else{
        [_imgViewRight setImage:nil forState:UIControlStateNormal];
        [_textField setSecureTextEntry:NO];
    }
}

#pragma mark - Action

-(IBAction)hideTextViewContent:(id)sender
{
    if ([_textField isSecureTextEntry]) {
        [_textField setSecureTextEntry:NO];
        [self colorEye];
    }else{
        [_textField setSecureTextEntry:YES];
        [self colorEye];
    }
}

- (void)colorEye {
    UIImage *image = [FZUIImageWithImage imageNamed:@"icon_eye_color" inBundle:FZBundleBlackBox];
    [_imgViewRight setImage:image forState:UIControlStateNormal];
}

- (void)grayEye {
    UIImage *image = [FZUIImageWithImage imageNamed:@"icon_eye" inBundle:FZBundleBlackBox];
    [_imgViewRight setImage:image forState:UIControlStateNormal];
}


#pragma mark - Override

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - MM

- (void)dealloc {
    [_imgViewLeft release];
    [_imgViewRight release];
    [_textField release];
    [_imgRightName release];
    [super dealloc];
}

@end