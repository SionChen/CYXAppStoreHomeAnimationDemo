//
//  AppStoreListViewController.m
//  CYXAppStoreHomeAnimationDemo
//
//  Created by 晓 on 2020/4/28.
//  Copyright © 2020 晓. All rights reserved.
//

#import "AppStoreListViewController.h"
#import "AppStoreAnimatedTransition.h"
#import "AppStoreListTableViewCell.h"
#import "AppStoreDetailViewController.h"
#import <Masonry.h>
@interface AppStoreListViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>
/*图片数据*/
@property (nonatomic,strong) NSArray<NSString *> *imageDataList;
/*动画*/
@property (nonatomic,strong) AppStoreAnimatedTransition *appStoreAnimatedTransition;
/*列表*/
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL statuBarHidden;

@end

@implementation AppStoreListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.statuBarHidden = false;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.and.right.mas_equalTo(0);
    }];
}

#pragma mark ---UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageDataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppStoreListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AppStoreListTableViewCell.description];
    [cell setImageName:self.imageDataList[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppStoreListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    AppStoreDetailViewController * viewController = [[AppStoreDetailViewController alloc] initWithImageName:self.imageDataList[indexPath.row]];
    viewController.transitioningDelegate = self;
    self.appStoreAnimatedTransition.itemCell = cell;
    [self presentViewController:viewController animated:true completion:^{
        [cell transformImageViewConstraints:^(MASConstraintMaker * make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.and.bottom.mas_equalTo(-20);
        } compete:nil];
    }];
//    [cell transformImageViewConstraints:^(MASConstraintMaker * _Nonnull make) {
//        make.top.mas_equalTo(20);
//        make.left.mas_equalTo(40);
//        make.right.and.bottom.mas_equalTo(-40);
//    } compete:^{
//        AppStoreDetailViewController * viewController = [[AppStoreDetailViewController alloc] initWithImageName:self.imageDataList[indexPath.row]];
//        viewController.transitioningDelegate = self;
//        self.appStoreAnimatedTransition.itemCell = cell;
//        [self presentViewController:viewController animated:true completion:^{
//            [cell transformImageViewConstraints:^(MASConstraintMaker * make) {
//                make.top.mas_equalTo(0);
//                make.left.mas_equalTo(20);
//                make.right.and.bottom.mas_equalTo(-20);
//            } compete:nil];
//        }];
//    }];
    
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    AppStoreListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell affineTransformImageViewWithScale:0.95];
    return true;
}
-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    AppStoreListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell affineTransformImageViewWithScale:1];
}
#pragma mark ---UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.appStoreAnimatedTransition.transitionType = TransitionTypeShow;
    return self.appStoreAnimatedTransition;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.appStoreAnimatedTransition.transitionType = TransitionTypeDismiss;
    return self.appStoreAnimatedTransition;
}
#pragma mark ---StatuBar
-(void)setStatuBarHidden:(BOOL)statuBarHidden{
    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}
-(BOOL)prefersStatusBarHidden{
    return false;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationSlide;
}
#pragma mark ---G
-(NSArray<NSString *>*)imageDataList{
    if(!_imageDataList){
        _imageDataList = @[@"image1",@"image2",@"image3",@"image4",@"image5",@"image6",@"image7",];
    }
    return _imageDataList;
}
-(AppStoreAnimatedTransition*)appStoreAnimatedTransition{
    if(!_appStoreAnimatedTransition){
        _appStoreAnimatedTransition = [[AppStoreAnimatedTransition alloc] init];
    }
    return _appStoreAnimatedTransition;
}
-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = (UIScreen.mainScreen.bounds.size.width - 40)*1.3+15;
        [_tableView registerClass:[AppStoreListTableViewCell class] forCellReuseIdentifier:AppStoreListTableViewCell.description];
    }
    return _tableView;
}



@end
