//
//  YXSettingViewController.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-27.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <PXEngine/PXEngine.h>
#import "YXSettingViewController.h"
#import "YXUtil.h"

@interface YXSettingViewController (){
    UITableView *folderView;
    NSArray *folders;
    UIImage *settingView_bg;
}
@end

@implementation YXSettingViewController

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

    [self setupViews];
}

- (void)setupViews{
    //titile area
    UIImage *setting_bg = [UIImage imageNamed:@"settingheader.png"];
    CGSize titlesize = _viewTitle.bounds.size;
    setting_bg = [[YXUtil alloc] scaleToSize:setting_bg size:titlesize];
    [_viewTitle setBackgroundImage:setting_bg forBarMetrics:UIBarMetricsDefault];

    //bg

    settingView_bg = [UIImage imageNamed:@"settingbg.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:settingView_bg]];

    //folder

    folders = [NSArray arrayWithObjects:@"All Notes",@"Trash",@"Conflict",nil];
    folderView = [[UITableView alloc] initWithFrame:CGRectMake(0, _viewTitle.frame.size.height, self.view.frame.size.width, 35*3) style:UITableViewStylePlain];
    folderView.dataSource = self;
    folderView.delegate = self;
    folderView.separatorColor = [UIColor colorWithHexString:@"#475c73"];
    [self.view addSubview:folderView];
    [folderView setBackgroundColor:[UIColor colorWithPatternImage:settingView_bg]];
}


#pragma mark - folders

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellWithIdentifier = @"floderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if(cell== nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [folders objectAtIndex:row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [folders count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public method;

- (void)setVisible:(BOOL)visible {
    self.view.hidden = !visible;
}

@end
