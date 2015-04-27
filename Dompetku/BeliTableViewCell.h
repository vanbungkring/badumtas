//
//  BeliTableViewCell.h
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import <UIKit/UIKit.h>
@class ModelBeli_Bayar;

@class ModelBeli_BayarManager;
@interface BeliTableViewCell : UITableViewCell
@property(nonatomic,strong) ModelBeli_Bayar *beli;
@property(nonatomic,strong) ModelBeli_BayarManager *manager;
@property (strong, nonatomic) IBOutlet UILabel *merchantName;
@property (strong, nonatomic) IBOutlet UIImageView *merchantAvatar;

@end
