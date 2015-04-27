//
//  BayarCell.m
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import "BayarCell.h"
#import "SubMerchant.h"
#import <UIImageView+AFNetworking.h>
@implementation BayarCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSub:(SubMerchant *)sub{
    _sub = sub;
    _label.text = _sub.sub_merchant_nama;
    _label.hidden = YES;
    if([_sub.img_path isEqualToString:@""] ||[_sub.img_path isEqual:[NSNull null]]){
        _label.hidden = NO;
    }
    [_avatar setImageWithURL:[NSURL URLWithString:_sub.img_path] placeholderImage:[UIImage imageNamed:@"icon-57"]];
    
    
    
}
@end
