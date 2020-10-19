# CXDatePickerView

<div>
<img src="https://github.com/CXTretar/CXDatePickerView/blob/master/screenshots/version_0.2.5.1.png" hspace="20" width = "414" height = "896" alt="" align=center />
<img src="https://github.com/CXTretar/CXDatePickerView/blob/master/screenshots/version_0.2.5.2.png" hspace="20" width = "414" height = "896" alt="" align=center />
</div>

# Update【更新】
version: 0.2.5
- 修复iOS 14 闪退Bug。
- 增加了选中日期的字体和颜色自定义功能。
- 增加了日期单位的三种显示风格。
- 修复了日期单位文本的字体和颜色自定义功能。

# Install【安装】
在Podfile文件中添加` pod 'CXDatePickerView', '~> 0.2.2'`，并运行 `pod install`
# Usage【使用】
* import【导入框架】
`#import "CXDatePickerView.h"`

* init【创建选择器】
```
/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle completeBlock:(void(^)(NSDate *date))completeBlock;


/**
 滚动到指定的的日期
 */
- (instancetype)initWithDateStyle:(CXDatePickerStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate completeBlock:(void(^)(NSDate *date))completeBlock;


/**
  定制天时分选择器
 */
- (instancetype)initWithZeroDayCompleteBlock:(void(^)(NSInteger days,NSInteger hours,NSInteger minutes))completeBlock;
```
* style【选择器样式】

```  
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

```
* custom【自定义属性】
```
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

```
* example【示例】 
```
#pragma mark - 年-月-日-时-分-秒
- (void)showYearMonthDayHourMinuteSecond:(NSIndexPath *)indexPath {
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateYearMonthDayHourMinuteSecond completeBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLog(@"选择的日期：%@",dateString);
        self.examples[indexPath.row].title = dateString;
        [self.tableView reloadData];
    }];
    datepicker.dateUnitLabelColor = [UIColor orangeColor];//年-月-日-时-分-秒 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.headerViewColor = [UIColor orangeColor]; // 顶部视图背景颜色
    datepicker.doneButtonColor = [UIColor whiteColor]; // 确认按钮字体颜色
    datepicker.cancelButtonColor = [UIColor whiteColor]; // 取消按钮颜色
    datepicker.shadeViewAlphaWhenShow = 0.25;
    datepicker.headerTitle = @"选择日期";
    datepicker.headerTitleColor = [UIColor whiteColor];
    datepicker.minLimitDate = [NSDate cx_date:@"2019-12-1 12:45:00" WithFormat:@"yyyy-MM-dd HH:mm:ss"];
    datepicker.maxLimitDate = [NSDate cx_date:@"2022-12-26 12:45:00" WithFormat:@"yyyy-MM-dd HH:mm:ss"];
    datepicker.datePickerSelectColor = [UIColor orangeColor];
    datepicker.datePickerSelectFont = [UIFont systemFontOfSize:17];
    [datepicker show];
}

```
