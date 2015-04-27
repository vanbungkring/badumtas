//
//  BeliDetailTableViewController.h
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import <UIKit/UIKit.h>

@interface BeliDetailTableViewController : UITableViewController
@property (nonatomic) NSString *merchantState;
@property (nonatomic) NSInteger merchantId;
@property (nonatomic,strong) NSMutableArray *merchantSub;
@end
