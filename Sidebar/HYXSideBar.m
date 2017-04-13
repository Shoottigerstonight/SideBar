//
//  HYXSideBar.m
//  Sidebar
//
//  Created by 侯云祥 on 2017/3/21.
//  Copyright © 2017年 今晚打老虎. All rights reserved.
//

#import "HYXSideBar.h"
#import "SidebarCell.h"
#import "SideBarHeaderView.h"

#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
#define sideBarW 200
#define navHeight 44
#define MAKEHEADERVIEW @"makeHeaderView"
#define ADDHEADERVIEWACTION @"addheaderViewAction"
@interface HYXSideBar ()<UITableViewDelegate>

/** sideTableview   */
@property (nonatomic ,strong) UITableView *sideTableview;
/** 目标控制器   */
@property (nonatomic ,strong) UIViewController *targetVC;
/** 蒙板视图   */
@property (nonatomic ,strong) UIView *maskView;
/** 导航栏   */
@property (nonatomic ,strong) UIView *navView;
/** 点击的tableview   */
@property (nonatomic ,weak) UITableView *clickTableview;
/** 点击的第几行section   */
@property (nonatomic , assign) NSInteger clickSection;
/** 存放所有点击方法的数组   */
@property (nonatomic ,strong) NSMutableArray *tapArray;
@end

@implementation HYXSideBar

- (instancetype)init
{
    if (self = [super init]) {
//        更改view的frame
        CGRect frame = CGRectMake(0, 0, sideBarW, screenH);
        self.frame = frame;
//        创建蒙板手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackAndDismiss)];
//        添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeHeaderView:) name:MAKEHEADERVIEW object:nil];
//        创建蒙板
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH)];
        self.maskView.userInteractionEnabled = YES;
        self.maskView.backgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.6];
        [self.maskView addGestureRecognizer:tap];
//        创建nav视图
        UIView *navView = [[UIView alloc] init];
        navView.backgroundColor = [UIColor redColor];
        navView.frame = CGRectMake(0, 0, sideBarW, navHeight);
        self.navView = navView;

    }
    return self;
}
#pragma mark     ------  懒加载
- (UITableView *)sideTableview
{
    if (!_sideTableview) {
        //创建一个属性
        _sideTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, navHeight, sideBarW, screenH - navHeight) style:UITableViewStylePlain];
        _sideTableview.delegate = self;
        _sideTableview.dataSource = self;
        _sideTableview.backgroundColor = [UIColor colorWithRed:239 /255.f green:239 /255.f blue:244 /255.f alpha:1.];
        _sideTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sideTableview.showsVerticalScrollIndicator = NO;
    }
    return  _sideTableview;
}
- (NSArray *)dataArray
{
    if (!_dataArray) {
        //创建一个属性
        _dataArray = [NSArray array];
    }
    return  _dataArray;
}
#pragma mark     ------  控制方法
- (void)callSideBarIn:(UIViewController *)targetController WithDataArray:(NSArray<NSString *> *)titles
{
    self.dataArray = titles;
    [self callSideBarIn:targetController];
}
- (void)callSideBarIn:(UIViewController *)targetController
{
    self.targetVC = targetController;
    [UIView animateWithDuration:0.5 animations:^{
        [self changeViewFrame:targetController];
    }];
   
        
    [targetController.view addSubview:self];
    [self addSubview:self.sideTableview];
    [self addSubview:self.navView];
    
    self.navView.frame = CGRectMake(-sideBarW, 0, sideBarW, navHeight);
    self.sideTableview.frame = CGRectMake(0, screenH, sideBarW, screenH);
    [UIView animateWithDuration:0.5 animations:^{
        self.sideTableview.frame = CGRectMake(0, navHeight, sideBarW, screenH - navHeight);
        self.navView.frame = CGRectMake(0, 0, sideBarW, navHeight);
    }];

    
}

- (void)makeHeaderView:(NSNotification *)notifacation
{
    NSDictionary *dic = notifacation.userInfo;
    UIView *view = dic[@"view"];
    NSNumber *section = dic[@"section"];
    view.tag = [section integerValue];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addHeaderViewAction:)]];
}
- (void)addHeaderViewAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:didSelectHeaderAtIndex:)]) {
        [self.delegate SideBar:self.clickTableview didSelectHeaderAtIndex:tap.view.tag];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MAKEHEADERVIEW object:nil];
}
#pragma mark     ------  targetViewController弹出消失
- (void)changeViewFrame:(UIViewController *)vc
{
    for (UIView *subview in vc.view.subviews) {
        CGRect frame = subview.frame;
        frame.origin.x += sideBarW;
        subview.frame = frame;
    }
    [vc.view addSubview:self.maskView];
}
- (void)restoreViewFrame:(UIViewController *)vc
{
    for (UIView *subview in vc.view.subviews) {
        CGRect frame = subview.frame;
        frame.origin.x -= sideBarW;
        subview.frame = frame;
    }
    [self.maskView removeFromSuperview];
}
- (void)goBackAndDismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        [self restoreViewFrame:self.targetVC];
    }];
}

#pragma mark     ------  代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UIView *view = [tableView headerViewForSection:section];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(SideBar:numberOfRowsInSection:)]) {
        if (view.exclusiveTouch) {
            return [self.delegate SideBar:tableView numberOfRowsInSection:section];
        } else {
            return 0;
        }
    } else {
        if (view.exclusiveTouch) {
            return self.dataArray.count;
        } else {
            return 0;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self goBackAndDismiss];
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:didSelectRowAtIndexPath:)]) {
        [self.delegate SideBar:tableView didSelectRowAtIndexPath:indexPath];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:cellForRowAtIndexPath:)]) {
       return [self.delegate SideBar:tableView cellForRowAtIndexPath:indexPath];
    } else {
        NSString *cell_id = @"sideBarCell";
        SidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (!cell) {
            cell = [[SidebarCell alloc] init];
        }
        cell.title = self.dataArray[indexPath.row];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellH = 50;
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:heightForRowAtIndexPath:)]) {
        cellH = [self.delegate SideBar:tableView heightForRowAtIndexPath:indexPath];
    }
    return cellH;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(numberOfSectionsInSideBar:)]) {
        return [self.delegate numberOfSectionsInSideBar:tableView];
    }
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:titleForHeaderInSection:)]) {
        return [self.delegate SideBar:tableView titleForHeaderInSection:section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:titleForFooterInSection:)]) {
        return [self.delegate SideBar:tableView titleForFooterInSection:section];
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate SideBar:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:heightForHeaderInSection:)]) {
        return [self.delegate SideBar:tableView heightForHeaderInSection:section];
    }
    return CGFLOAT_MIN;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:heightForFooterInSection:)]) {
        return [self.delegate SideBar:tableView heightForFooterInSection:section];
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:viewForHeaderInSection:)]) {
        SideBarHeaderView *headerView = [[SideBarHeaderView alloc] init];
        headerView = (SideBarHeaderView *)[self.delegate SideBar:tableView viewForHeaderInSection:section];
//                添加头视图的点击事件
        [[NSNotificationCenter defaultCenter] postNotificationName:MAKEHEADERVIEW object:self userInfo:@{@"section" : [NSNumber numberWithInteger:section],@"view" : headerView}];
        
        self.clickTableview = tableView;
        return headerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(SideBar:viewForFooterInSection:)]) {
       return [self.delegate SideBar:tableView viewForFooterInSection:section];
    }
    return nil;
}


@end
