//
//  AppStoreDetailViewController.m
//  CYXAppStoreHomeAnimationDemo
//
//  Created by 晓 on 2020/4/26.
//  Copyright © 2020 晓. All rights reserved.
//

#import "AppStoreDetailViewController.h"
#import "AppStoreAnimatedTransition.h"
#import "AppStoreListTableViewCell.h"
#import <Masonry.h>
@interface AppStoreDetailViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic,assign) BOOL statuBarHidden;
/*scroll*/
@property (nonatomic,strong) UIScrollView *scrollView;
/*关闭按钮*/
@property (nonatomic,strong) UIButton *closeButton;
/*文本*/
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,assign) BOOL isDismiss;

@end

@implementation AppStoreDetailViewController

-(instancetype)initWithImageName:(NSString *)imageName{
    if (self = [super init]) {
        self.modalPresentationStyle =  UIModalPresentationFullScreen;
        [self.headerView setImageName:imageName];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.statuBarHidden = true;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.layer.masksToBounds = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.contentLabel];
    [self setConstrains];
    
    UIScreenEdgePanGestureRecognizer * edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGestureRecognizerAction:)];
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureActionRecognizerAction:)];
    panGesture.delegate = self;
    [panGesture requireGestureRecognizerToFail:edgePanGestureRecognizer];
    [self.view addGestureRecognizer:panGesture];
    
}
-(void)setConstrains{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.equalTo(self.view);
        make.top.mas_equalTo(0);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.scrollView);
        make.width.equalTo(self.view);
        make.height.equalTo(self.scrollView.mas_width).multipliedBy(1.34);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width-40);
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
        make.centerX.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView).offset(-20);
    }];
    [self.headerView setDetailUI];
}
-(void)edgePanGestureRecognizerAction:(UIScreenEdgePanGestureRecognizer *)edgePanGestureRecognizer{
    CGFloat  progress = [edgePanGestureRecognizer translationInView:self.view].x/self.view.bounds.size.width;
    [self zoomWithProgress:progress gesture:edgePanGestureRecognizer];
}
-(void)panGestureActionRecognizerAction:(UIPanGestureRecognizer *)panGestureActionRecognizer{
    if (self.scrollView.contentOffset.y > 0 && self.view.frame.size.width == UIScreen.mainScreen.bounds.size.width)  {return;}
    CGFloat  progress = [panGestureActionRecognizer translationInView:self.view].y/self.view.bounds.size.height;
    [self zoomWithProgress:progress gesture:panGestureActionRecognizer];
}
-(void)zoomWithProgress:(CGFloat)progress gesture:(UIGestureRecognizer *)gesture{
    if (progress>1||progress<0) {return;}
    CGFloat minScale = 0.83;
    CGFloat scale = (1-progress);
    if (scale>=1) {return;}
    if (scale >= minScale) {
        NSLog(@"scale::::%f",scale);
        self.view.transform = CGAffineTransformMakeScale( scale, scale);
        CGFloat cornerRadius = (1.0-scale)/(1-minScale)*10;
        self.headerView.closeButton.alpha = 1-((1.0-scale)/(1-minScale));
        self.view.layer.cornerRadius = cornerRadius;
        
    }else {
        
        gesture.enabled = false;
        self.isDismiss = true;
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    switch (gesture.state) {
        case UIGestureRecognizerStateCancelled:{
            
            if (!self.isDismiss) {
                self.view.layer.cornerRadius = 0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.transform =CGAffineTransformIdentity;
                    self.headerView.closeButton.alpha = 1;
                }];
            }else {
                self.isDismiss = true;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if (!self.isDismiss) {
                self.view.layer.cornerRadius = 0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.transform =CGAffineTransformIdentity;
                    self.headerView.closeButton.alpha = 1;
                }];
            }else {
                self.isDismiss = true;
            }
        }
            
        default:
            break;
    }
}
#pragma mark ---UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    scrollView.panGestureRecognizer.enabled = scrollView.contentOffset.y >= 0;
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}
#pragma mark ---UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return otherGestureRecognizer == self.scrollView.panGestureRecognizer; //阻止的是scrollview就同时响应
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
-(UIScrollView*)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
-(AppStoreListTableViewCell*)headerView{
    if(!_headerView){
        _headerView = [[AppStoreListTableViewCell alloc] init];
        __weak typeof(self) weakSelf = self;
        _headerView.closeButtonBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _headerView;
}

-(UIButton*)closeButton{
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeButton.alpha = 0;
    }
    return _closeButton;
}
-(UILabel*)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.text = @"四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?四月影单：职场什么最重要?";
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
