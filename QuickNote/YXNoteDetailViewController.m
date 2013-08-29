//
//  YXNoteDetailViewController.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-23.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <PXEngine/PXEngine.h>
#import "YXNoteDetailViewController.h"
#import "YXItemListController.h"
#import "YXFillTagsView.h"
#import "YXDB.h"

@interface YXNoteDetailViewController (){
    CGFloat NoteViewMinHeight;
    UIView *titleArea;
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

- (void)viewWillAppear:(BOOL)animated {
    titleArea.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Notes"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(backToList:)];
    self.navigationItem.leftBarButtonItem = backButton;

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(saveButton:)];
    self.navigationItem.rightBarButtonItem = saveButton;



    [self setupView];
    [self initNote];
}

- (void)setupView{

    //set a view for title click
    titleArea = [[UIView alloc] initWithFrame:CGRectMake(85, 20, 150, 44)];
    titleArea.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTitle:)];
    [titleArea addGestureRecognizer:tapGesture];
    [self.navigationController.view addSubview:titleArea];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];

    //Scroll view

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0,
            self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 20 - self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:_scrollView];
    UIImage *scrollBg = [UIImage imageNamed:@"horline.png"];
    [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:scrollBg]];

    UIImage *viewBg = [UIImage imageNamed:@"verline.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:viewBg]];
    //shade view

    UIView *shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, 320, 240)];
    shadeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:shadeView];
    [shadeView setBackgroundColor:[UIColor colorWithPatternImage:viewBg]];

    //noteContent

    [self setupNoteContent];


    //tag label

    UILabel *tagTitle = [[UILabel alloc] initWithFrame:CGRectMake(28, 15, 50, 21)];
    tagTitle.text = @"Tags:";
    [_scrollView addSubview:tagTitle];

    //tag input
    _NoteTag = [[UITextField alloc] initWithFrame:CGRectMake(80, 15, 240, 30)];
    _NoteTag.delegate = self;
    [_scrollView addSubview:_NoteTag];

    //fill tag view
    _fillTagsView = [[YXFillTagsView alloc] initWithFrame:CGRectMake(80, 15, 240, 30)];
    [_scrollView addSubview:_fillTagsView];
    [_fillTagsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TouchWithTags:)]];


}

- (void)setupNoteContent{
    NoteViewMinHeight = _scrollView.frame.size.height - 58;
    _NoteContent = [[UITextView alloc] initWithFrame:CGRectMake(20, 45, 280, NoteViewMinHeight)];
    _NoteContent.backgroundColor = [UIColor clearColor];
    _NoteContent.font = [UIFont systemFontOfSize:20];
    _NoteContent.scrollEnabled = NO;
    _NoteContent.delegate = self;
    [_scrollView addSubview:_NoteContent];

//    UIImage *scrollBg = [UIImage imageNamed:@"horizontal-line.gif"];
//    [_NoteContent setBackgroundColor:[UIColor colorWithPatternImage:scrollBg]];

    //set note content padding
}


- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;

//    CGRect aRect = self.view.frame;
//    aRect.size.height -= keyboardSize.height;
////    if(!CGRectContainsPoint(aRect, _NoteContent.frame.origin)){
//        NSLog(@"%f",_NoteContent.frame.origin.y - keyboardSize.height);
//        CGPoint scrollPoint = CGPointMake(0.0, _NoteContent.frame.origin.y + keyboardSize.height);
//        [_scrollView setContentOffset:scrollPoint animated:YES];
////    }

//    [self resizeNoteContentHeightByKeyboardHeight:keyboardSize.height];

}
- (void)keyboardWillHide:(NSNotification *)notification{
//    [self restoreNoteContentHeight];
    UIEdgeInsets  contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
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
    titleArea.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButton:(id)sender{
    [self.view endEditing:YES];
}

- (void)TouchWithTags:(id)sender{
    _fillTagsView.hidden = YES;
    _NoteTag.hidden = NO;
    [_NoteTag becomeFirstResponder];
}
- (void)reloadTagView{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_NoteTag.text componentsSeparatedByString:@" "]];
    if(!([array count]==1 && [array[0] length]==0)){

        [_fillTagsView bindTags:array isOverFlowHide:YES];

        _NoteTag.hidden = YES;
        _fillTagsView.hidden  = NO;
    }else{
        [_fillTagsView emptyTags];
        _NoteTag.hidden = NO;
        _fillTagsView.hidden  = NO;
    }
}
#pragma mark - Note;

- (void)editTitle:(id)sender{
//    NSLog(@"title edit");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"input title"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"cancel"
                                          otherButtonTitles:@"save",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.text = self.title;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"button index %d",buttonIndex);
    if(buttonIndex==1){
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSString *title = tf.text;
        if(title.length < 1){
            title = @"New Note";
        }
        self.title = title;
        [self saveNote];
    }
}

- (void)initNote{

    if(self.noteid){
        self.currentNote = [[YXDB alloc] LoadNoteWithId:self.noteid];
//        _NoteTitle.text = [_currentNote objectForKey:@"title"];
        self.title = [_currentNote objectForKey:@"title"];
        NSString *tags = [_currentNote objectForKey:@"tags"];
        _NoteTag.text = tags;
        _NoteContent.text = [_currentNote objectForKey:@"desc"];
        [self resetContentHeight];
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

- (void)resetContentHeight{
    CGRect frame = _NoteContent.frame;
    frame.size.height = NoteViewMinHeight;
    _NoteContent.frame = frame;

    CGSize size = _scrollView.contentSize;
    size.height = frame.size.height + _NoteContent.frame.origin.y;
    _scrollView.contentSize = size;
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self adjustContentHeight];
}

- (void)adjustContentHeight{
    if([_NoteContent.text length]>0){
        CGRect frame = _NoteContent.frame;
        if(_NoteContent.contentSize.height > NoteViewMinHeight){

            frame.size.height = _NoteContent.contentSize.height+30;
            _NoteContent.frame = frame;

            CGSize size = _scrollView.contentSize;
            size.height = frame.size.height + _NoteContent.frame.origin.y + 30;
            _scrollView.contentSize = size;

        }
    }
}

- (void)scrollToCursor{
    if(_NoteContent.selectedRange.location!=NSNotFound){

        NSRange range;
        range.location = _NoteContent.selectedRange.location;
        range.length = _NoteContent.text.length - range.location;
        NSString *string = [_NoteContent.text stringByReplacingCharactersInRange:range withString:@""];
//        NSLog(string);
        CGSize size = [string sizeWithFont:_NoteContent.font constrainedToSize:_NoteContent.bounds.size lineBreakMode:NSLineBreakByCharWrapping];
        CGRect viewRect = _NoteContent.frame;
        CGFloat scrollHeight =  size.height;
        if(scrollHeight<105){
            scrollHeight = 0.0f;
        }else{
            scrollHeight -=105;
        }
        CGPoint final = CGPointMake(0, scrollHeight);
        [_scrollView setContentOffset:final animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}



- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"End edting");
    [self saveNote];
}
- (void)textViewDidChange:(UITextView *)textView {
    [self adjustContentHeight];
    [self scrollToCursor];
    [self saveNote];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self scrollToCursor];
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
