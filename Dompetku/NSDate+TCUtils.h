//
//  NSDate+TCUtils.h
//  Dompetku
//
//  Created by Indosat on 12/1/14.
//
//

#import <Foundation/Foundation.h>
@interface NSDate(TCUtils)
- (NSDate *)TC_dateByAddingCalendarUnits:(NSCalendarUnit)calendarUnit amount:(NSInteger)amount;
@end
