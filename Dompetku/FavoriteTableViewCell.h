//
//  FavoriteTableViewCell.h
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import <UIKit/UIKit.h>
@class transactionFavorite;
@interface FavoriteTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *FavoriteName;
@property (strong, nonatomic) IBOutlet UILabel *favoriteDetail;
@property (strong, nonatomic) IBOutlet UILabel *FavoriteBreadCrumbs;
@property (strong,nonatomic) transactionFavorite *fav;

@end
