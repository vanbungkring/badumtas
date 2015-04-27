//
//  detaiSharedViewController.h
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import <UIKit/UIKit.h>
@class ModelBeli;
@interface detaiSharedViewController : UIViewController
@property(nonatomic,strong)ModelBeli *subMerchant;
@property(nonatomic,strong)NSString *index_pass;
@property(nonatomic,strong)NSString *title_;
@property(nonatomic,strong)NSString *transactType;
@property(nonatomic,strong)NSString *state;
@end
