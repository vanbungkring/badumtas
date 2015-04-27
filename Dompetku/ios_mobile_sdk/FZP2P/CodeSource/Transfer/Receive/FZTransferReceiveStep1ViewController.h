//
//  TransferReceiveStep1ViewController.h
//  iMobey
//
//  Created by Yvan Moté on 13/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//


#import <FZBlackBox/HeaderViewController.h>


@interface FZTransferReceiveStep1ViewController : HeaderViewController <UITextFieldDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UIView *viewAmount;
@property (retain, nonatomic) IBOutlet UIView *viewDescription;
@property (retain, nonatomic) IBOutlet UILabel *lblDescription;

- (void)addsOnSetupView;

@end
