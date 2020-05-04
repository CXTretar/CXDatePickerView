//
//  CXDatePickerConfig.h
//  CXDatePickerView
//
//  Created by CXTretar on 2020/5/4.
//  Copyright © 2020 CXTretar. All rights reserved.
//

#ifndef CXDatePickerConfig_h
#define CXDatePickerConfig_h

#define kScreenFrame                    ([UIScreen mainScreen].bounds)
#define kScreenWidth                    (kScreenFrame.size.width)
#define kScreenHeight                   (kScreenFrame.size.height)

#define ShadeViewAlphaWhenShow          0.5
#define ShadeViewAlphaWhenHide          0
#define PickerRowHeight                 44

#define PickerHeaderHeight              44

#define PickerBackViewPointX            0
#define PickerBackViewPointYWhenHide    kScreenFrame.size.height
#define PickerBackViewPointYWhenShow    (kScreenFrame.size.height - PickerBackViewHeight)
#define PickerBackViewWeight            kScreenFrame.size.width
#define PickerBackViewHeight            (PickerHeaderHeight + PickerHeight)

#define PickerPointX                    0
#define PickerPointY                    PickerHeaderHeight
#define PickerWeight                    kScreenFrame.size.width
#define PickerHeight                    200

#define ButtonTitleColor                [UIColor colorWithHexString:@"#323232"]
#define BackViewColor                   [UIColor whiteColor]


#define RGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define RGB(r, g, b) RGBA(r,g,b,1)


#define MAXYEAR 2099
#define MINYEAR 1000

#endif /* CXDatePickerConfig_h */
