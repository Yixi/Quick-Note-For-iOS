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
    CGFloat NoteViewMinHeight;
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];

    //Scroll view

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0,
            self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 20 - self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:_scrollView];



    //noteContent

    NoteViewMinHeight = _scrollView.frame.size.height - 58;
    _NoteContent = [[UITextView alloc] initWithFrame:CGRectMake(0, 58, 320, NoteViewMinHeight)];
    _NoteContent.scrollEnabled = NO;
    _NoteContent.delegate = self;
    [_scrollView addSubview:_NoteContent];

    UIImage *scrollBg = [UIImage imageNamed:@"horizontal-line.gif"];
    [_NoteContent setBackgroundColor:[UIColor colorWithPatternImage:scrollBg]];

    //set note content padding
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 30, 20, 20);
    _NoteContent.contentInset = padding;

    CGRect frame = _NoteContent.frame;
    CGRect insetFrame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, padding.left, 0, padding.right));
    CGFloat offsetX = frame.origin.x - (insetFrame.origin.x - ( padding.left + padding.right ) / 2);
    insetFrame = CGRectApplyAffineTransform(insetFrame, CGAffineTransformMakeTranslation(offsetX, 0));
    _NoteContent.frame = insetFrame;
    _NoteContent.bounds = UIEdgeInsetsInsetRect(_NoteContent.bounds, UIEdgeInsetsMake(0, -padding.left, 0, -padding.right));
    [_NoteContent scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];


    //tag label

    UILabel *tagTitle = [[UILabel alloc] initWithFrame:CGRectMake(41, 24, 50, 21)];
    tagTitle.text = @"Tags:";
    [_scrollView addSubview:tagTitle];

    //tag input
    _NoteTag = [[UITextField alloc] initWithFrame:CGRectMake(99, 20, 181, 30)];
    _NoteTag.delegate = self;
    [_scrollView addSubview:_NoteTag];

    //fill tag view
    _fillTagsView = [[YXFillTagsView alloc] initWithFrame:CGRectMake(99, 20, 181, 30)];
    [_scrollView addSubview:_fillTagsView];
    [_fillTagsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TouchWithTags:)]];


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
    CGFloat noteContentHeight = self.view.frame.size.height - _scrollView.frame.origin.y;
    CGFloat resizeHeight = noteContentHeight - keyboardHeight;
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, resizeHeight);
}

- (void)restoreNoteContentHeight{
    CGFloat noteContentHeight = self.view.frame.size.height - _scrollView.frame.origin.y;
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, noteContentHeight);
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

- (void)saveButton:(id)sender{
    [self.view endEditing:YES];
}

- (void)TouchWithTags:(id)sender{
    _fillTagsView.hidden = YES;
    _NoteTag.hidden = NO;
    [_NoteTag becomeFirstResponder];
}
- (void)reloadTagView{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_NoteTag.text componentsSeparatedByString:@""]];
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
    [self adjustContentHeight];
}

- (void)adjustContentHeight{
    if([_NoteContent.text length]>0){
        CGRect frame = _NoteContent.frame;
        if(_NoteContent.contentSize.height > NoteViewMinHeight){

            frame.size.height = _NoteContent.contentSize.height;
            _NoteContent.frame = frame;

            CGSize size = _scrollView.contentSize;
            size.height = frame.size.height + _NoteContent.frame.origin.y;
            _scrollView.contentSize = size;

        }
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
