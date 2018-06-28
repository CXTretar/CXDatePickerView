//
//  CXDatePickerView.m
//  CXDatePickerView
//
//  Created by Felix on 2018/6/26.
//  Copyright © 2018年 CXTretar. All rights reserved.
//

#import "CXDatePickerView.h"
#import "PickerViewParameter.h"

typedef void(^doneBlock)(NSDate *);

@interface CXDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate> {
    //日期存储数组
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;
    NSString *_dateFormatter;
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSInteger preRow;
    
    NSDate *_startDate;
    
}

@property (nonatomic, strong) UIView *buttomView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;

@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, retain) NSDate *scrollToDate;//滚到指定日期
@property (nonatomic, strong) doneBlock doneBlock;
@property (nonatomic, assign) CXDateStyle datePickerStyle;
@property (nonatomic, strong) UILabel *showYearView;
@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UIButton *cancelButton;

@end

@implementation CXDatePickerView

- (void)setHeaderViewColor:(UIColor *)headerViewColor {
    _headerViewColor = headerViewColor;
    self.headerView.backgroundColor = headerViewColor;
}

- (void)setDatePickerColor:(UIColor *)datePickerColor {
    _datePickerColor = datePickerColor;
     [self.datePicker reloadAllComponents];
}

- (void)setDatePickerFont:(UIFont *)datePickerFont {
    _datePickerFont = datePickerFont;
    [self.datePicker reloadAllComponents];
}

- (void)setYearLabelColor:(UIColor *)yearLabelColor {
    if (_hideBackgroundYearLabel) {
        return;
    }
    self.showYearView.textColor = yearLabelColor;
}

- (void)setHideBackgroundYearLabel:(BOOL)hideBackgroundYearLabel {
    _hideBackgroundYearLabel = hideBackgroundYearLabel;
    self.showYearView.textColor = [UIColor clearColor];
}

- (void)setDoneButtonTitle:(NSString *)doneButtonTitle {
    _doneButtonTitle = doneButtonTitle;
    [self.confirmButton setTitle:doneButtonTitle forState:UIControlStateNormal];
}

- (void)setDoneButtonColor:(UIColor *)doneButtonColor {
    _doneButtonColor = doneButtonColor;
    [self.confirmButton setTitleColor:doneButtonColor forState:UIControlStateNormal];
}

- (void)setDoneButtonFont:(UIFont *)doneButtonFont {
    _doneButtonFont = doneButtonFont;
    self.confirmButton.titleLabel.font = doneButtonFont;
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    _cancelButtonTitle = cancelButtonTitle;
    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
}

- (void)setCancelButtonColor:(UIColor *)cancelButtonColor {
    _cancelButtonColor = cancelButtonColor;
    [self.cancelButton setTitleColor:_cancelButtonColor forState:UIControlStateNormal];
}

- (void)setCancelButtonFont:(UIFont *)cancelButtonFont {
    _cancelButtonFont = cancelButtonFont;
    self.cancelButton.titleLabel.font = cancelButtonFont;
}

- (void)setTopViewHeight:(CGFloat)topViewHeight {
    _topViewHeight = topViewHeight;
    
    self.buttomView.frame = CGRectMake(PickerBackViewPointX,
                                       PickerBackViewPointYWhenHide,
                                       PickerBackViewWeight,
                                       _topViewHeight + _pickerViewHeight);
    
    self.headerView.frame = CGRectMake(0,
                                       0,
                                       PickerBackViewWeight,
                                       _topViewHeight);
    
    self.datePicker.frame = CGRectMake(0,
                                       _topViewHeight,
                                       PickerBackViewWeight,
                                       _pickerViewHeight);
    
    self.showYearView.frame = CGRectMake(0,
                                         _topViewHeight,
                                         PickerBackViewWeight,
                                         _pickerViewHeight);
    
    self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x,
                                         self.cancelButton.frame.origin.y,
                                         self.cancelButton.frame.size.width,
                                         _topViewHeight);
    
    self.confirmButton.frame = CGRectMake(self.confirmButton.frame.origin.x,
                                         self.confirmButton.frame.origin.y,
                                         self.confirmButton.frame.size.width,
                                         _topViewHeight);
     [self.datePicker reloadAllComponents];
}

- (void)setPickerViewHeight:(CGFloat)pickerViewHeight {
    _pickerViewHeight = pickerViewHeight;
    
    self.buttomView.frame = CGRectMake(PickerBackViewPointX,
                                       PickerBackViewPointYWhenHide,
                                       PickerBackViewWeight,
                                       _topViewHeight + _pickerViewHeight);
    self.headerView.frame = CGRectMake(0,
                                       0,
                                       PickerBackViewWeight,
                                       _topViewHeight);
    self.datePicker.frame = CGRectMake(0,
                                       _topViewHeight,
                                       PickerBackViewWeight,
                                       _pickerViewHeight);
    self.showYearView.frame = CGRectMake(0,
                                         _topViewHeight,
                                         PickerBackViewWeight,
                                         _pickerViewHeight);
    [self.datePicker reloadAllComponents];
}

- (void)setPickerRowHeight:(CGFloat)pickerRowHeight {
    _pickerRowHeight = pickerRowHeight;
    [self.datePicker reloadAllComponents];
}

- (UIPickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(PickerPointX, PickerPointY, PickerWeight, PickerHeight)];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}

- (UILabel *)showYearView {
    if (!_showYearView) {
        _showYearView = [[UILabel alloc] initWithFrame:CGRectMake(PickerPointX, PickerPointY, PickerWeight, PickerHeight)];
        _showYearView.textAlignment = NSTextAlignmentCenter;
        _showYearView.font = [UIFont systemFontOfSize:110];
        _showYearView.textColor =  RGB(228, 232, 239);
    }
    return _showYearView;
}

/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(CXDateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *date))completeBlock {
    self = [super init];
    if (self) {
        self.datePickerStyle = datePickerStyle;
        switch (datePickerStyle) {
            case CXDateStyleShowYearMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case CXDateStyleShowMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case CXDateStyleShowYearMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case CXDateStyleShowYearMonth:
                _dateFormatter = @"yyyy-MM";
                break;
            case CXDateStyleShowMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case CXDateStyleShowHourMinute:
                _dateFormatter = @"HH:mm";
                break;
                
            default:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        
        [self setupUI];
        [self defaultConfig];
        
        __weak typeof(self) weakSelf = self;
        if (completeBlock) {
            weakSelf.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

/**
 滚动到指定的的日期
 */
- (instancetype)initWithDateStyle:(CXDateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *))completeBlock {
    self = [super init];
    if (self) {
        self.datePickerStyle = datePickerStyle;
        self.scrollToDate = scrollToDate;
        switch (datePickerStyle) {
            case CXDateStyleShowYearMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case CXDateStyleShowMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case CXDateStyleShowYearMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case CXDateStyleShowYearMonth:
                _dateFormatter = @"yyyy-MM";
                break;
            case CXDateStyleShowMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case CXDateStyleShowHourMinute:
                _dateFormatter = @"HH:mm";
                break;
                
            default:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        
        [self setupUI];
        [self defaultConfig];
        __weak typeof(self) weakSelf = self;
        if (completeBlock) {
            weakSelf.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

- (void)setupUI {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    self.showAnimationTime = 0.25;
    self.shadeViewAlphaWhenShow = ShadeViewAlphaWhenShow;
    self.datePickerColor = [UIColor blackColor];
    self.datePickerFont = [UIFont systemFontOfSize:15];
    self.topViewHeight = PickerHeaderHeight;
    self.pickerRowHeight = PickerRowHeight;
    self.pickerViewHeight = PickerHeight;
    self.buttomView = [[UIView alloc] initWithFrame:CGRectMake(PickerBackViewPointX,
                                                               PickerBackViewPointYWhenHide,
                                                               PickerBackViewWeight,
                                                               PickerBackViewHeight)
                       ];
    self.buttomView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.buttomView];

    [self.buttomView addSubview:self.showYearView];
    [self.buttomView addSubview:self.datePicker];
    
    [self initPickerHeaderView];
    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    
    [self layoutIfNeeded];
    
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
}

- (void)initPickerHeaderView {
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PickerBackViewWeight, PickerHeaderHeight)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.buttomView addSubview:_headerView];
    
    CGRect cancelButtonFrame  = CGRectMake(15, 0, 60, PickerHeaderHeight);
    CGRect confirmButtonFrame = CGRectMake(PickerBackViewWeight - 60 - 15, 0, 60, PickerHeaderHeight);
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:cancelButtonFrame];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton = cancelButton;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_headerView addSubview:cancelButton];
    
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:confirmButtonFrame];
    self.confirmButton = confirmButton;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_headerView addSubview:confirmButton];
}

- (void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.showYearView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (_hideDateNameLabel) {
        return;
    }
    
    if (!_dateLabelColor) {
        _dateLabelColor =  RGB(247, 133, 51);
    }
    
    for (int i=0; i<nameArr.count; i++) {
        CGFloat labelX = PickerWeight/(nameArr.count*2)+18+PickerWeight/nameArr.count*i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, self.showYearView.frame.size.height/2-15/2.0, 15, 15)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = _dateLabelColor;
        label.backgroundColor = [UIColor clearColor];
        [label adjustsFontSizeToFitWidth];
        [self.showYearView addSubview:label];
    }
}

- (void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        _scrollToDate = self.minLimitDate;
    }
    [self getNowDate:self.scrollToDate animated:NO];
}

-(void)defaultConfig {
    
    if (!_scrollToDate) {
        _scrollToDate = [NSDate date];
    }
    //循环滚动时需要用到
    preRow = (self.scrollToDate.year- MINYEAR)*12+self.scrollToDate.month-1;
    
    //设置年月日时分数据
    _yearArray = [self setArray:_yearArray];
    _monthArray = [self setArray:_monthArray];
    _dayArray = [self setArray:_dayArray];
    _hourArray = [self setArray:_hourArray];
    _minuteArray = [self setArray:_minuteArray];
    
    for (int i=0; i<60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12)
            [_monthArray addObject:num];
        if (i<24)
            [_hourArray addObject:num];
        [_minuteArray addObject:num];
    }
    for (NSInteger i = MINYEAR; i<= MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate date:@"2099-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate date:@"1000-01-01 00:00" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
}

- (NSMutableArray *)setArray:(id)mutableArray {
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}

#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:_showAnimationTime animations:^{
        CGFloat buttomViewHeight = _pickerViewHeight + _topViewHeight;
        self.buttomView.frame = CGRectMake(0, kScreenHeight - buttomViewHeight, kScreenWidth, buttomViewHeight);
        self.backgroundColor = RGBA(0, 0, 0, _shadeViewAlphaWhenShow);
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:_showAnimationTime animations:^{
        CGFloat buttomViewHeight = _pickerViewHeight + _topViewHeight;
        self.buttomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, buttomViewHeight);
        
        self.backgroundColor = RGBA(0, 0, 0, ShadeViewAlphaWhenHide);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)confirm {
    _startDate = [self.scrollToDate dateWithFormatter:_dateFormatter];
    
    self.doneBlock(_startDate);
    NSLog(@"%@", _startDate);
    [self dismiss];
}

- (void)cancel {
    [self dismiss];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.datePickerStyle) {
        case CXDateStyleShowYearMonthDayHourMinute:
            [self addLabelWithName:@[@"年",@"月",@"日",@"时",@"分"]];
            return 5;
        case CXDateStyleShowMonthDayHourMinute:
            [self addLabelWithName:@[@"月",@"日",@"时",@"分"]];
            return 4;
        case CXDateStyleShowYearMonthDay:
            [self addLabelWithName:@[@"年",@"月",@"日"]];
            return 3;
        case CXDateStyleShowYearMonth:
           [self addLabelWithName:@[@"年",@"月"]];
            return 2;
        case CXDateStyleShowMonthDay:
            [self addLabelWithName:@[@"月",@"日"]];
            return 2;
        case CXDateStyleShowHourMinute:
            [self addLabelWithName:@[@"时",@"分"]];
            return 2;
        default:
            return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

- (NSArray *)getNumberOfRowsInComponent {
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    NSInteger dayNum = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
    NSInteger hourNum = _hourArray.count;
    NSInteger minuteNUm = _minuteArray.count;
    
    NSInteger timeInterval = MAXYEAR - MINYEAR;
    
    switch (self.datePickerStyle) {
        case CXDateStyleShowYearMonthDayHourMinute:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case CXDateStyleShowMonthDayHourMinute:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case CXDateStyleShowYearMonthDay:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
        case CXDateStyleShowYearMonth:
            return @[@(yearNum),@(monthNum)];
            break;
        case CXDateStyleShowMonthDay:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum)];
            break;
        case CXDateStyleShowHourMinute:
            return @[@(hourNum),@(minuteNUm)];
            break;
        default:
            return @[];
            break;
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return _pickerRowHeight;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    NSString *title;
    
    switch (self.datePickerStyle) {
        case CXDateStyleShowYearMonthDayHourMinute:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
            if (component==3) {
                title = _hourArray[row];
            }
            if (component==4) {
                title = _minuteArray[row];
            }
            break;
        case CXDateStyleShowYearMonthDay:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
                //                NSDate *date = [NSDate date:title WithFormat:@"MM"];
                //                NSString *string = [date stringWithFormat:@"MMMM"];
                //                title = string;
            }
            if (component==2) {
                title = _dayArray[row];
            }
            break;
        case CXDateStyleShowYearMonth:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            break;
        case CXDateStyleShowMonthDayHourMinute:
            if (component==0) {
                title = _monthArray[row%12];
//                NSDate *date = [NSDate date:title WithFormat:@"MM"];
//                NSString *string = [date stringWithFormat:@"MMMM"];
//                title = string;
            }
            if (component==1) {
                title = _dayArray[row];
            }
            if (component==2) {
                title = _hourArray[row];
            }
            if (component==3) {
                title = _minuteArray[row];
            }
            break;
        case CXDateStyleShowMonthDay:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
            break;
        case CXDateStyleShowHourMinute:
            if (component==0) {
                title = _hourArray[row];
            }
            if (component==1) {
                title = _minuteArray[row];
            }
            break;
        default:
            title = @"";
            break;
    }
    
    customLabel.text = title;
  
    customLabel.textColor = self.datePickerColor;
    customLabel.font = self.datePickerFont;
    
    if (_hideSegmentedLine) {
        ((UIView *)[self.datePicker.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
        ((UIView *)[self.datePicker.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
    }
  
    return customLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (self.datePickerStyle) {
        case CXDateStyleShowYearMonthDayHourMinute:{
            
            if (component == 0) {
                yearIndex = row;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
                
            }
        }
            break;
            
            
        case CXDateStyleShowYearMonthDay:{
            
            if (component == 0) {
                yearIndex = row;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
            
        case CXDateStyleShowYearMonth:{
            
            if (component == 0) {
                yearIndex = row;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
        }
            break;
            
            
        case CXDateStyleShowMonthDayHourMinute:{
            
            
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 2) {
                hourIndex = row;
            }
            if (component == 3) {
                minuteIndex = row;
            }
            
            if (component == 0) {
                
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
            
        }
            break;
            
        case CXDateStyleShowMonthDay:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 0) {
                
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        }
            break;
            
        case CXDateStyleShowHourMinute:{
            if (component == 0) {
                hourIndex = row;
            }
            if (component == 1) {
                minuteIndex = row;
            }
        }
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];
    
    self.scrollToDate = [[NSDate date:dateStr WithFormat:@"yyyy-MM-dd HH:mm"] dateWithFormatter:_dateFormatter];
    
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
    
    _startDate = self.scrollToDate;
    
}

- (void)yearChange:(NSInteger)row {
    
    monthIndex = row%12;
    
    //年份状态变化
    if (row-preRow <12 && row-preRow>0 && [_monthArray[monthIndex] integerValue] < [_monthArray[preRow%12] integerValue]) {
        yearIndex ++;
    } else if(preRow-row <12 && preRow-row > 0 && [_monthArray[monthIndex] integerValue] > [_monthArray[preRow%12] integerValue]) {
        yearIndex --;
    }else {
        NSInteger interval = (row-preRow)/12;
        yearIndex += interval;
    }
    
    self.showYearView.text = _yearArray[yearIndex];
    preRow = row;
}


#pragma mark - tools
//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month {
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num {
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated {
    if (!date) {
        date = [NSDate date];
    }
    
    [self DaysfromYear:date.year andMonth:date.month];
    
    yearIndex = date.year-MINYEAR;
    monthIndex = date.month-1;
    dayIndex = date.day-1;
    hourIndex = date.hour;
    minuteIndex = date.minute;
    
    //循环滚动时需要用到
    preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    
    NSArray *indexArray;
    
    if (self.datePickerStyle == CXDateStyleShowYearMonthDayHourMinute)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == CXDateStyleShowYearMonthDay)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == CXDateStyleShowYearMonth)
        indexArray = @[@(yearIndex),@(monthIndex)];
    if (self.datePickerStyle == CXDateStyleShowMonthDayHourMinute)
        indexArray = @[@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == CXDateStyleShowMonthDay)
        indexArray = @[@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == CXDateStyleShowHourMinute)
        indexArray = @[@(hourIndex),@(minuteIndex)];
    
     self.showYearView.text = _yearArray[yearIndex];
    
    [self.datePicker reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {
        if ((self.datePickerStyle == CXDateStyleShowMonthDayHourMinute || self.datePickerStyle == CXDateStyleShowMonthDay)&& i==0) {
            NSInteger mIndex = [indexArray[i] integerValue]+(12*(self.scrollToDate.year - MINYEAR));
            [self.datePicker selectRow:mIndex inComponent:i animated:animated];
        } else {
            [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
        
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isDescendantOfView:self.buttomView]) {
        return NO;
    }
    return YES;
}


@end
