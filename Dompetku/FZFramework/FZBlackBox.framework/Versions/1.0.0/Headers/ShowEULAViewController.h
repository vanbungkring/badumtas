//
//  ShowEULAViewController.h
//  FZBlackBox
//
//  Created by julian Clémot on 06/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FZBlackBox/ShowEulaDelegate.h>
#import <FZBlackBox/GenericViewController.h>



@interface ShowEULAViewController : GenericViewController

@property (assign,nonatomic) id<ShowEulaDelegate> delegateEula;

- (id)initWithUrl:(NSString *)urlOfEula;

@end
