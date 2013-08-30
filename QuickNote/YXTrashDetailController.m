//
//  YXTrashDetailController.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-31.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXTrashDetailController.h"
#import "YXFillTagsView.h"
#import "YXDB.h"

@interface YXTrashDetailController (){
    CGFloat NoteViewMinHeight;
}
@end

@implementation YXTrashDetailController

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
    [self setupView];
    [self initNote];


}


- (void)setupView{
    //scroll view

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

    //note content
    [self setupNoteContent];

    //tag label

    UILabel *tagTitle = [[UILabel alloc] initWithFrame:CGRectMake(28, 15, 50, 21)];
    tagTitle.text = @"Tags:";
    [_scrollView addSubview:tagTitle];

    //fill tag view
    _fillTagsView = [[YXFillTagsView alloc] initWithFrame:CGRectMake(80, 15, 240, 30)];
    [_scrollView addSubview:_fillTagsView];

}


- (void)setupNoteContent{
    NoteViewMinHeight = _scrollView.frame.size.height - 58;
    _NoteContent = [[UITextView alloc] initWithFrame:CGRectMake(20, 45, 280, NoteViewMinHeight)];
    _NoteContent.backgroundColor = [UIColor clearColor];
    _NoteContent.font = [UIFont systemFontOfSize:20];
    _NoteContent.editable = NO;
    _NoteContent.scrollEnabled = NO;
    [_scrollView addSubview:_NoteContent];
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

- (void)reloadTagView{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_tags componentsSeparatedByString:@" "]];
    if(!([array count]==1 && [array[0] length]==0)){
        [_fillTagsView bindTags:array isOverFlowHide:YES];
    }else{
        [_fillTagsView emptyTags];
    }
}

#pragma mark - Note

- (void)initNote{
    if(self.noteid){
        self.currentNote = [[YXDB alloc] LoadNoteWithId:self.noteid];
        self.title = [_currentNote objectForKey:@"title"];
        _tags = [_currentNote objectForKey:@"tags"];
        _NoteContent.text = [_currentNote objectForKey:@"desc"];
        [self resetContentHeight];
        [self reloadTagView];
    }
}

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

@end
