//
//  InboxTableViewCell.m
//  Dompetku
//
//  Created by Indosat on 12/28/14.
//
//

#import "InboxTableViewCell.h"
#import "Log.h"
#import "NetraCommonFunction.h"
@implementation InboxTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLog:(Log *)log{
    _log = log;
    _inboxName.text = _log.actionName;
    _inboxDate.text = [[NSString stringWithFormat:@"%@",_log.createdAt]stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    if(![_log.amount isEqualToString:@""])
        _amount.text = [NSString stringWithFormat:@"Rp. %@",[[NetraCommonFunction sharedCommonFunction]formatToRupiah:[NSNumber numberWithInteger:[_log.amount   integerValue]]]];
    else
        _amount.text= @"";
}
@end
