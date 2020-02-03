//
//  ViewController.m
//  CXDatePickerView
//
//  Created by Felix on 2018/6/26.
//  Copyright © 2018年 CXTretar. All rights reserved.
//

#import "ViewController.h"
#import "CXDatePickerView.h"

#define RGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

#define randomColor [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = @[@"年-月-日-时-分",@"月-日-时-分",@"年-月-日",@"日-时-分",@"天-时-分(00日)",@"年-月",@"月-日",@"时-分",@"指定日期2011-11-11 11:11"];
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(20, 40+50*i, self.view.frame.size.width-40, 40);
        selectBtn.tag = i;
        selectBtn.layer.cornerRadius = 5;
        selectBtn.backgroundColor = [UIColor lightGrayColor];
        [selectBtn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:selectBtn];
        [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)selectAction:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
        {
            //年-月-日-时-分
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM-dd HH:mm"];
                NSLog(@"选择的日期：%@",dateString);
                [btn setTitle:dateString forState:UIControlStateNormal];
            }];
            datepicker.dateLabelColor = [UIColor orangeColor];//年-月-日-时-分 颜色
            datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
            datepicker.headerViewColor = [UIColor orangeColor]; // 顶部视图背景颜色
            datepicker.doneButtonColor = [UIColor whiteColor]; // 确认按钮字体颜色
            datepicker.cancelButtonColor = [UIColor whiteColor]; // 取消按钮颜色
            datepicker.shadeViewAlphaWhenShow = 0.3;
            datepicker.showAnimationTime = 0.4;
            datepicker.minLimitDate = [NSDate cx_date:@"2019-12-1 12:45" WithFormat:@"yyyy-MM-dd HH:mm"];
            datepicker.maxLimitDate = [NSDate cx_date:@"2019-12-26 12:45" WithFormat:@"yyyy-MM-dd HH:mm"];
            
            [datepicker show];
        }
            break;
        case 1:
        {
            //月-日-时-分
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate cx_stringWithFormat:@"MM-dd HH:mm"];
                NSLog(@"选择的日期：%@",dateString);
                [btn setTitle:dateString forState:UIControlStateNormal];
            }];
            datepicker.dateLabelColor = [UIColor purpleColor];//年-月-日-时-分 颜色
            datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
            datepicker.doneButtonColor = [UIColor purpleColor];//确定按钮的颜色
            datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
            datepicker.cancelButtonColor = datepicker.doneButtonColor;
            [datepicker show];
            
        }
            break;
        case 2:
        {
            //年-月-日
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM-dd"];
                NSLog(@"选择的日期：%@",dateString);
                [btn setTitle:dateString forState:UIControlStateNormal];
            }];
            datepicker.dateLabelColor = randomColor;//年-月-日-时-分 颜色
            datepicker.datePickerColor = randomColor;//滚轮日期颜色
            datepicker.doneButtonColor = randomColor;//确定按钮的颜色
            datepicker.cancelButtonColor = datepicker.doneButtonColor;
            [datepicker show];
        }
            break;
        case 3:
        {
            //日-时-分
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowDayHourMinute CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate cx_stringWithFormat:@"d日 HH:mm"];
                NSLog(@"选择的日期：%@",dateString);
                [btn setTitle:dateString forState:UIControlStateNormal];
            }];
            datepicker.dateLabelColor = randomColor;//年-月-日-时-分 颜色
            datepicker.datePickerColor = randomColor;//滚轮日期颜色
            datepicker.doneButtonColor = randomColor;//确定按钮的颜色
            datepicker.cancelButtonColor = datepicker.doneButtonColor;
            [datepicker show];
        }
            break;
        case 4:
        {
            //日-时-分 (day 从 00 开始)
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithZeroDayCompleteBlock:^(NSInteger days, NSInteger hours, NSInteger minutes) {
                NSLog(@"%ld -- %ld -- %ld", (long)days, (long)hours, (long)minutes);
                NSString *dateString = [NSString stringWithFormat:@"%ld天%ld时%ld分", (long)days, (long)hours, (long)minutes];
                [btn setTitle:dateString forState:UIControlStateNormal];
            }];

            datepicker.dateLabelColor = randomColor;//年-月-日-时-分 颜色
            datepicker.datePickerColor = randomColor;//滚轮日期颜色
            datepicker.doneButtonColor = randomColor;//确定按钮的颜色
            datepicker.cancelButtonColor = datepicker.doneButtonColor;
            datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
            [datepicker show];
        }
            break;
        case 5:
        {
            //年-月
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowYearMonth CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM"];
                NSLog(@"选择的日期：%@",dateString);
                [btn setTitle:dateString forState:UIControlStateNormal];
            }];
            datepicker.datePickerFont = [UIFont systemFontOfSize:17];
            datepicker.dateLabelColor = randomColor;//年-月-日-时-分 颜色
            datepicker.datePickerColor = randomColor;//滚轮日期颜色
            datepicker.doneButtonColor = randomColor;//确定按钮的颜色
            datepicker.cancelButtonColor = datepicker.doneButtonColor;
            [datepicker show];
            
        }
            break;
        case 6:
        {
            //月-日
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowMonthDay CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate cx_stringWithFormat:@"MM-dd"];
                NSLog(@"选择的日期：%@",dateString);
                [btn setTitle:dateString forState:UIControlStateNormal];
            }];
            datepicker.dateLabelColor = randomColor;//年-月-日-时-分 颜色
            datepicker.datePickerColor = randomColor;//滚轮日期颜色
            datepicker.doneButtonColor = randomColor;//确定按钮的颜色
            datepicker.cancelButtonColor = datepicker.doneButtonColor;
            [datepicker show];
            
        }
            break;
        case 7:
        {
            //时-分
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowHourMinute CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate cx_stringWithFormat:@"HH:mm"];
                NSLog(@"选择的日期：%@",dateString);
                [btn setTitle:dateString forState:UIControlStateNormal];
            }];
            datepicker.dateLabelColor = randomColor;//年-月-日-时-分 颜色
            datepicker.datePickerColor = randomColor;//滚轮日期颜色
            datepicker.doneButtonColor = randomColor;//确定按钮的颜色
            datepicker.yearLabelColor = [UIColor cyanColor];//大号年份字体颜色
            datepicker.cancelButtonColor = [UIColor redColor];
            
            [datepicker show];
            
        }
            break;
        case 8:
        {
            //指定日期2011-11-11 11:11
            NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
            [minDateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *scrollToDate = [minDateFormater dateFromString:@"2011-11-11 11:11"];
            
            CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateStyleShowYearMonthDayHourMinute scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
                
                NSString *date = [selectDate cx_stringWithFormat:@"yyyy-MM-dd HH:mm"];
                NSLog(@"选择的日期：%@",date);
                [btn setTitle:date forState:UIControlStateNormal];
                
            }];
            datepicker.dateLabelColor = RGB(65, 188, 241);//年-月-日-时-分 颜色
            datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
            datepicker.doneButtonColor = RGB(65, 188, 241);//确定按钮的颜色

            datepicker.pickerViewHeight = 400;
            datepicker.topViewHeight = 40;
            datepicker.pickerRowHeight = 80;
            datepicker.cancelButtonFont = [UIFont systemFontOfSize:19];
            datepicker.hideSegmentedLine = YES;  //
            datepicker.hideDateNameLabel = YES;
            
            [datepicker show];
        }
            break;
            
        default:
            break;
    }
}

@end
