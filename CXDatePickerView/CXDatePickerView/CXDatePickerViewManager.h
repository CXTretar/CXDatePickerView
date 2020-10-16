//
//  CXDatePickerViewTool.h
//  CXDatePickerView
//
//  Created by CXTretar on 2020/4/11.
//  Copyright © 2020 CXTretar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CXDatePickerStyle.h"

@interface CXDatePickerViewManager : NSObject

@property(nonatomic, strong) NSMutableArray *yearArray;
@property(nonatomic, strong) NSMutableArray *monthArray;
@property(nonatomic, strong) NSMutableArray *dayArray;
@property(nonatomic, strong) NSMutableArray *hourArray;
@property(nonatomic, strong) NSMutableArray *minuteArray;
@property(nonatomic, strong) NSMutableArray *secondArray;

@property(nonatomic, assign) NSInteger yearIndex;
@property(nonatomic, assign) NSInteger monthIndex;
@property(nonatomic, assign) NSInteger dayIndex;
@property(nonatomic, assign) NSInteger hourIndex;
@property(nonatomic, assign) NSInteger minuteIndex;
@property(nonatomic, assign) NSInteger secondIndex;

@property(nonatomic, assign) NSInteger yearCount;
@property(nonatomic, assign) NSInteger monthCount;
@property(nonatomic, assign) NSInteger dayCount;
@property(nonatomic, assign) NSInteger hourCount;
@property(nonatomic, assign) NSInteger minuteCount;
@property(nonatomic, assign) NSInteger secondCount;

@property(nonatomic, assign) NSInteger preRow;

@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *scrollToDate;
@property(nonatomic, strong) NSDate *maxLimitDate;
@property(nonatomic, strong) NSDate *minLimitDate;

@property(nonatomic, assign) BOOL isZeroDay;

@property(nonatomic, assign) CXDatePickerStyle datePickerStyle;
@property(nonatomic, copy) NSString *dateFormatter;

@property(nonatomic, strong) UIPickerView *datePicker;
@property(nonatomic, strong) UILabel *backYearView;

@property(nonatomic, copy) NSArray *unitArray;
@property(nonatomic, copy) NSArray *indexArray;
@property(nonatomic, strong) NSDate *currentDate;

- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate;
- (void)refreshDayArray;
- (void)refreshScrollToDate;
- (void)yearChange:(NSInteger)row;
- (NSArray *)getNumberOfRowsInComponent;

@end

