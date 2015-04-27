//
//  TransferReceiveStep2ViewController.h
//  iMobey
//
//  Created by Yvan Moté on 13/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <FZBlackBox/HeaderViewController.h>

#import <FZPayment/ActionSuccessfulViewController.h>


@interface TransferReceiveStep2ViewController : HeaderViewController
{
    
}

- (id)initWithURL:(NSString *)url amount:(NSString *)amount currency:(NSString *)currency;
- (IBAction)cancelAction:(id)sender;

- (void)presentActionViewController;

@end
