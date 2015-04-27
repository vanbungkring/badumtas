//
//  homeViewTableViewCell.h
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import <UIKit/UIKit.h>
@class NetraUserProfile;
@interface homeViewTableViewCell : UITableViewCell
@property (nonatomic,strong)NetraUserProfile *userProfile;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *trxName;
@property (strong, nonatomic) IBOutlet UILabel *amout;

@end
