//
//  CXDatePickerView.m
//  CXDatePickerView
//
//  Created by Felix on 2018/6/26.
//  Copyright © 2018年 CXTretar. All rights reserved.
//

#import "CXDatePickerView.h"
#import "CXDatePickerConfig.h"
#import "CXDatePickerViewManager.h"
#import "NSDate+CXCategory.h"

typedef void(^doneBlock)(NSDate *);
typedef void(^doneZeroDayBlock)(NSInteger days,NSInteger hours,NSInteger minutes);

@interface CXDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *buttomView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, copy) doneBlock doneBlock;
@property (nonatomic, copy) doneZeroDayBlock doneZeroDayBlock;
@property (nonatomic, strong) UILabel *backYearView;
@property (nonatomic, weak) UILabel *headerTitleLabel;
@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UIButton *cancelButton;

@property(nonatomic, strong) CXDatePickerViewManager *manager;

@end

@implementation CXDatePickerView

- (void)setMaxLimitDate:(NSDate *)maxLimitDate {
    _maxLimitDate = maxLimitDate;
    self.manager.maxLimitDate = maxLimitDate;
}

- (void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    self.manager.minLimitDate = minLimitDate;
}

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
    self.backYearView.textColor = yearLabelColor;
}

- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    self.headerTitleLabel.text = headerTitle;
}

- (void)setHeaderTitleFont:(UIFont *)headerTitleFont {
    _headerTitleFont = headerTitleFont;
    self.headerTitleLabel.font = headerTitleFont;
}

- (void)setHeaderTitleColor:(UIColor *)headerTitleColor {
    _headerTitleColor = headerTitleColor;
    self.headerTitleLabel.textColor = headerTitleColor;
}

- (void)setHideBackgroundYearLabel:(BOOL)hideBackgroundYearLabel {
    _hideBackgroundYearLabel = hideBackgroundYearLabel;
    self.backYearView.textColor = [UIColor clearColor];
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
    
    self.backYearView.frame = CGRectMake(0,
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
    self.backYearView.frame = CGRectMake(0,
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

- (UILabel *)backYearView {
    if (!_backYearView) {
        _backYearView = [[UILabel alloc] initWithFrame:CGRectMake(PickerPointX, PickerPointY, PickerWeight, PickerHeight)];
        _backYearView.textAlignment = NSTextAlignmentCenter;
        _backYearView.font = [UIFont systemFontOfSize:110];
        _backYearView.textColor =  RGB(228, 232, 239);
    }
    return _backYearView;
}


#pragma mark - 默认滚动到当前时间
- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *date))completeBlock {
    if (self = [super init]) {
        self.manager = [[CXDatePickerViewManager alloc] initWithDateStyle:datePickerStyle scrollToDate:nil];
        [self setupUI];
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

#pragma mark - 滚动到指定的的日期
- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *))completeBlock {
    if (self = [super init]) {
        
        self.manager = [[CXDatePickerViewManager alloc] initWithDateStyle:datePickerStyle scrollToDate:scrollToDate];
        [self setupUI];
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

#pragma mark - 天-时-分
- (instancetype)initWithZeroDayCompleteBlock:(void(^)(NSInteger days,NSInteger hours,NSInteger minutes))completeBlock {
    if (self = [super init]) {
        self.manager = [[CXDatePickerViewManager alloc] initWithDateStyle:CXDateDayHourMinute scrollToDate:nil];
        self.manager.isZeroDay = YES;
        [self setupUI];
        if (completeBlock) {
            self.doneZeroDayBlock = ^(NSInteger days, NSInteger hours, NSInteger minutes) {
                completeBlock(days,hours,minutes);
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
    
    [self.buttomView addSubview:self.backYearView];
    [self.buttomView addSubview:self.datePicker];
    
    self.manager.datePicker = self.datePicker;
    self.manager.backYearView = self.backYearView;
    
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 70 * 2, PickerHeaderHeight)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = self.headerView.center;
    self.headerTitleLabel = titleLabel;
    [_headerView addSubview:titleLabel];
    
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
    for (id subView in self.backYearView.subviews) {
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
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, self.backYearView.frame.size.height/2-15/2.0, 15, 15)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = _dateLabelColor;
        label.backgroundColor = [UIColor clearColor];
        [label adjustsFontSizeToFitWidth];
        [self.backYearView addSubview:label];
    }
}


#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:self.showAnimationTime animations:^{
        CGFloat buttomViewHeight = self.pickerViewHeight + self.topViewHeight;
        self.buttomView.frame = CGRectMake(0, kScreenHeight - buttomViewHeight, kScreenWidth, buttomViewHeight);
        self.backgroundColor = RGBA(0, 0, 0, self.shadeViewAlphaWhenShow);
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:self.showAnimationTime animations:^{
        CGFloat buttomViewHeight = self.pickerViewHeight + self.topViewHeight;
        self.buttomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, buttomViewHeight);
        
        self.backgroundColor = RGBA(0, 0, 0, ShadeViewAlphaWhenHide);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)confirm {
    NSDate *date = [self.manager.scrollToDate cx_dateWithFormatter:self.manager.dateFormatter];
    if (self.doneZeroDayBlock) {
        self.doneZeroDayBlock(self.manager.dayIndex, self.manager.hourIndex, self.manager.minuteIndex);
    }
    if (self.doneBlock) {
        self.doneBlock(date);
    }
    [self dismiss];
}

- (void)cancel {
    [self dismiss];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [self addLabelWithName:self.manager.unitArray];
    return self.manager.unitArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self.manager getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
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
    
    switch (self.manager.datePickerStyle) {
        case CXDateYearMonthDayHourMinuteSecond:
            if (component == 0) {
                title = self.manager.yearArray[row];
            }
            if (component == 1) {
                title = self.manager.monthArray[row];
            }
            if (component == 2) {
                title = self.manager.dayArray[row];
            }
            if (component == 3) {
                title = self.manager.hourArray[row];
            }
            if (component == 4) {
                title =  self.manager.minuteArray[row];
            }
            if (component == 5) {
                title =  self.manager.secondArray[row];
            }
            break;
        case CXDateYearMonthDayHourMinute:
            if (component == 0) {
                title = self.manager.yearArray[row];
            }
            if (component == 1) {
                title = self.manager.monthArray[row];
            }
            if (component == 2) {
                title = self.manager.dayArray[row];
            }
            if (component == 3) {
                title = self.manager.hourArray[row];
            }
            if (component == 4) {
                title =  self.manager.minuteArray[row];
            }
            break;
        case CXDateYearMonthDay:
            if (component==0) {
                title = self.manager.yearArray[row];
            }
            if (component==1) {
                title =  self.manager.monthArray[row];
            }
            if (component==2) {
                title =  self.manager.dayArray[row];
            }
            break;
        case CXDateDayHourMinute:
            if (component==0) {
                title = self.manager.dayArray[row];
            }
            if (component==1) {
                title = self.manager.hourArray[row];
            }
            if (component==2) {
                title = self.manager.minuteArray[row];
            }
            break;
        case CXDateYearMonth:
            
            if (component==0) {
                title =  self.manager.yearArray[row];
            }
            if (component==1) {
                title = self.manager.monthArray[row];
            }
            break;
        case CXDateMonthDayHourMinute:
            if (component==0) {
                title = self.manager.monthArray[row % 12];
            }
            if (component==1) {
                title = self.manager.dayArray[row];
            }
            if (component==2) {
                title = self.manager.hourArray[row];
            }
            if (component==3) {
                title = self.manager.minuteArray[row];
            }
            break;
        case CXDateMonthDay:
            if (component==0) {
                title = self.manager.monthArray[row%12];
            }
            if (component==1) {
                title = self.manager.dayArray[row];
            }
            break;
        case CXDateHourMinuteSecond:
            if (component==0) {
                title = self.manager.hourArray[row];
            }
            if (component==1) {
                title = self.manager.minuteArray[row];
            }
            if (component==2) {
                title = self.manager.secondArray[row];
            }
            break;
        case CXDateHourMinute:
            if (component==0) {
                title = self.manager.hourArray[row];
            }
            if (component==1) {
                title = self.manager.minuteArray[row];
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
    switch (self.manager.datePickerStyle) {
        case CXDateYearMonthDayHourMinuteSecond:{
            if (component == 0) {
                self.manager.yearIndex = row;
                self.backYearView.text = self.manager.yearArray[row];
            }
            if (component == 1) {
                self.manager.monthIndex = row;
            }
            if (component == 2) {
                self.manager.dayIndex = row;
            }
            if (component == 3) {
                self.manager.hourIndex = row;
            }
            if (component == 4) {
                self.manager.minuteIndex = row;
            }
            if (component == 5) {
                self.manager.secondIndex = row;
            }
            if (component == 0 || component == 1){
                [self.manager refreshDayArray];
                if (self.manager.dayArray.count - 1 < self.manager.dayIndex) {
                    self.manager.dayIndex = self.manager.dayArray.count - 1;
                }
                
            }
        }
            break;
        case CXDateYearMonthDayHourMinute:{
            if (component == 0) {
                self.manager.yearIndex = row;
                self.backYearView.text = self.manager.yearArray[row];
            }
            if (component == 1) {
                self.manager.monthIndex = row;
            }
            if (component == 2) {
                self.manager.dayIndex = row;
            }
            if (component == 3) {
                self.manager.hourIndex = row;
            }
            if (component == 4) {
                self.manager.minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self.manager refreshDayArray];
                if (self.manager.dayArray.count - 1 < self.manager.dayIndex) {
                    self.manager.dayIndex = self.manager.dayArray.count - 1;
                }
                
            }
        }
            break;
        case CXDateYearMonthDay:{
            
            if (component == 0) {
                self.manager.yearIndex = row;
                self.backYearView.text = self.manager.yearArray[row];
            }
            if (component == 1) {
                self.manager.monthIndex = row;
            }
            if (component == 2) {
                self.manager.dayIndex = row;
            }
            if (component == 0 || component == 1){
                
                [self.manager refreshDayArray];
                if (self.manager.dayArray.count - 1 < self.manager.dayIndex) {
                    self.manager.dayIndex = self.manager.dayArray.count - 1;
                }
            }
        }
            break;
            
        case CXDateDayHourMinute:{
            
            if (component == 0) {
                self.manager.dayIndex = row;
            }
            if (component == 1) {
                self.manager.hourIndex = row;
            }
            if (component == 2) {
                self.manager.minuteIndex = row;
            }
        }
            break;
            
        case CXDateYearMonth:{
            
            if (component == 0) {
                self.manager.yearIndex = row;
                self.backYearView.text = self.manager.yearArray[row];
            }
            if (component == 1) {
                self.manager.monthIndex = row;
            }
            [self.manager refreshDayArray];
            if (self.manager.dayArray.count-1<self.manager.dayIndex) {
                self.manager.dayIndex = self.manager.dayArray.count - 1;
            }
        }
            
            break;
            
            
        case CXDateMonthDayHourMinute:{
            
            if (component == 1) {
                self.manager.dayIndex = row;
            }
            if (component == 2) {
                self.manager.hourIndex = row;
            }
            if (component == 3) {
                self.manager.minuteIndex = row;
            }
            
            if (component == 0) {
                
                [self.manager yearChange:row];
                [self.manager refreshDayArray];
                if (self.manager.dayCount - 1 < self.manager.dayIndex) {
                    self.manager.dayIndex = self.manager.dayArray.count - 1;
                }
            }
            [self.manager refreshDayArray];
            
        }
            break;
            
        case CXDateMonthDay:{
            if (component == 1) {
                self.manager.dayIndex = row;
            }
            if (component == 0) {
                [self.manager yearChange:row];
                [self.manager refreshDayArray];
                if (self.manager.dayCount - 1 < self.manager.dayIndex) {
                    self.manager.dayIndex = self.manager.dayArray.count-1;
                }
            }
            [self.manager refreshDayArray];
        }
            break;
            
        case CXDateHourMinuteSecond:{
            if (component == 0) {
                self.manager.hourIndex = row;
            }
            if (component == 1) {
                self.manager.minuteIndex = row;
            }
            if (component == 1) {
                self.manager.secondIndex = row;
            }
        }
            break;
            
        case CXDateHourMinute:{
            if (component == 0) {
                self.manager.hourIndex = row;
            }
            if (component == 1) {
                self.manager.minuteIndex = row;
            }
        }
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    [self.manager  refreshScrollToDate];
    
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isDescendantOfView:self.buttomView]) {
        return NO;
    }
    return YES;
}


@end
