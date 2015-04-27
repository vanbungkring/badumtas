//
//  BeliCell.h
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import <UIKit/UIKit.h>

@class SubMerchant;
@interface BeliCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong,nonatomic)SubMerchant *sub;
@end
