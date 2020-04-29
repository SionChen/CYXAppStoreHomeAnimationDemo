//
//  AppStoreListTableViewCell.m
//  CYXAppStoreHomeAnimationDemo
//
//  Created by 晓 on 2020/4/26.
//  Copyright © 2020 晓. All rights reserved.
//

#import "AppStoreListTableViewCell.h"
#import <Masonry.h>
@interface AppStoreListTableViewCell()

/*小标题*/
@property (nonatomic,strong) UILabel *titleLabel;
/*大标题*/
@property (nonatomic,strong) UILabel *explainLabel;


@end
@implementation AppStoreListTableViewCell


-(void)initViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.titleLabel];
    [self.backImageView addSubview:self.explainLabel];
    [self addSubview:self.closeButton];
    [self setConstrains];
}
-(void)setConstrains{
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.and.bottom.equalTo(self).offset(-20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView).offset(10);
        make.left.equalTo(self.backImageView).offset(20);
    }];
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backImageView).offset(20);
        make.right.equalTo(self.backImageView).offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(80);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.width.and.height.mas_equalTo(25);
    }];
}
-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.backImageView.image = [UIImage imageNamed:imageName];
}
-(void)closeButtonClick{
    if (self.closeButtonBlock) {
        self.closeButtonBlock();
    }
}
#pragma mark ---transform
-(void)transformImageViewConstraints:(void(^)(MASConstraintMaker *))block compete:(dispatch_block_t)compete{
    [UIView animateWithDuration:0.2 animations:^{
        [self.backImageView mas_updateConstraints:block];
    } completion:^(BOOL finished) {
        if (compete) {
            compete();
        }
    }];
}
-(void)affineTransformImageViewWithScale:(CGFloat)scale{
    [self affineTransformImageViewWithScale:scale compete:^{
        
    }];
}
-(void)affineTransformImageViewWithScale:(CGFloat)scale
                                 compete:(dispatch_block_t)block{
    [UIView animateWithDuration:0.2 animations:^{
        self.backImageView.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}
#pragma mark ---G
-(UIImageView*)backImageView{
    if(!_backImageView){
        _backImageView = [[UIImageView alloc] init];
        _backImageView.backgroundColor = [UIColor redColor];
        _backImageView.layer.cornerRadius = 10;
        _backImageView.layer.masksToBounds = true;
        _backImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _backImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backImageView;
}
-(UILabel*)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _titleLabel.text = @"编辑最爱";
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}
-(UILabel*)explainLabel{
    if(!_explainLabel){
        _explainLabel = [[UILabel alloc] init];
        _explainLabel.textColor = [UIColor whiteColor];
        _explainLabel.text = @"四月影单：职场什么最重要?";
        _explainLabel.font = [UIFont boldSystemFontOfSize:32];
        _explainLabel.numberOfLines = 0;
    }
    return _explainLabel;
}
-(UIButton*)closeButton{
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeButton.alpha = 0;
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}



#pragma mark ---Animation
-(void)presentWillAnimated{
    self.backImageView.layer.cornerRadius = 10;
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        
        self.backImageView.layer.cornerRadius = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.superview);
        make.height.mas_equalTo(UIScreen.mainScreen.bounds.size.width*1.34).priorityHigh();
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView).offset(50);
        make.left.equalTo(self.backImageView).offset(20);
    }];
    
    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView).offset(50);
        make.right.equalTo(self).offset(-20);
        make.width.and.height.mas_equalTo(25);
    }];
    self.closeButton.alpha = 0;
}
-(void)setDetailUI{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView).offset(50);
        make.left.equalTo(self.backImageView).offset(20);
    }];
    
    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImageView).offset(50);
        make.right.equalTo(self).offset(-20);
        make.width.and.height.mas_equalTo(25);
    }];
    self.closeButton.alpha = 1;
    [self.backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.and.bottom.equalTo(self);
    }];
    self.backImageView.layer.cornerRadius = 0;
}
-(void)presentAnimated{
    self.closeButton.alpha = 1;
}
-(void)dismissWillAnimated{
    self.backImageView.layer.cornerRadius = 10;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(self.backImageView).offset(20);
    }];
    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.equalTo(self).offset(-20);
        make.width.and.height.mas_equalTo(25);
    }];
}
-(void)dismissAnimated{
    self.closeButton.alpha = 0;
    self.titleLabel.transform = CGAffineTransformIdentity;
    self.explainLabel.transform = CGAffineTransformIdentity;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}
@end
