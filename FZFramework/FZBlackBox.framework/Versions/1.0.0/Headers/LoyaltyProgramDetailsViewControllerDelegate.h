//
//  LoyaltyProgramDetailsViewControllerDelegate.h
//  FZBlackBox
//
//  Created by julian Clémot on 30/06/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoyaltyProgramDetailsViewControllerDelegate <NSObject>

- (void)showYourProgramsWithAddedProgram:(LoyaltyProgram *)loyaltyProgram;

- (void)didGoBackFromYourDetails;

@end
