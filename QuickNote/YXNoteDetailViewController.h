//
//  YXNoteDetailViewController.h
//  QuickNote
//
//  Created by Yixi Liu on 13-8-23.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXFillTagsView;

@interface YXNoteDetailViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic)NSInteger noteid;
@property (strong, nonatomic) NSDictionary *currentNote;
@property UITextField *NoteTag;
@property UITextView *NoteContent;

//@property (weak, nonatomic) IBOutlet UITextView *NoteContent;
@property UIScrollView *scrollView;
@property YXFillTagsView *fillTagsView;

@end
