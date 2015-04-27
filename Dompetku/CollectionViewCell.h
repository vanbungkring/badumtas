//
//  CollectionViewCell.h
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import <UIKit/UIKit.h>

@class MerchantList;
@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) MerchantList *merl;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *merchantLabel;

@end
