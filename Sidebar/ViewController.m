//
//  ViewController.m
//  Sidebar
//
//  Created by 侯云祥 on 2017/3/21.
//  Copyright © 2017年 今晚打老虎. All rights reserved.
//

#import "ViewController.h"
#import "HYXSideBar.h"
#import "SidebarCell.h"
#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,HYXSideBarDelegate>
/** 主屏幕的tableview   */
@property (nonatomic , strong) UITableView *mainTab;
/** 数据   */
@property (nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation ViewController
#pragma mark     ------  懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        //创建一个属性
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}
#pragma mark     ------  生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setDataInArray];
    [self setTableView];
    [self setbutton];
}
#pragma mark     ------  数据页面的设置
- (void)setDataInArray
{
    for (int i = 0; i < 30; i ++) {
        NSString *string = [NSString stringWithFormat:@"长江%d号",i];
        [self.dataArray addObject:string];
    }
}
- (void)setbutton
{
    UIButton *bu = [[UIButton alloc] init];
    bu.frame = CGRectMake(0, screenH / 2, 50, 50);
    bu.backgroundColor = [UIColor redColor];
    [bu addTarget:self action:@selector(callSidebar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu];
}
- (void)callSidebar
{
    HYXSideBar *hyxsidebar = [[HYXSideBar alloc] init];
    hyxsidebar.delegate = self;
    hyxsidebar.dataArray = self.dataArray;
    [hyxsidebar callSideBarIn:self];
}
- (void)setTableView
{
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    [self.view addSubview:self.mainTab];
}
#pragma mark     ------  代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark     ------  sidebar代理方法
- (NSInteger)numberOfSectionsInSideBar:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (UIView *)SideBar:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SidebarCell *header = [[SidebarCell alloc] init];
    header.title = self.dataArray[section];
    return header;
}
- (CGFloat)SideBar:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (void)SideBar:(UITableView *)tableView didSelectHeaderAtIndex:(NSInteger)index
{
   UIView *view = [tableView headerViewForSection:index];

    [tableView reloadData];
}
@end
