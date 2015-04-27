//
//  FavoriteTableViewCell.m
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import "FavoriteTableViewCell.h"
#import "transactionFavorite.h"
@implementation FavoriteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFav:(transactionFavorite *)fav{
    _fav =fav;
    /*
     @property (strong, nonatomic) IBOutlet UILabel *FavoriteName;
     @property (strong, nonatomic) IBOutlet UILabel *favoriteDetail;
     @property (strong, nonatomic) IBOutlet UILabel *FavoriteBreadCrumbs;
     */
    _FavoriteName.text =_fav.name;
    _favoriteDetail.text = _fav.fieldInformation;
    _FavoriteBreadCrumbs.text = [NSString stringWithFormat:@"%@-%@-%@",_fav.state,_fav.parent,_fav.merchant];
}
@end
