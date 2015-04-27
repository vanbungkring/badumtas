//
//  bayarTableViewCell.m
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import "bayarTableViewCell.h"
#import "ModelBeli+Bayar.h"
#import "ModelBeli+BayarManager.h"
#import "UIImageView+AFNetworking.h"
@implementation bayarTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setBayar:(ModelBeli_Bayar *)bayar{
    _bayar = bayar;
    NSLog(@"bayar->%@",bayar);
    self.merchantName.text = _bayar.mnama;
    [self.merchantAvatar setImageWithURL:[NSURL URLWithString:_bayar.mimage] placeholderImage:[UIImage imageNamed:@"icon-57"]];
    self.merchantAvatar.contentMode = UIViewContentModeScaleAspectFit;
    
    //    [[self.merchantAvatar setImageWithURL:[NSURL URLWithString:_bayar.mimage] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
}
-(void)setManager:(ModelBeli_BayarManager *)manager{
    _manager = manager;
    self.merchantName.text =_manager.jsonMnama;
    [self.merchantAvatar setImageWithURL:[NSURL URLWithString:_manager.jsonMimage] placeholderImage:[UIImage imageNamed:@"icon-57"]];
    self.merchantAvatar.contentMode = UIViewContentModeScaleAspectFit;
    
    
}
@end
