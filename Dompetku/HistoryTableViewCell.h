//
//  HistoryTableViewCell.h
//  Dompetku
//
//  Created by Indosat on 12/22/14.
//
//

#import <UIKit/UIKit.h>
@class NetraUserProfile;;
@interface HistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *historyName;
@property (strong, nonatomic) IBOutlet UILabel *historyAmount;
@property (strong, nonatomic) IBOutlet UILabel *vendorName;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (nonatomic,strong)NetraUserProfile *userProfile;


@end
