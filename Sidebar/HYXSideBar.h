//
//  HYXSideBar.h
//  Sidebar
//
//  Created by 侯云祥 on 2017/3/21.
//  Copyright © 2017年 今晚打老虎. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYXSideBar;
@protocol HYXSideBarDelegate <NSObject>
@optional
/**
 获取相应组里面的行数

 @param tableView sidebar里面的tableview
 @param section 第几组
 @return 返回的行数
 */
- (NSInteger)SideBar:( UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
 cell的点击事件

 @param tableView sidebar
 @param indexPath 点击的cell位置
 */
- (void)SideBar:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 header的点击事件
 
 @param tableView sidebar
 @param index 点击的header的位置
 */
- (void)SideBar:(UITableView *)tableView didSelectHeaderAtIndex:(NSInteger )index;
/**
 得到相应的cell（也是可以随意自定义的）
 
 @param tableView sidebar里面的tableview
 @param indexPath 相应位置里面的
 @return 返回需要的cell
 */
- (UITableViewCell *)SideBar:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 总组数

 @param tableView SideBar
 @return 返回的总组数
 */
- (NSInteger)numberOfSectionsInSideBar:(UITableView *)tableView;

/**
 每一组的header名称

 @param tableView sidebar
 @param section 相应的组序列
 @return  组的名称
 */
- (NSString *)SideBar:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

/**
 每一组的footer的名称

 @param tableView sidebar
 @param section 相应的组序列
 @return 每一组的footer名称
 */
- (NSString *)SideBar:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

/**
 cell生命周期，将要描绘出来

 @param tableView sidebar
 @param cell 将要描绘的cell
 @param indexPath cell的位置
 */
- (void)SideBar:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 cell的高度

 @param tableView sidebar
 @param indexPath cell的位置
 @return 返回的cell的高度
 */
- (CGFloat)SideBar:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 Header的高度

 @param tableView sidebar
 @param section 组
 @return 高度
 */
- (CGFloat)SideBar:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

/**
 footer的高度
 
 @param tableView sidebar
 @param section 组
 @return 高度
 */
- (CGFloat)SideBar:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

/**
 返回一个描述header的view

 @param tableView sidebar
 @param section 相应的组别
 @return 返回的viwe
 */
- (UIView *)SideBar:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
/**
 返回一个描述header的view
 
 @param tableView sidebar
 @param section 相应的组别
 @return 返回的viwe
 */
- (UIView *)SideBar:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
@end

@interface HYXSideBar : UIView<UITableViewDelegate,UITableViewDataSource>

/** 数据   */
@property (nonatomic ,strong) NSArray *dataArray;
/** 代理   */
@property (nonatomic , weak) id<HYXSideBarDelegate> delegate;

/**
 普通的初始化方法，创建sidebar之后调用代理方法进行数据加载

 @param targetController 需要弹出sidebar的控制器
 */
- (void)callSideBarIn:(UIViewController *)targetController;

/**
 简便的初始化方法，直接付给一个数组之后就可以展示想要的sidebar

 @param targetController  需要弹出sidebar的控制器
 @param titles 标题的数组
 */
- (void)callSideBarIn:(UIViewController *)targetController WithDataArray:(NSArray<NSString *> *)titles;
@end
