//
//  YXTrashDetailController.h
//  QuickNote
//
//  Created by Yixi Liu on 13-8-31.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXFillTagsView;
@interface YXTrashDetailController : UIViewController

@property (nonatomic)NSInteger noteid;
@property (strong, nonatomic) NSDictionary *currentNote;
@property UITextView *NoteContent;
@property NSString *tags;
@property UIScrollView *scrollView;
@property YXFillTagsView *fillTagsView;

@property NSString *folder;

@end
