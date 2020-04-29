//
//  AppStoreAnimatedTransition.m
//  CYXAppStoreHomeAnimationDemo
//
//  Created by 晓 on 2020/4/26.
//  Copyright © 2020 晓. All rights reserved.
//

#import "AppStoreAnimatedTransition.h"
#import "AppStoreListTableViewCell.h"
#import "AppStoreDetailViewController.h"
#import <Masonry.h>
@interface AppStoreAnimatedTransition ()

@property (nonatomic,strong) AppStoreListTableViewCell *snapshotView;
@end
@implementation AppStoreAnimatedTransition

-(CGFloat)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (self.transitionType) {
        case TransitionTypeShow:
            {
                [self showAnimateTransitionWithTransitionContext:transitionContext];
            }
            break;
        case TransitionTypeDismiss:
            {
                [self dismissAnimateTransitionWithTransitionContext:transitionContext];
            }
            break;
            
        default:
            break;
    }
}

-(void)showAnimateTransitionWithTransitionContext:(id<UIViewControllerContextTransitioning> )transitionContext{
    AppStoreDetailViewController * toVC = (AppStoreDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView * containerView = transitionContext.containerView;
    CGRect cellNewRect = [containerView convertRect:self.itemCell.backImageView.frame fromView:self.itemCell.backImageView.superview];
    self.snapshotView = [[AppStoreListTableViewCell alloc] init];
    [self.snapshotView setImageName:self.itemCell.imageName];
    self.snapshotView.layer.masksToBounds = true;
    [containerView addSubview:toVC.view];
    [containerView addSubview:self.snapshotView];
    [self.snapshotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CGRectGetMinX(cellNewRect));
        make.top.mas_equalTo(CGRectGetMinY(cellNewRect));
        make.width.mas_equalTo(CGRectGetWidth(cellNewRect));
        make.height.mas_equalTo(CGRectGetHeight(cellNewRect));
    }];
    [self.snapshotView.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.and.bottom.mas_equalTo(0);
    }];
    
    toVC.headerView.hidden = true;
    toVC.view.frame = cellNewRect;
    [toVC.view layoutIfNeeded];
    [containerView layoutIfNeeded];
    [self.snapshotView presentWillAnimated];
    
    UIVisualEffectView * visualEffectView =[self getVisualEffectView];;
    visualEffectView.frame = fromVC.view.bounds;
    visualEffectView.alpha = 0;
    [containerView insertSubview:visualEffectView aboveSubview:fromVC.view];
    
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        [self.snapshotView layoutIfNeeded];
        [containerView layoutIfNeeded];
        [self.snapshotView presentAnimated];
        toVC.view.frame = UIScreen.mainScreen.bounds;
        [toVC.view layoutIfNeeded];
        visualEffectView.alpha = 1;
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (finished) {
                toVC.headerView.hidden = false;
                [transitionContext completeTransition:true];
                [self.snapshotView removeFromSuperview];
                [containerView insertSubview:fromVC.view belowSubview:visualEffectView];
            }
        }
    }];
}
-(void)dismissAnimateTransitionWithTransitionContext:(id<UIViewControllerContextTransitioning> )transitionContext{
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    AppStoreDetailViewController * fromVC = (AppStoreDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView * containerView = transitionContext.containerView;
    fromVC.headerView.hidden = true;
    self.itemCell.hidden = true;
    
    CGRect snapshotViewCurrentRect = [containerView convertRect:fromVC.headerView.frame fromView:fromVC.headerView.superview];
    CGRect snapshotTargetRect = [containerView convertRect:self.itemCell.backImageView.frame fromView:self.itemCell.backImageView.superview];
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:self.snapshotView];
    self.snapshotView.closeButton.alpha = fromVC.headerView.closeButton.alpha;
    
    [self.snapshotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CGRectGetMinX(snapshotViewCurrentRect));
        make.top.mas_equalTo(CGRectGetMinY(snapshotViewCurrentRect));
        make.width.mas_equalTo(CGRectGetWidth(snapshotViewCurrentRect));
        make.height.mas_equalTo(CGRectGetHeight(snapshotViewCurrentRect));
    }];
    
    [containerView layoutIfNeeded];
    
    [self.snapshotView dismissWillAnimated];
    [self.snapshotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CGRectGetMinX(snapshotTargetRect));
        make.top.mas_equalTo(CGRectGetMinY(snapshotTargetRect));
        make.width.mas_equalTo(CGRectGetWidth(snapshotTargetRect));
        make.height.mas_equalTo(CGRectGetHeight(snapshotTargetRect));
    }];
    UIVisualEffectView * visualEffectView =[self getVisualEffectView];
    visualEffectView.frame = fromVC.view.bounds;
    visualEffectView.alpha = 1;
    [containerView insertSubview:visualEffectView aboveSubview:fromVC.view];
    CGFloat damping = 0.7;
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
         usingSpringWithDamping:damping
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        [containerView layoutIfNeeded];
        [self.snapshotView dismissAnimated];
        visualEffectView.alpha = 0;
        //这里为了防止dismiss弹簧动画上面漏出下面的文字
        fromVC.view.frame = CGRectMake(CGRectGetMinX(snapshotTargetRect), CGRectGetMinY(snapshotTargetRect)+(1-damping)*CGRectGetHeight(snapshotTargetRect), CGRectGetWidth(snapshotTargetRect), CGRectGetHeight(snapshotTargetRect)*damping);
        [fromVC.view layoutIfNeeded];

        
    } completion:^(BOOL finished) {
        if (finished) {
            if (finished) {
                [transitionContext completeTransition:true];
                self.itemCell.hidden = false;
            }
        }
    }];
}

-(UIVisualEffectView *)getVisualEffectView{
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * visualEffectView =[[UIVisualEffectView alloc] initWithEffect:blur];
    return visualEffectView;
}

#pragma mark ---G
-(AppStoreListTableViewCell*)itemCell{
    if(!_itemCell){
        _itemCell = [[AppStoreListTableViewCell alloc] init];
    }
    return _itemCell;
}

@end
