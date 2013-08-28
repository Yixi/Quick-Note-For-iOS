//
//  YXNoteDetailViewController.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-23.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXNoteDetailViewController.h"
#import "YXItemListController.h"
#import "YXFillTagsView.h"
#import "YXDB.h"

@interface YXNoteDetailViewController (){
    YXFillTagsView *fillTagsView;
}
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];

    UIImage *scrollBg = [UIImage imageNamed:@"horizontal-line.gif"];
    [_NoteContent setBackgroundColor:[UIColor colorWithPatternImage:scrollBg]];

    //set note content padding
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 20, 20, 0);
    _NoteContent.contentInset = padding;

    CGRect frame = _NoteContent.frame;
    CGRect insetFrame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, padding.left, 0, padding.right));
    CGFloat offsetX = frame.origin.x - (insetFrame.origin.x - ( padding.left + padding.right ) / 2);
    insetFrame = CGRectApplyAffineTransform(insetFrame, CGAffineTransformMakeTranslation(offsetX, 0));
    _NoteContent.frame = insetFrame;
    _NoteContent.bounds = UIEdgeInsetsInsetRect(_NoteContent.bounds, UIEdgeInsetsMake(0, -padding.left, 0, -padding.right));
    [_NoteContent scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];

}


- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;

    [self resizeNoteContentHeightByKeyboardHeight:keyboardSize.height];

}
- (void)keyboardWillHide:(NSNotification *)notification{
    [self restoreNoteContentHeight];
}

- (void)resizeNoteContentHeightByKeyboardHeight:(CGFloat)keyboardHeight{
//    NSLog(@"%f",self.view.frame.size.height);
    CGFloat noteContentHeight = self.view.frame.size.height - _NoteContent.frame.origin.y;
    CGFloat resizeHeight = noteContentHeight - keyboardHeight;
    _NoteContent.frame = CGRectMake(_NoteContent.frame.origin.x, _NoteContent.frame.origin.y, _NoteContent.frame.size.width, resizeHeight);
}

- (void)restoreNoteContentHeight{
    CGFloat noteContentHeight = self.view.frame.size.height - _NoteContent.frame.origin.y;
    _NoteContent.frame = CGRectMake(_NoteContent.frame.origin.x, _NoteContent.frame.origin.y, _NoteContent.frame.size.width, noteContentHeight);
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

- (void)TouchWithTags:(id)sender{
    fillTagsView.hidden = YES;
    _NoteTag.hidden = NO;
    [_NoteTag becomeFirstResponder];
}
- (void)reloadTagView{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_NoteTag.text componentsSeparatedByString:@" "]];
    if(!([array count]==1 && [array[0] length]==0)){
        if(fillTagsView){
            [fillTagsView bindTags:array isOverFlowHide:YES];
        }else{
            fillTagsView = [[YXFillTagsView alloc] initWithFrame:CGRectMake(101, 18, 181.0, 30.0)];
            fillTagsView.tag = 4;
            [fillTagsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TouchWithTags:)]];
            [fillTagsView bindTags:array isOverFlowHide:YES];
            [self.view addSubview:fillTagsView];
        }
        _NoteTag.hidden = YES;
        fillTagsView.hidden  = NO;
    }else{
        [fillTagsView removeFromSuperview];
        _NoteTag.hidden = NO;
        fillTagsView.hidden  = NO;
    }
}
#pragma mark - Note;

- (void)initNote{

    if(self.noteid){
        self.currentNote = [[YXDB alloc] LoadNoteWithId:self.noteid];
//        _NoteTitle.text = [_currentNote objectForKey:@"title"];
        self.title = [_currentNote objectForKey:@"title"];
        NSString *tags = [_currentNote objectForKey:@"tags"];
        _NoteTag.text = tags;
        _NoteContent.text = [_currentNote objectForKey:@"desc"];

        [self reloadTagView];

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
    if(textField == _NoteTag){
//        NSLog(@"end tags");
        [self reloadTagView];
    }

    [self saveNote];
}

@end
