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
    CXDateYearMonthDayHourMinute  = 0,//年月日时分
    CXDateMonthDayHourMinute,//月日时分
    CXDateYearMonthDay,//年月日
    CXDateDayHourMinute, //日时分
    CXDateYearMonth,//年月
    CXDateMonthDay,//月日
    CXDateHourMinute//时分
   
};

#endif /* CXDatePickerStyle_h */
