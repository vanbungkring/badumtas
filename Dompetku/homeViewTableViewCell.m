//
//  homeViewTableViewCell.m
//  Dompetku
//
//  Created by Indosat on 12/6/14.
//
//

#import "homeViewTableViewCell.h"
#import "NetraUserProfile.h"

@implementation homeViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setUserProfile:(NetraUserProfile *)userProfile{
    _userProfile = userProfile;
    if([userProfile.amount integerValue]<0){
        
        self.date.textColor = ORANGE_BORDER_COLOR;
        self.amout.textColor = ORANGE_BORDER_COLOR;
        
        //[[NetraCommonFunction sharedCommonFunction]formatToRupiah:[NSNumber numberWithInteger:[[_userProfile.amount stringByReplacingOccurrencesOfString:@"-" withString:@""]integerValue]]]
        self.amout.text =[NSString stringWithFormat:@"(%@)",[[NetraCommonFunction sharedCommonFunction]formatToRupiah:[NSNumber numberWithInteger:[[_userProfile.amount stringByReplacingOccurrencesOfString:@"-" withString:@""]integerValue]]]];
        self.trxName.textColor = ORANGE_BORDER_COLOR;
    }
    else{
        self.date.textColor = [UIColor blackColor];
        self.amout.textColor = [UIColor blackColor];
        self.trxName.textColor = [UIColor blackColor];
        self.amout.text=userProfile.amount;
    }
    NSRange range = [userProfile.date rangeOfString:@" "];
    self.date.text = [userProfile.date substringWithRange:NSMakeRange(0, range.location)];;
    self.trxName.text = userProfile.type;
}
@end
