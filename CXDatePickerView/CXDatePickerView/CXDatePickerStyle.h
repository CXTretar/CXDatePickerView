//
//  CXDatePickerStyle.h
//  CXDatePickerView
//
//  Created by CXTretar on 2020/5/4.
//  Copyright © 2020 CXTretar. All rights reserved.
//

#ifndef CXDatePickerStyle_h
#define CXDatePickerStyle_h

/**
 *  弹出日期类型
 */
typedef NS_ENUM(NSUInteger, CXDatePickerStyle) {
    CXDateYearMonthDayHourMinuteSecond = 0, //年月日时分秒
    CXDateYearMonthDayHourMinute,           //年月日时分
    CXDateMonthDayHourMinute,               //月日时分
    CXDateYearMonthDay,                     //年月日
    CXDateDayHourMinute,                    //日时分
    CXDateYearMonth,                        //年月
    CXDateMonthDay,                         //月日
    CXDateHourMinuteSecond,                 //时分秒
    CXDateHourMinute                        //时分
};


/**
 *  弹出日期单位显示类型
 */
typedef NS_ENUM(NSUInteger, CXDateLabelUnitStyle) {
    CXDateLabelUnitFixed = 0,              // 添加固定位置的日期单位
    CXDateLabelTextAllUnit,                // 添加所有日期的日期单位
    CXDateLabelTextSelectUnit,             // 添加选中日期的日期单位
};

#endif /* CXDatePickerStyle_h */
