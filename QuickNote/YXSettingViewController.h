//
//  YXSettingViewController.h
//  QuickNote
//
//  Created by Yixi Liu on 13-8-27.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXSettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

- (void)setVisible:(BOOL)visible;
@property (weak, nonatomic) IBOutlet UINavigationBar *viewTitle;

@end
