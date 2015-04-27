//
//  InboxTableViewCell.h
//  Dompetku
//
//  Created by Indosat on 12/28/14.
//
//

#import <UIKit/UIKit.h>
@class Log;
@interface InboxTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *inboxDate;
@property (strong, nonatomic) IBOutlet UILabel *inboxName;
@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (nonatomic,strong)Log *log;

@end
