//
//  TranscationDetailSharedViewController.h
//  Dompetku
//
//  Created by Indosat on 11/30/14.
//
//

#import <UIKit/UIKit.h>
@class AbstractActionSheetPicker;
@interface TranscationDetailSharedViewController : UIViewController
@property(nonatomic,strong)NSString *transactionJenis;
@property(nonatomic,strong)NSString *jenisField;
@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *transactionNameParent;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@end
