//
//  BeliCell.m
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import "BeliCell.h"
#import "SubMerchant.h"
#import <UIImageView+AFNetworking.h>
@implementation BeliCell

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
    self.avatar.contentMode = UIViewContentModeScaleAspectFit;
    

    
}
//if([[_merchant_detail_Image objectAtIndex:indexPath.row] isEqualToString:@""] ||[[_merchant_detail_Image objectAtIndex:indexPath.row] isEqual:[NSNull null]]){
//    cell.merhcantName.hidden = NO;
//}
//if(indexPath.row%2==0){
//    cell.contentView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
//    cell.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
//}
//else{
//    
//    cell.contentView.backgroundColor  =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
//    cell.backgroundColor =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
//}
//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//return cell;}

@end
