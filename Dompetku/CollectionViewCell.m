//
//  CollectionViewCell.m
//  Dompetku
//
//  Created by Indosat on 12/21/14.
//
//

#import "CollectionViewCell.h"
#import "MerchantList.h"
#import <UIImageView+AFNetworking.h>
@implementation CollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // WRONG:
        // _imageView = [[UIImageView alloc] initWithFrame:frame];
        
        // RIGHT:
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _merchantLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 30)];
        [_merchantLabel setCenter:self.contentView.center];
        _merchantLabel.textAlignment = NSTextAlignmentCenter;
        _merchantLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _merchantLabel.textColor = [UIColor orangeColor];
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_merchantLabel];
    }
    return self;
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // reset image property of imageView for reuse
    self.imageView.image = nil;
    
    // update frame position of subviews
    self.imageView.frame = self.contentView.bounds;
}

@end
