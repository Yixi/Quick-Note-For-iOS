//
//  YXTrashListViewController.h
//  QuickNote
//
//  Created by Yixi Liu on 13-8-30.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTrashListViewController : UITableViewController{
    BOOL viewIsOutOfStage;
}

@property (strong, nonatomic) NSMutableArray *NoteList;

@end
