//
//  ODDateUtil.h
//  ostalgo
//
//  Created by Olivier Demolliens on 30/04/11.
//  Copyright 2010 company. All rights reserved.
//

#import "ODDateUtil.h"


@implementation ODDateUtil

static NSDateFormatter *dateFormatter_ = nil;

#pragma mark - Private method

+ (void)initializeDateFormatter {
    if(dateFormatter_==nil) {
        dateFormatter_ = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter_ setDateFormat:@""];
    [dateFormatter_ setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter_ setTimeStyle:NSDateFormatterNoStyle];
}

+ (NSDate *)dateFromString:(NSString *)dateString
            withDateFormat:(NSString *)dateFormat {
    [ODDateUtil initializeDateFormatter];
    
    [dateFormatter_ setDateFormat:dateFormat];
    
    return [dateFormatter_ dateFromString:dateString];
}

+ (NSString *)stringFromDate:(NSDate *)date
              withDateFormat:(NSString *)dateFormat {
    [ODDateUtil initializeDateFormatter];
    
    [dateFormatter_ setDateFormat:dateFormat];
    
    return [dateFormatter_ stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    [ODDateUtil initializeDateFormatter];
    
    return [dateFormatter_ dateFromString:dateString];
}

#pragma mark - Public methods

/* General Method */

+(NSDate*)getDateFromString:(NSString*)dateString
{
    return [ODDateUtil dateFromString:dateString
                       withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}


+(NSDate*)getDateFromStringNoTime:(NSString*)dateString
{
    return [ODDateUtil dateFromString:dateString
                       withDateFormat:@"yyyy-MM-DD"];
}

+(NSDate*)getDateToMidnight:(NSDate*)date
{
	
	NSString *formattedTime = [ODDateUtil stringFromDate:date
                                withDateFormat:@"yyyy-d-M"];
    
   return [ODDateUtil dateFromString:formattedTime];
}


+(NSString*)getDate:(NSDate*)date withParams:(NSString*)strFormattedDate
{
	return [ODDateUtil stringFromDate:date
                       withDateFormat:strFormattedDate];
}

/*
 Get the string of the date and the time, used for the request at the server
 */

+(NSString*)getDateToString:(NSDate*)date
{
	return [[date description]substringToIndex:NUMBERDATEANDTIME];
}

/*
 Get the string of the date, used for the request at the server
 */

+(NSString*)getOnlyDateToString:(NSDate*)date
{
	return [[date description]substringToIndex:NUMBERDATE];
}

/*
 Get the nextDay
 */

+(NSDate*)getNextDay:(NSDate*)date
{
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	components.day = 1;
	NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
	
	return newDate;
}

+(NSDate*)addAtThisDate:(NSDate*)date day:(NSInteger)numberOfDay
{
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	components.day = (int)numberOfDay;
	NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
	
	return newDate;
}

+(NSDate*)addAtThisDate:(NSDate*)date minutes:(NSInteger)minutes
{
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	components.minute = (int)minutes;
	NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
	
	return newDate;
}

/*
 Get the previousDay
 */

+(NSDate*)getPreviousDay:(NSDate*)date
{
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	components.day = -1;
	NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
	
	return newDate;
}

/*
 Get the nextDay in string
 */

+(NSString*)getNextDayString:(NSDate*)date
{
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	components.day = 1;
	NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
	
	return [ODDateUtil stringFromDate:newDate withDateFormat:@"d MMM"];
}

/*
 Get the previousDay in string
 */

+(NSString*)getPreviousDayString:(NSDate*)date
{
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	components.day = -1;
	NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
	
    return [ODDateUtil stringFromDate:newDate withDateFormat:@"d MMM"];
}


/*
 Get the classic format of a date (format : lundi 18 octobre 2010)
 */

+(NSString*)getFormatDateLiteral:(NSDate*)date
{
	
	NSDateFormatter *dateFormatter= [[NSDateFormatter alloc]init];
	[dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
	NSString *dateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	
	return dateString;
}

+(NSString*)getFormatDate:(NSDate*)date
{
	
	NSDateFormatter *dateFormatter= [[NSDateFormatter alloc]init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *dateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	
	return dateString;
}


+(NSString*)getHoursDate:(NSDate*)date
{
    return [ODDateUtil stringFromDate:date withDateFormat:@"HH-mm"];
}


/*
 Get the string of a date (format : 13:45)
 */

+(NSString*)getTimeDate:(NSDate*)date
{
    
	NSDateFormatter *dateFormatter= [[NSDateFormatter alloc]init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	
	return dateString;
}

/*
 Get the string of a date and the time (format : lundi 18 octobre 2010 13h40)
 */

+(NSString*)getTimeAndDate:(NSDate*)date
{
	NSDateFormatter *dateFormatter= [[NSDateFormatter alloc]init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	NSString *dateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	
	return dateString;
}

+(NSDate*)dateWithoutGmtUser:(NSDate*)date
{
    NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"+0000"];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:date] autorelease];
	return destinationDate;
}

+(NSDate*)dateWithGmtUser:(NSDate*)date
{
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"+0000"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:date] autorelease];
    
    return destinationDate;
}


+(NSDate*)getDateDuration:(NSInteger)value
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMinute:value];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps];
	[comps release];
    [gregorian release];
	return date;
}

+(NSString*)getHourFromDate:(NSDate*)date
{
    return [ODDateUtil stringFromDate:date withDateFormat:@"HH"];
}

+(NSString*)getDayFromDate:(NSDate*)date
{
    return [ODDateUtil stringFromDate:date withDateFormat:@"DD"];
}

+(NSString*)getYearFromDate:(NSDate*)date
{
    return [ODDateUtil stringFromDate:date withDateFormat:@"yyyy"];
}

+(NSString*)getMonthFromDate:(NSDate*)date
{
    return [ODDateUtil stringFromDate:date withDateFormat:@"M"];
}

+(NSString*)getSecondFromDate:(NSDate*)date
{
    return [ODDateUtil stringFromDate:date withDateFormat:@"ss"];
}

+(NSString*)getMinuteFromDate:(NSDate*)date
{
    return [ODDateUtil stringFromDate:date withDateFormat:@"mm"];
}

+(int)getIntHourFromDate:(NSDate*)date
{
    return [[ODDateUtil stringFromDate:date withDateFormat:@"HH"] intValue];
}

+(int)getIntMinuteFromDate:(NSDate*)date
{
    return [[ODDateUtil stringFromDate:date withDateFormat:@"mm"] intValue];
}

+(NSString*)getHourAndMinuteFromDate:(NSDate*)date
{
    //Hour
    NSString *hour = [ODDateUtil stringFromDate:date
                       withDateFormat:@"HH"];
    
    //Minute
	NSString *minute = [ODDateUtil stringFromDate:date
                       withDateFormat:@"mm"];
    
	return [NSString stringWithFormat:@"%@:%@",hour,minute];
}


/*
 Convert a quantity of second in this format (15 h 5 min)
 */

+(NSString*)getSecondToTime:(int)second
{
	return [NSString stringWithFormat:@"%i h %i min",(second/60/60), (second/60) - (second/60/60)*60];	
}


+(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
	
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
	
    return YES;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+ (NSInteger)hoursBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSHourCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSHourCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSHourCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference hour];
}

+ (NSInteger)secondBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSTimeInterval interval = [fromDateTime timeIntervalSinceDate:toDateTime];
    
    return (int)interval;
}


+(BOOL)day:(NSDate*)date1 isLaterThanOrEqualTo:(NSDate*)date2 {
	return !([date1 compare:date2] == NSOrderedAscending);
}


+(NSString*)getDuration:(NSInteger)value
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMinute:value];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps];
	[comps release];
    [gregorian release];
	return [ODDateUtil getTimeDate:date];
}

+(NSDecimalNumber*)addDuration:(NSDate*)date
{
	NSCalendar *gregorian =[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:( NSHourCalendarUnit |  NSMinuteCalendarUnit) fromDate:date];
	
	NSDecimalNumber *newDuration = (NSDecimalNumber*)[NSDecimalNumber numberWithFloat:(comps.hour*60 + comps.minute)];
	[gregorian release];
    return newDuration;
}

@end
