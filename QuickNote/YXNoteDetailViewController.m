//
//  YXNoteDetailViewController.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-23.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXNoteDetailViewController.h"
#import "YXDB.h"

@interface YXNoteDetailViewController ()
- (void)initNote;
@end

@implementation YXNoteDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNote];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setNoteid:(NSInteger)newNoteid {
    if(_noteid!=newNoteid){
        _noteid = newNoteid;
        [self initNote];
    }
}
#pragma mark - Note;

- (void)initNote{
    if(self.noteid){
        self.currentNote = [[YXDB alloc] LoadNoteWithId:self.noteid];
        _NoteTitle.text = [_currentNote objectForKey:@"title"];
        _NoteTag.text = [_currentNote objectForKey:@"tags"];
        _NoteContent.text = [_currentNote objectForKey:@"desc"];
    }
}

- (void)saveNote{
    NSString *title = _NoteTitle.text;
    NSString *tag = _NoteTag.text;
    NSString *content = _NoteContent.text;
    [[YXDB alloc] SaveNote:_noteid title:title desc:content tag:tag];

}

#pragma mark - UITextView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"textview begin editing");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"editing");
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"End edting");
    [self saveNote];
}
- (void)textViewDidChange:(UITextView *)textView {
    [self saveNote];
}

@end
