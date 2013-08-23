//
//  YXNoteDetailViewController.h
//  QuickNote
//
//  Created by Yixi Liu on 13-8-23.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXNoteDetailViewController : UIViewController <UITextViewDelegate>

@property NSInteger noteid;
@property (strong, nonatomic) NSDictionary *currentNote;
@property (weak, nonatomic) IBOutlet UILabel *NoteTitle;
@property (weak, nonatomic) IBOutlet UILabel *NoteTag;
@property (weak, nonatomic) IBOutlet UITextView *NoteContent;

@end
