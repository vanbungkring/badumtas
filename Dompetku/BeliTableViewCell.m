//
//  BeliTableViewCell.m
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import "BeliTableViewCell.h"
#import "ModelBeli+Bayar.h"
#import "ModelBayar.h"
#import "modelSubMerchant.h"
#import "UIImageView+AFNetworking.h"
#import "ModelBeli+BayarManager.h"
@implementation BeliTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setBeli:(ModelBeli_Bayar *)beli {
    _beli = beli;
    self.merchantName.text = _beli.mnama;
    [self.merchantAvatar setImageWithURL:[NSURL URLWithString:_beli.mimage] placeholderImage:[UIImage imageNamed:@"icon-57"]];
}
-(void)setManager:(ModelBeli_BayarManager *)manager{
    _manager = manager;
    self.merchantName.text = _manager.jsonMnama;
    [self.merchantAvatar setImageWithURL:[NSURL URLWithString:_manager.jsonMimage] placeholderImage:[UIImage imageNamed:@"icon-57"]];
}
@end


