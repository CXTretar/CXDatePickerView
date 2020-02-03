//
//  NSDate+CXCategory.h
//  CXDatePickerView
//
//  Created by Felix on 2018/6/26.
//  Copyright © 2018年 CXTretar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE      60
#define D_HOUR        3600
#define D_DAY         86400
#define D_WEEK        604800
#define D_YEAR        31556926

@interface NSDate (CXCategory)

// Decomposing dates
@property (readonly) NSInteger cx_nearestHour;
@property (readonly) NSInteger cx_hour;
@property (readonly) NSInteger cx_minute;
@property (readonly) NSInteger cx_seconds;
@property (readonly) NSInteger cx_day;
@property (readonly) NSInteger cx_month;
@property (readonly) NSInteger cx_week;
@property (readonly) NSInteger cx_weekday;
@property (readonly) NSInteger cx_nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger cx_year;

// Short string utilities
- (NSString *)cx_stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
- (NSString *)cx_stringWithFormat: (NSString *) format;

- (NSDate *)cx_dateWithYMD;
- (NSDate *)cx_dateWithFormatter:(NSString *)formatter;
+ (NSDate *)cx_date:(NSString *)datestr WithFormat:(NSString *)format;

@end
