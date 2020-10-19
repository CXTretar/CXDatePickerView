//
//  CXDatePickerView.h
//  CXDatePickerView
//
//  Created by Felix on 2018/6/26.
//  Copyright © 2018年 CXTretar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXDatePickerStyle.h"

@interface CXDatePickerView : UIView
/**
 *  日期单位样式
 */
@property (nonatomic, assign) CXDateLabelUnitStyle dateLabelUnitStyle; // 默认0.25

/**
 *  弹出动画时间
 */
@property (nonatomic, assign) CGFloat showAnimationTime; // 默认0.25

/**
 *  展示时背景透明度
 */
@property (nonatomic, assign) CGFloat shadeViewAlphaWhenShow; //默认0.5

/**
 *  头部视图背景颜色
 */
@property (nonatomic, strong) UIColor *headerViewColor; // 默认白色
/**
 *  头部标题颜色
 */
@property (nonatomic, strong) UIColor *headerTitleColor;
/**
 *  头部标题文字
 */
@property (nonatomic, copy) NSString *headerTitle;
/**
 *  头部标题字体
 */
@property (nonatomic, strong) UIFont *headerTitleFont;
/**
 *  确定按钮颜色
 */
@property (nonatomic, strong) UIColor *doneButtonColor;
/**
 *  确定按钮文字
 */
@property (nonatomic, copy) NSString *doneButtonTitle;
/**
 *  确定按钮字体
 */
@property (nonatomic, strong) UIFont *doneButtonFont;
/**
 *  取消按钮颜色
 */
@property (nonatomic, strong) UIColor *cancelButtonColor;
/**
 *  取消按钮文字
 */
@property (nonatomic, copy) NSString *cancelButtonTitle;
/**
 *  取消按钮字体
 */
@property (nonatomic, strong) UIFont *cancelButtonFont;

/**
 *  年-月-日-时-分 单位文字颜色(默认橙色)
 */
@property (nonatomic, strong) UIColor *dateUnitLabelColor;
/**
 *  年-月-日-时-分 单位文字字体(默认 [UIFont systemFontOfSize:15])
 */
@property (nonatomic, strong) UIFont *dateUnitLabelFont;
/**
 *  滚轮日期选中颜色(默认橙色)
 */
@property (nonatomic, strong) UIColor *datePickerSelectColor;
/**
 *  滚轮日期选中字体
 */
@property (nonatomic, strong) UIFont *datePickerSelectFont;
/**
 *  滚轮日期颜色(默认黑色)
 */
@property (nonatomic, strong) UIColor *datePickerColor;
/**
 *  滚轮日期字体
 */
@property (nonatomic, strong) UIFont *datePickerFont;
/**
 *  限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
 */
@property (nonatomic, strong) NSDate *maxLimitDate;
/**
 *  限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 */
@property (nonatomic, strong) NSDate *minLimitDate;

/**
 *  大号年份字体颜色(默认灰色)想隐藏可以设置为clearColor
 */
@property (nonatomic, strong) UIColor *yearLabelColor;

/**
 *  隐藏每行年月日文字
 */
@property (nonatomic, assign) BOOL hideDateNameLabel;

/**
 *  隐藏每行分割线
 */
@property (nonatomic, assign) BOOL hideSegmentedLine;

/**
 *  隐藏背景年份文字
 */
@property (nonatomic, assign) BOOL hideBackgroundYearLabel;

/**
 *  头部按钮视图高度
 */
@property (nonatomic, assign) CGFloat topViewHeight; // 默认44

/**
 *  选择器部分视图高度
 */
@property (nonatomic, assign) CGFloat pickerViewHeight; // 默认200


/**
 *  选择器每行高度
 */
@property (nonatomic, assign) CGFloat pickerRowHeight; // 默认44

/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle completeBlock:(void(^)(NSDate *date))completeBlock;


/**
 滚动到指定的的日期
 */
- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate completeBlock:(void(^)(NSDate *date))completeBlock;


/**
  定制日时分选择器
 */
- (instancetype)initWithZeroDayCompleteBlock:(void(^)(NSInteger days,NSInteger hours,NSInteger minutes))completeBlock;


- (void)show;


@end
