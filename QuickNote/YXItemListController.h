//
//  YXItemListController.h
//  QuickNote
//
//  Created by Yixi Liu on 13-7-18.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXNoteDetailViewController;

@interface YXItemListController : UITableViewController{
    BOOL viewIsOutOfStage;
}

@property (strong, nonatomic) NSMutableArray *testData;
@property (strong, nonatomic) YXNoteDetailViewController *noteDetailViewController;

- (void)reloadData;
@end
