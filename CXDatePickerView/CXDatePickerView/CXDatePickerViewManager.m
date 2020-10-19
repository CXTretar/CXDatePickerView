//
//  CXDatePickerViewTool.m
//  CXDatePickerView
//
//  Created by CXTretar on 2020/4/11.
//  Copyright © 2020 CXTretar. All rights reserved.
//

#import "CXDatePickerViewManager.h"
#import "NSDate+CXCategory.h"
#import "CXDatePickerConfig.h"

@implementation CXDatePickerViewManager

- (void)setMaxLimitDate:(NSDate *)maxLimitDate {
    _maxLimitDate = maxLimitDate;
    
    if ([_scrollToDate compare:maxLimitDate] == NSOrderedDescending) {
        _scrollToDate = maxLimitDate;
    }
    [self getNowDate:_scrollToDate animated:NO];
}

- (void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    
    if ([_scrollToDate compare:minLimitDate] == NSOrderedAscending) {
        _scrollToDate = minLimitDate;
    }
    
    [self getNowDate:_scrollToDate animated:NO];
}

- (void)setDatePicker:(UIPickerView *)datePicker {
    _datePicker = datePicker;
    [self getNowDate:_scrollToDate animated:NO];
}

- (void)setBackYearView:(UILabel *)backYearView {
    _backYearView = backYearView;
    _backYearView.text = self.yearArray[self.yearIndex];
}

- (void)setDatePickerStyle:(CXDatePickerStyle)datePickerStyle {
    _datePickerStyle = datePickerStyle;
    switch (datePickerStyle) { 
        case CXDateYearMonthDayHourMinuteSecond:
            _dateFormatter = @"yyyy-MM-dd HH:mm:ss";
            _unitArray = @[@"年",@"月",@"日",@"时",@"分",@"秒"].copy;
            break;
        case CXDateYearMonthDayHourMinute:
            _dateFormatter = @"yyyy-MM-dd HH:mm";
            _unitArray = @[@"年",@"月",@"日",@"时",@"分"].copy;
            break;
        case CXDateMonthDayHourMinute:
            _dateFormatter = @"yyyy-MM-dd HH:mm";
            _unitArray = @[@"月",@"日",@"时",@"分"].copy;
            break;
        case CXDateYearMonthDay:
            _dateFormatter = @"yyyy-MM-dd";
            _unitArray = @[@"年",@"月",@"日"].copy;
            break;
        case CXDateDayHourMinute:
            _dateFormatter = @"dd HH:mm";
            if (_isZeroDay) {
                _unitArray = @[@"天",@"时",@"分"].copy;
            }else {
                _unitArray = @[@"日",@"时",@"分"].copy;
            }
            break;
        case CXDateYearMonth:
            _dateFormatter = @"yyyy-MM";
            _unitArray = @[@"年",@"月"].copy;
            break;
        case CXDateMonthDay:
            _dateFormatter = @"yyyy-MM-dd";
            _unitArray = @[@"月",@"日"].copy;
            break;
        case CXDateHourMinuteSecond:
            _dateFormatter = @"HH:mm:ss";
            _unitArray = @[@"时",@"分",@"秒"].copy;
            break;
        case CXDateHourMinute:
            _dateFormatter = @"HH:mm";
            _unitArray = @[@"时",@"分"].copy;
            break;
            
        default:
            _dateFormatter = @"yyyy-MM-dd HH:mm";
            break;
    }
}

- (NSInteger)yearCount {
    return self.yearArray.count;
}

- (NSInteger)monthCount {
    return self.monthArray.count;
}

- (NSInteger)dayCount {
    return self.dayArray.count;
}

- (NSInteger)hourCount {
    return self.hourArray.count;
}

- (NSInteger)minuteCount {
    return self.minuteArray.count;
}

- (NSInteger)secondCount {
    return self.secondArray.count;
}

- (NSArray *)indexArray {
    NSArray *indexArray = @[].copy;
    
    switch (self.datePickerStyle) {
        case CXDateYearMonthDayHourMinuteSecond:
            indexArray = @[@(self.yearIndex),@(self.monthIndex),@(self.dayIndex),@(self.hourIndex),@(self.minuteIndex),@(self.secondIndex)];
            break;
        case CXDateYearMonthDayHourMinute:
            indexArray = @[@(self.yearIndex),@(self.monthIndex),@(self.dayIndex),@(self.hourIndex),@(self.minuteIndex)];
            break;
        case CXDateMonthDayHourMinute:
            indexArray = @[@(self.monthIndex),@(self.dayIndex),@(self.hourIndex),@(self.minuteIndex)];
            break;
        case CXDateYearMonthDay:
            indexArray = @[@(self.yearIndex),@(self.monthIndex),@(self.dayIndex)];
            break;
        case CXDateDayHourMinute:
            indexArray = @[@(self.dayIndex),@(self.hourIndex),@(self.minuteIndex)];
            break;
        case CXDateYearMonth:
            indexArray = @[@(self.yearIndex),@(self.monthIndex)];
            break;
        case CXDateMonthDay:
            indexArray = @[@(self.monthIndex),@(self.dayIndex)];
            break;
        case CXDateHourMinuteSecond:
            indexArray = @[@(self.hourIndex),@(self.minuteIndex),@(self.secondIndex)];
            break;
        case CXDateHourMinute:
            indexArray = @[@(self.hourIndex),@(self.minuteIndex)];
            break;
            
        default:
            break;
    }
    return indexArray;
}

#pragma mark - 构造方法
- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate {
    if (self = [super init]) {
        self.datePickerStyle = datePickerStyle;
        self.scrollToDate = scrollToDate;
        
        if (datePickerStyle == CXDateDayHourMinute  && self.isZeroDay) {
            [self getNowDate:nil animated:YES];
        }
        [self defaultConfig];
    }
    
    return self;
}

#pragma mark - 初始化配置
- (void)defaultConfig {
    if (!_scrollToDate) {
        _scrollToDate = [NSDate date];
    }
    //循环滚动时需要用到
    self.preRow = (self.scrollToDate.cx_year - MINYEAR) * 12 + self.scrollToDate.cx_month - 1;
    //设置年月日时分数据
    
    self.yearArray = @[].mutableCopy;
    self.monthArray = @[].mutableCopy;
    self.dayArray = @[].mutableCopy;
    self.hourArray = @[].mutableCopy;
    self.minuteArray = @[].mutableCopy;
    self.secondArray = @[].mutableCopy;
    
    for (int i = 0; i < 60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0 < i && i <= 12)
            [self.monthArray addObject:num];
        if (i < 24) {
            [self.hourArray addObject:num];
        }
        [self.minuteArray addObject:num];
        [self.secondArray addObject:num];
    }
    
    for (NSInteger i = MINYEAR; i<= MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [self.yearArray addObject:num];
    }
    
    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate cx_date:@"2099-12-31 23:59:00" WithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate cx_date:@"1000-01-01 00:00:00" WithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
}

- (void)refreshDayArray {
    
    [self daysFromYear:[self.yearArray[self.yearIndex] integerValue] andMonth:[self.monthArray[self.monthIndex] integerValue]];
}

#pragma mark - 通过年月求每月天数
- (void)daysFromYear:(NSInteger)year andMonth:(NSInteger)month {
    // 判断是不是闰年
    BOOL isLeapYear = year % 4 == 0 ? (month % 100 == 0 ? (year % 400 == 0 ? YES : NO) : YES) : NO;
    
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12: {
            [self setdayArray:31];
        }
            break;
            
        case 4:
        case 6:
        case 9:
        case 11: {
            [self setdayArray:30];
        }
            break;
            
        case 2:{
            if (isLeapYear) {
                [self setdayArray:29];
            }else{
                [self setdayArray:28];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置每月的天数数组
- (void)setdayArray:(NSInteger)num {
    [self.dayArray removeAllObjects];
    for (int i = 1; i <= num; i++) {
        [self.dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    if (self.isZeroDay) {
        [self.dayArray insertObject:@"00" atIndex:0];
    }
    
}


#pragma mark - 滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated {
    if (!date && _isZeroDay) {
        date = [NSDate date];
    }
    
    [self daysFromYear:date.cx_year andMonth:date.cx_month];
    
    self.yearIndex = date.cx_year - MINYEAR;
    self.monthIndex = date.cx_month - 1;
    self.dayIndex = date.cx_day - 1;
    self.hourIndex = date.cx_hour;
    self.minuteIndex = date.cx_minute;
    self.secondIndex = date.cx_seconds;
    
    if (_isZeroDay) {
        self.dayIndex = 0;
        self.hourIndex = 0;
        self.minuteIndex = 0;
        self.secondIndex = 0;
    }
    
    //循环滚动时需要用到
    self.preRow = (self.scrollToDate.cx_year - MINYEAR) * 12 + self.scrollToDate.cx_month - 1;
    
    self.backYearView.text = self.yearArray[self.yearIndex];
    [self.datePicker reloadAllComponents];
    if (!self.datePicker.numberOfComponents) return;
    
    for (int i = 0; i < self.indexArray.count; i++) {
        if ((self.datePickerStyle == CXDateMonthDayHourMinute || self.datePickerStyle == CXDateMonthDay) && i==0) {
            NSInteger mIndex = [self.indexArray[i] integerValue] + (12 * (self.scrollToDate.cx_year - MINYEAR));
            [self.datePicker selectRow:mIndex inComponent:i animated:animated];
        } else {
            [self.datePicker selectRow:[self.indexArray[i] integerValue] inComponent:i animated:animated];
        }
    }
    
    
}

#pragma mark - 年份变化
- (void)yearChange:(NSInteger)row {
    self.monthIndex = row % 12;
    //年份状态变化
    if (row - self.preRow < 12 && row - self.preRow > 0 && [self.monthArray[self.monthIndex] integerValue] < [self.monthArray[self.preRow % 12] integerValue]) {
        self.yearIndex ++;
    } else if(self.preRow - row < 12 && self.preRow - row > 0 && [self.monthArray[self.monthIndex] integerValue] > [self.monthArray[self.preRow % 12] integerValue]) {
        self.yearIndex --;
    }else {
        NSInteger interval = (row - self.preRow)/12;
        self.yearIndex += interval;
    }
    
    self.backYearView.text = self.yearArray[self.yearIndex];
    self.preRow = row;
}


#pragma mark - 假如超出设定范围复位
- (void)refreshScrollToDate {
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",self.yearArray[self.yearIndex],self.monthArray[self.monthIndex],self.dayArray[self.dayIndex],self.hourArray[self.hourIndex],self.minuteArray[self.minuteIndex],self.secondArray[self.secondIndex]];
    
    self.scrollToDate = [[NSDate cx_date:dateStr WithFormat:@"yyyy-MM-dd HH:mm:ss"] cx_dateWithFormatter:self.dateFormatter];
    
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
}

#pragma mark - 返回多少列
- (NSArray *)getNumberOfRowsInComponent {
    NSInteger timeInterval = MAXYEAR - MINYEAR;
    [self refreshDayArray];
    
    switch (self.datePickerStyle) {
        case CXDateYearMonthDayHourMinuteSecond:
            return @[@(self.yearCount),@(self.monthCount),@(self.dayCount),@(self.hourCount),@(self.minuteCount),@(self.secondCount)];
            break;
        case CXDateYearMonthDayHourMinute:
            return @[@(self.yearCount),@(self.monthCount),@(self.dayCount),@(self.hourCount),@(self.minuteCount)];
            break;
        case CXDateMonthDayHourMinute:
            return @[@(self.monthCount * timeInterval),@(self.dayCount),@(self.hourCount),@(self.minuteCount)];
            break;
        case CXDateYearMonthDay:
            return @[@(self.yearCount),@(self.monthCount),@(self.dayCount)];
            break;
        case CXDateDayHourMinute:
            return @[@(self.dayCount),@(self.hourCount),@(self.minuteCount)];
            break;
        case CXDateYearMonth:
            return @[@(self.yearCount),@(self.monthCount)];
            break;
        case CXDateMonthDay:
            return @[@(self.monthCount * timeInterval),@(self.dayCount)];
            break;
        case CXDateHourMinuteSecond:
            return @[@(self.hourCount),@(self.minuteCount),@(self.secondCount)];
            break;
        case CXDateHourMinute:
            return @[@(self.hourCount),@(self.minuteCount)];
            break;
        default:
            return @[];
            break;
    }
}

@end
