//
//  bayarTableViewCell.h
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import <UIKit/UIKit.h>
@class ModelBeli_Bayar;
@class ModelBeli_BayarManager;
@interface bayarTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *merchantName;
@property (strong, nonatomic) IBOutlet UIImageView *merchantAvatar;
@property(nonatomic,strong) ModelBeli_Bayar *bayar;
@property(nonatomic,strong) ModelBeli_BayarManager *manager;
@end
