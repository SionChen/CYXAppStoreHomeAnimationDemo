//
//  AppStoreListTableViewCell.h
//  CYXAppStoreHomeAnimationDemo
//
//  Created by 晓 on 2020/4/26.
//  Copyright © 2020 晓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
NS_ASSUME_NONNULL_BEGIN

#define ANIMATION_DURATION 1

@interface AppStoreListTableViewCell : UITableViewCell
@property (nonatomic,strong) NSString *imageName;

/*背景*/
@property (nonatomic,strong) UIImageView *backImageView;
/*关闭按钮*/
@property (nonatomic,strong) UIButton *closeButton;
/*关闭按钮*/
@property (nonatomic,copy) dispatch_block_t closeButtonBlock;


/*动画*/
-(void)affineTransformImageViewWithScale:(CGFloat)scale;
/*更新frame*/
-(void)transformImageViewConstraints:(void(^)(MASConstraintMaker *make))block compete:(dispatch_block_t)comoete;
-(void)setDetailUI;

#pragma mark ---Animation
-(void)presentWillAnimated;
-(void)presentAnimated;
-(void)dismissWillAnimated;
-(void)dismissAnimated;


@end

NS_ASSUME_NONNULL_END
