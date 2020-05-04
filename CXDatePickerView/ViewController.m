//
//  ViewController.m
//  CXDatePickerView
//
//  Created by Felix on 2018/6/26.
//  Copyright © 2018年 CXTretar. All rights reserved.
//

#import "ViewController.h"
#import "CXDatePickerView.h"
#import "NSDate+CXCategory.h"

#define RGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@interface CXExample : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SEL selector;

@end


@implementation CXExample

+ (instancetype)exampleWithTitle:(NSString *)title selector:(SEL)selector {
    ;
    CXExample *example = [[self class] new];
    example.title = title;
    example.selector = selector;
    return example;
}

@end


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<CXExample *> *examples;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSDate *selectDate;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.examples = @[
        [CXExample exampleWithTitle:@"年-月-日-时-分" selector:@selector(showYearMonthDayHourMinute:)],
        [CXExample exampleWithTitle:@"月-日-时-分" selector:@selector(showMonthDayHourMinute:)],
        [CXExample exampleWithTitle:@"年-月-日" selector:@selector(showYearMonthDay:)],
        [CXExample exampleWithTitle:@"日-时-分" selector:@selector(showDayHourMinute:)],
        [CXExample exampleWithTitle:@"天-时-分(00日)" selector:@selector(showZeroDayHourMinute:)],
        [CXExample exampleWithTitle:@"年-月" selector:@selector(showYearMonth:)],
        [CXExample exampleWithTitle:@"月-日" selector:@selector(showMonthDay:)],
        [CXExample exampleWithTitle:@"时-分" selector:@selector(showHourMinute:)],
        [CXExample exampleWithTitle:@"指定日期2011-11-11 11:11" selector:@selector(showScrollToDate:)],
    ];
    
    //指定日期2011-11-11 11:11
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.selectDate = [dateFormater dateFromString:@"2011-11-11 11:11"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"CXExampleCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - 年-月-日-时-分
- (void)showYearMonthDayHourMinute:(NSIndexPath *)indexPath {
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM-dd HH:mm"];
        NSLog(@"选择的日期：%@",dateString);
        self.examples[indexPath.row].title = dateString;
        [self.tableView reloadData];
    }];
    datepicker.dateLabelColor = [UIColor orangeColor];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.headerViewColor = [UIColor orangeColor]; // 顶部视图背景颜色
    datepicker.doneButtonColor = [UIColor whiteColor]; // 确认按钮字体颜色
    datepicker.cancelButtonColor = [UIColor whiteColor]; // 取消按钮颜色
    datepicker.shadeViewAlphaWhenShow = 0.25;
    datepicker.minLimitDate = [NSDate cx_date:@"2019-12-1 12:45" WithFormat:@"yyyy-MM-dd HH:mm"];
    datepicker.maxLimitDate = [NSDate cx_date:@"2019-12-26 12:45" WithFormat:@"yyyy-MM-dd HH:mm"];
    [datepicker show];
}

#pragma mark - 月-日-时-分
- (void)showMonthDayHourMinute:(NSIndexPath *)indexPath {
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate cx_stringWithFormat:@"MM-dd HH:mm"];
        NSLog(@"选择的日期：%@",dateString);
        self.examples[indexPath.row].title = dateString;
        [self.tableView reloadData];
    }];
    datepicker.dateLabelColor = [UIColor purpleColor];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor purpleColor];//确定按钮的颜色
    datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
    datepicker.cancelButtonColor = datepicker.doneButtonColor;
    [datepicker show];
}

#pragma mark - 年-月-日
- (void)showYearMonthDay:(NSIndexPath *)indexPath {
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"选择的日期：%@",dateString);
        self.examples[indexPath.row].title = dateString;
        [self.tableView reloadData];
    }];
    datepicker.dateLabelColor = RandomColor;//年-月-日-时-分 颜色
    datepicker.datePickerColor = RandomColor;//滚轮日期颜色
    datepicker.doneButtonColor = RandomColor;//确定按钮的颜色
    datepicker.cancelButtonColor = datepicker.doneButtonColor;
    [datepicker show];
}

#pragma mark - 日-时-分
- (void)showDayHourMinute:(NSIndexPath *)indexPath {
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate cx_stringWithFormat:@"d日 HH:mm"];
        NSLog(@"选择的日期：%@",dateString);
        self.examples[indexPath.row].title = dateString;
        [self.tableView reloadData];
    }];
    datepicker.dateLabelColor = RandomColor;//年-月-日-时-分 颜色
    datepicker.datePickerColor = RandomColor;//滚轮日期颜色
    datepicker.doneButtonColor = RandomColor;//确定按钮的颜色
    datepicker.cancelButtonColor = datepicker.doneButtonColor;
    [datepicker show];
}

#pragma mark - 天-时-分
- (void)showZeroDayHourMinute:(NSIndexPath *)indexPath {
    //日-时-分 (day 从 00 开始)
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithZeroDayCompleteBlock:^(NSInteger days, NSInteger hours, NSInteger minutes) {
        NSLog(@"%ld -- %ld -- %ld", (long)days, (long)hours, (long)minutes);
        NSString *dateString = [NSString stringWithFormat:@"%ld天%ld时%ld分", (long)days, (long)hours, (long)minutes];
        self.examples[indexPath.row].title = dateString;
        [self.tableView reloadData];
    }];
    
    datepicker.dateLabelColor = RandomColor;//年-月-日-时-分 颜色
    datepicker.datePickerColor = RandomColor;//滚轮日期颜色
    datepicker.doneButtonColor = RandomColor;//确定按钮的颜色
    datepicker.cancelButtonColor = datepicker.doneButtonColor;
    datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
    [datepicker show];
}

#pragma mark - 年-月
- (void)showYearMonth:(NSIndexPath *)indexPath {
    //年-月
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateYearMonth CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM"];
        self.examples[indexPath.row].title = dateString;
        [self.tableView reloadData];
    }];
    datepicker.datePickerFont = [UIFont systemFontOfSize:17];
    datepicker.dateLabelColor = RandomColor;//年-月-日-时-分 颜色
    datepicker.datePickerColor = RandomColor;//滚轮日期颜色
    datepicker.doneButtonColor = RandomColor;//确定按钮的颜色
    datepicker.cancelButtonColor = datepicker.doneButtonColor;
    [datepicker show];
}

#pragma mark - 月-日
- (void)showMonthDay:(NSIndexPath *)indexPath {
    //月-日
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateMonthDay CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate cx_stringWithFormat:@"MM-dd"];
        self.examples[indexPath.row].title = dateString;
        [self.tableView reloadData];
    }];
    datepicker.dateLabelColor = RandomColor;//年-月-日-时-分 颜色
    datepicker.datePickerColor = RandomColor;//滚轮日期颜色
    datepicker.doneButtonColor = RandomColor;//确定按钮的颜色
    datepicker.cancelButtonColor = datepicker.doneButtonColor;
    [datepicker show];
}

#pragma mark - 时-分
- (void)showHourMinute:(NSIndexPath *)indexPath {
    //时-分
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateHourMinute CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate cx_stringWithFormat:@"HH:mm"];
        NSLog(@"选择的日期：%@",dateString);
        self.examples[indexPath.row].title = dateString;
        [self.tableView reloadData];
    }];
    datepicker.dateLabelColor = RandomColor;//年-月-日-时-分 颜色
    datepicker.datePickerColor = RandomColor;//滚轮日期颜色
    datepicker.doneButtonColor = RandomColor;//确定按钮的颜色
    datepicker.yearLabelColor = [UIColor cyanColor];//大号年份字体颜色
    datepicker.cancelButtonColor = [UIColor redColor];
    
    [datepicker show];
}

#pragma mark - 指定日期
- (void)showScrollToDate:(NSIndexPath *)indexPath {
    
    CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:CXDateYearMonthDayHourMinute scrollToDate:self.selectDate CompleteBlock:^(NSDate *selectDate) {
        self.selectDate = selectDate;
        NSString *dateString = [selectDate cx_stringWithFormat:@"yyyy-MM-dd HH:mm"];
        NSLog(@"选择的日期：%@",dateString);
        self.examples[indexPath.row].title = dateString;
        [self.tableView reloadData];
        
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
    datepicker.hideBackgroundYearLabel = YES;
    [datepicker show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.examples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXExample *example = self.examples[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CXExampleCell" forIndexPath:indexPath];
    cell.textLabel.text = example.title;
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [cell.textLabel.textColor colorWithAlphaComponent:0.1f];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CXExample *example = self.examples[indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:example.selector withObject:indexPath];
#pragma clang diagnostic pop
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}


@end
