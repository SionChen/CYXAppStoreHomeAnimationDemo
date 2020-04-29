//
//  AppStoreDetailViewController.h
//  CYXAppStoreHomeAnimationDemo
//
//  Created by 晓 on 2020/4/26.
//  Copyright © 2020 晓. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AppStoreListTableViewCell;
@interface AppStoreDetailViewController : UIViewController

/*头部*/
@property (nonatomic,strong) AppStoreListTableViewCell *headerView;
/*构造方法*/
-(instancetype)initWithImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
