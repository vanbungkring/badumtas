//
//  BeliSharedDetailViewController.h
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import <UIKit/UIKit.h>
@class AbstractActionSheetPicker;
@interface BeliSharedDetailViewController : UIViewController
@property (nonatomic,strong)NSString *subMerchantId;
@property (nonatomic,strong)NSString *parentId;
@property(nonatomic,strong)NSString *transactionJenis;
@property(nonatomic,strong)NSString *jenisField;
@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *transactionNameParent;
@property(nonatomic,strong)NSString *tagPass;
@property(nonatomic,strong)NSString *fielTextdPass;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@end
