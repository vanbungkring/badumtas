//
//  ReuseTableViewCell.m
//  iMobey
//
//  Created by Olivier Demolliens on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "ReuseTableViewCell.h"

//TODO: need refactor
#import "BundleHelper.h"

@implementation ReuseTableViewCell


+ (id)dequeueReusableCellWithtableView:(UITableView*)tableview
{
    return [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
}

+ (id)loadCellWithOwner:(UIViewController*)controller inDefault:(FZBundleName)bundle
{
    NSString *className = [[self class] description];
    
    id cell = nil;
    
    cell = [[BundleHelper sharedInstance] loadNibResourceInMainBundleWithName:className orLoadRessourceInDefaultBundle:bundle];
    
    return cell;
}

@end
