//
//  YXTrashListViewController.h
//  QuickNote
//
//  Created by Yixi Liu on 13-8-30.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXTrashDetailController;
@interface YXTrashListViewController : UITableViewController{
    BOOL viewIsOutOfStage;
}

@property NSString *folder;
@property (strong, nonatomic) NSMutableArray *NoteList;
@property (strong, nonatomic) YXTrashDetailController *trashDetailViewController;

@end
