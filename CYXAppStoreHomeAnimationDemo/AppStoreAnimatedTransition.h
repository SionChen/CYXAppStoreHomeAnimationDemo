//
//  AppStoreAnimatedTransition.h
//  CYXAppStoreHomeAnimationDemo
//
//  Created by 晓 on 2020/4/26.
//  Copyright © 2020 晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class AppStoreListTableViewCell;
typedef NS_ENUM(NSInteger,TransitionType) {
    TransitionTypeShow,
    TransitionTypeDismiss
};
@interface AppStoreAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) AppStoreListTableViewCell *itemCell;
@property (nonatomic,assign) TransitionType transitionType;
@end

NS_ASSUME_NONNULL_END
