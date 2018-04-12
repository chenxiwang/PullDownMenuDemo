//
//  FirstViewController.m
//  PullDownMenuProject
//
//  Created by wcx on 2018/4/3.
//  Copyright © 2018年 gupeng. All rights reserved.
//

#import "FirstViewController.h"
#import "PullDownButtonMenuView.h"
#import "Masonry.h"
#import "EventTableViewCell.h"
#import "EventModel.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PullDownButtonMenuView *monthView;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSArray *itemArray = @[@"12月",@"11月",@"10月",@"9月",@"8月",@"7月",@"6月",@"5月",@"4月",@"3月",@"2月",@"1月"];
    PullDownButtonMenuView *view = [[PullDownButtonMenuView alloc] initWithItemsArray:itemArray];
    view.SelectCurrentItemBlock = ^(NSInteger index) {
        NSLog(@"月份选择了第%ld个",(long)index);
        [self scrollToSpecialIndex:index];
    };
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(5);
        make.left.equalTo(self.view.mas_left).offset(20);
        
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    
    self.monthView = view;
    
    NSArray *yearArray = @[@"2013年度",@"2014年度",@"2015年度",@"2016年度",@"2017年度",@"2018年度"];
    PullDownButtonMenuView *view2 = [[PullDownButtonMenuView alloc] initWithItemsArray:yearArray];
    view2.SelectCurrentItemBlock = ^(NSInteger index) {
        NSLog(@"年份选择了第%ld个",(long)index);
    };
    [self.view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.left.equalTo(view.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    
     [self.view addSubview:self.theTableView];
    [self.theTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
    [self.theTableView registerNib:[UINib nibWithNibName:@"EventTableViewCell" bundle:nil] forCellReuseIdentifier:@"EventTableViewCell"];
    self.theTableView.estimatedRowHeight = 0;
    
    [self getLocalData];
}

- (void)getLocalData{
    //JSON文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"eventModel.json" ofType:nil];
    
    //加载JSON文件
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    //将JSON数据转为NSArray或NSDictionary
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray * array = dict[@"data"][@"list"];
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EventModel *model  = [EventModel new];
        model.idField = [obj[@"id"] integerValue];
        model.time = [obj[@"time"] doubleValue];
        model.eventType = obj[@"eventType"];
       // [model converFromTime:[obj[@"time"] doubleValue]];
        [self.dataArray addObject:model];
    }];
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (UITableView *)theTableView {
    if (!_theTableView) {
        _theTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
       // _theTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _theTableView.backgroundColor = [UIColor clearColor];
        _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _theTableView.delegate = self;
        _theTableView.dataSource = self;
       
    }
    return _theTableView;
}
// 0-12,1-11,2-10
- (void)scrollToSpecialIndex:(NSInteger )index{
    NSInteger currentIndex = [self getIndexPathFromIndex:index];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    
    [self.theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
// index 8 month 4
- (NSInteger )getIndexPathFromIndex:(NSInteger )index{
    NSInteger specialMonth = 12 - index;
    __block NSInteger currentIndex = 0;
    [self.dataArray enumerateObjectsUsingBlock:^(EventModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.month==specialMonth) {
            currentIndex = idx;
            *stop = YES;
        }
    }];
    
    if (specialMonth !=12 && specialMonth !=1 && currentIndex==0) {
       return  [self getIndexPathFromIndex:(index - 1)];
    }else if (specialMonth ==12 && currentIndex==0){
        return 0;
    }
    
    return currentIndex;
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//   // NSLog(@"停止滚动");
//     [self getFirstVisibleIndexPath];
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//   // NSLog(@"停止拖动");
//    [self getFirstVisibleIndexPath];
//}

- (void)getFirstVisibleIndexPath{
    NSArray *indexArray = self.theTableView.indexPathsForVisibleRows;
    NSIndexPath *indexPath = [indexArray firstObject];
    EventModel *model = self.dataArray[indexPath.row];
    NSLog(@"当前的月份是%ld",(long)model.month);
    [self.monthView setButtonTitle:[NSString stringWithFormat:@"%ld月",(long)model.month]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self getFirstVisibleIndexPath];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventTableViewCell" forIndexPath:indexPath];
    EventModel *model = self.dataArray[indexPath.row];
    NSInteger year = model.calendarData.year ?:0;
    NSInteger month = model.calendarData.month ?:0;
    [cell.happenTime setText:model.timeString];
    [cell.eventType setText:model.eventType];
    [cell.year setText:@(year).stringValue];
    [cell.month setText:@(month).stringValue];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 109;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
