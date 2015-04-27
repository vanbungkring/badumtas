//
//  HistoryTableViewCell.m
//  Dompetku
//
//  Created by Indosat on 12/22/14.
//
//

#import "HistoryTableViewCell.h"
#import "NetraUserProfile.h"
#import "NetraCommonFunction.h"
@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUserProfile:(NetraUserProfile *)userProfile{
    _userProfile = userProfile;
    _historyName.text =_userProfile.type;
    _historyAmount.textAlignment = NSTextAlignmentRight;
    if([userProfile.amount integerValue]<0){
        
        _historyAmount.text = [NSString stringWithFormat:@"(Rp. %@)",[[NetraCommonFunction sharedCommonFunction]formatToRupiah:[NSNumber numberWithInteger:[[_userProfile.amount stringByReplacingOccurrencesOfString:@"-" withString:@""]integerValue]]]];
        _historyAmount.textColor = ORANGE_BORDER_COLOR;
        
    }
    else{
        _historyAmount.text = [NSString stringWithFormat:@"Rp. %@",[[NetraCommonFunction sharedCommonFunction]formatToRupiah:[NSNumber numberWithInteger:[[_userProfile.amount stringByReplacingOccurrencesOfString:@"-" withString:@""]integerValue]]]];
        _historyAmount.textColor = [UIColor blackColor];
    }
    NSRange range = [userProfile.date rangeOfString:@" "];
    self.date.text = [userProfile.date substringWithRange:NSMakeRange(0, range.location)];;
    _vendorName.text = _userProfile.agent;
    _date.text = _userProfile.date;

}
@end
