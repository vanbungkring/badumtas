//
//  TransferHomeViewController.h
//  iMobey
//
//  Created by Yvan Moté on 13/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FZBlackBox/HeaderViewController.h>

@interface TransferHomeViewController : HeaderViewController
{
    
}

@property (retain, nonatomic) IBOutlet UILabel *lblReceive;
@property (retain, nonatomic) IBOutlet UILabel *lblSend;

- (IBAction)receiveAmount:(id)sender;
- (IBAction)transferAmount:(id)sender;

@end
