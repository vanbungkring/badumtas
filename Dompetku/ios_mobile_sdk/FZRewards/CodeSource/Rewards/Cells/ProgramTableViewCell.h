//
//  ProgramTableViewCell.h
//  iMobey
//
//  Created by Matthieu Barile on 16/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <FZBlackBox/ReuseTableViewCell.h>

typedef enum {
    PointsAndPercentProgram,
    CouponsProgram,
    SuggestedProgram,
    NearProgram,
    SearchInAllProgram
} Indication ;

@interface ProgramTableViewCell : ReuseTableViewCell

- (void)setProgramName:(NSString*)programName;
- (void)setMerchantName:(NSString*)merchantName;
- (void)setLogo:(UIImage *)image;
- (void)setUpTableCellViewWithIndicationPointsAndPercent:(NSString*)pointsAndPercent;
- (void)setUpTableCellViewWithIndicationNear:(NSString*)distance;
- (void)setUpTableCellViewWithIndicationCoupons:(NSString*)numberOfCoupons :(NSString*)amountOfACoupon;
- (void)setUpTableCellViewWithIndicationCouponsPercent:(NSString*)numberOfCoupons :(NSString*)amountOfACoupon;
- (void)setUpTableCellViewWithIndicationSuggested:(NSString*)numberOfPurchases;
- (void)setUpTableCellViewForAllPrograms;

- (void) isOdd;
- (void) isEven;

-(void)reset;

@end
