//
//  YXNoteDetailViewController.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-23.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXNoteDetailViewController.h"
#import "YXItemListController.h"
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

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Notes"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(backToList:)];
    self.navigationItem.leftBarButtonItem = backButton;

    [self setupView];

}

- (void)setupView{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];

    UIImage *scrollBg = [UIImage imageNamed:@"horizontal-line.gif"];
    [_NoteContent setBackgroundColor:[UIColor colorWithPatternImage:scrollBg]];
}


- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    NSLog(@"keyboard height %f",keyboardSize.height);
//    self.view.frame = CGRectMake(0, -keyboardSize.height+20, self.view.frame.size.width, self.view.frame.size.height);
    CGFloat currentHeight = _NoteContent.frame.size.height;
    NSLog(@"currentheight %f",currentHeight);
//    _NoteContent.frame.size.height = currentHeight - keyboardSize.height;
}
- (void)keyboardWillHide:(NSNotification *)notification{
    NSLog(@"keyboard hide");
}

- (void)resizeNoteContentHeightByKeyboardHeight:(id)keyboardHeight{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -


- (void)setNoteid:(NSInteger)newNoteid {
    if(_noteid!=newNoteid){
        _noteid = newNoteid;
        [self initNote];
    }
}

- (void)backToList:(id)sender{
//    NSLog(@"back");
//    [self saveNote];
    [self.view endEditing:YES];
//    [[YXItemListController alloc] reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Note;

- (void)initNote{

    if(self.noteid){
        self.currentNote = [[YXDB alloc] LoadNoteWithId:self.noteid];
//        _NoteTitle.text = [_currentNote objectForKey:@"title"];
        self.title = [_currentNote objectForKey:@"title"];
        _NoteTag.text = [_currentNote objectForKey:@"tags"];
        _NoteContent.text = [_currentNote objectForKey:@"desc"];
    }
}

- (void)saveNote{
    NSString *title = self.title;
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

#pragma mark - UITextFileView for note title and tag

- (void)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"changing");
    [self saveNote];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"end title");
    [self saveNote];
}

@end
