//
//  LoginCell.h
//  iMobey
//
//  Created by Olivier Demolliens on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

//Parent 
#import "ReuseTableViewCell.h"

@interface LoginCell : ReuseTableViewCell
{
    
}

-(void)setLeftImageName:(NSString*)leftImageName andPlaceholderText:(NSString*)placeholderText andRightImageName:(NSString*)rightImageName;

-(UITextField*)textFieldCell;

-(void)redSkin;
-(void)blueSkin;

- (void)colorEye;
- (void)grayEye;

@end
