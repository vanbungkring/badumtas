//
//  ReuseTableViewCell.h
//  iMobey
//
//  Created by Olivier Demolliens on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <UIKit/UIKit.h>

//Enum
#import <FZAPI/FZFilesEnum.h>

@interface ReuseTableViewCell : UITableViewCell
{
    
}

+(id)dequeueReusableCellWithtableView:(UITableView*)tableview;
+ (id)loadCellWithOwner:(UIViewController*)controller inDefault:(FZBundleName)bundle;

@end
