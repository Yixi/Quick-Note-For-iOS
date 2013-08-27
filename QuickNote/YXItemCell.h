//
//  YXItemCell.h
//  QuickNote
//
//  Created by Yixi Liu on 13-7-18.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXFillTagsView.h"

@interface YXItemCell : UITableViewCell

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *tags;
@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;

@end
