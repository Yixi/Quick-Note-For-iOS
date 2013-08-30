//
//  YXItemListController.m
//  QuickNote
//
//  Created by Yixi Liu on 13-7-18.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <PXEngine/PXEngine.h>
#import <QuartzCore/QuartzCore.h>
#import "YXItemListController.h"
#import "YXItemCell.h"
#import "YXNoteDetailViewController.h"
#import "YXDB.h"
#import "YXAppDelegate.h"
#import "YXUtil.h"

@interface YXItemListController ()

@end

@implementation YXItemListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initView{
    self = [super initWithNibName:@"YXItemListController" bundle:nil];
    if(self){
        self.testData = [[YXDB alloc] getAllNotes];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

//    NSDictionary *row1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"HSIUX city by dan christoffenrson",@"title",@"diigo job",@"tags",nil];
//    NSDictionary *row2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"following line to display",@"title",@"ios",@"tags",nil];
//
//    self.testData = [[NSArray alloc] initWithObjects:row1,row2, nil];

    self.testData = [[YXDB alloc] getAllNotes];


    [self refreshTitle];

    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"Setting"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(setting:)];
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
//                                                                  style:UIBarButtonItemStyleBordered
//                                                                 target:self
//                                                                 action:@selector(addNote:)];

    self.navigationItem.leftBarButtonItem = settingButton;

//    self.navigationItem.rightBarButtonItem = addButton;

    UIView *newNote = [[UIView alloc] initWithFrame:CGRectMake(275, 20, 37, 53)];

//    UIImage *newNoteImg = [self scaleToSize:[UIImage imageNamed:@"addbutton.png"] size:newNote.bounds.size];
//    newNote.backgroundColor = [UIColor colorWithPatternImage:newNoteImg];
    newNote.layer.contents = (id)[UIImage imageNamed:@"addbutton.png"].CGImage;
    newNote.userInteractionEnabled = YES;
    newNote.tag  = 1000;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNote:)];
    [newNote addGestureRecognizer:tapGesture];

    [self.navigationController.view addSubview:newNote];



    UIImage *navbar_bg = [UIImage imageNamed:@"navbarbg.png"];
    CGSize titlesize = self.navigationController.navigationBar.bounds.size;
    navbar_bg = [[YXUtil alloc] scaleToSize:navbar_bg size:titlesize];
    [self.navigationController.navigationBar setBackgroundImage:navbar_bg forBarMetrics:UIBarMetricsDefault];

}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView *addView = [self.navigationController.view viewWithTag:1000];
    addView.hidden = NO;
    [self reloadData];
}

- (void)reloadData{
    self.testData = [[YXDB alloc] getAllNotes];
    [self.tableView reloadData];
    [self refreshTitle];
}



- (void)setting:(id)sender{
    NSLog(@"Setting button click");
    [(YXAppDelegate *)[[UIApplication sharedApplication] delegate] makeSettingViewVisible];
    [self moveToRightSide];
}

- (void)resotreViewLocation{
    viewIsOutOfStage = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.navigationController.view.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
                     } completion:^(BOOL finished){
        UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:1024];
        [overView removeFromSuperview];
    }];
}

- (void)moveToRightSide{
    viewIsOutOfStage = YES;
    [self animateHomeViewToSide:CGRectMake(270.0f,
            self.navigationController.view.frame.origin.y,
            self.navigationController.view.frame.size.width,
            self.navigationController.view.frame.size.height)];
}

- (void)animateHomeViewToSide:(CGRect)newViewRect{
    [UIView animateWithDuration:0.2
                    animations:^{
                        self.navigationController.view.frame = newViewRect;
                    } completion:^(BOOL finished){
                        UIControl *overView = [[UIControl alloc] init];
                        overView.tag = 1024;
                        overView.backgroundColor = [UIColor clearColor];
                        overView.frame = self.navigationController.view.frame;
                        [overView addTarget:self action:@selector(resotreViewLocation) forControlEvents:UIControlEventTouchDown];
                        [[[UIApplication sharedApplication] keyWindow] addSubview:overView];
                    }];
}

- (void)addNote:(id)sender{
    NSLog(@"Add Note");
    NSDictionary *newInsertnote = [[YXDB alloc] insertNewNote:@"New Note" tag:@"" desc:@""];
    if(!_testData){
        _testData = [[NSMutableArray alloc] init];
    }
    [_testData insertObject:newInsertnote atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self refreshTitle];
}

- (void)refreshTitle{
    self.title = [[NSString alloc] initWithFormat:@"%d Notes",[self.testData count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.testData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemListCellIdentifier";
    static BOOL nibsRegistered = NO;
    if(!nibsRegistered){
        UINib *nib = [UINib nibWithNibName:@"YXItemCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }

    YXItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [self.testData objectAtIndex:row];

    cell.title = [rowData objectForKey:@"title"];
    cell.tags = [rowData objectForKey:@"tags"];
    cell.datetime = [rowData objectForKey:@"updated"];
    
    // Configure the cell...
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data sourc
        NSDictionary *currentNote = _testData[indexPath.row];
        [[YXDB alloc] deleteNoteById:[[currentNote objectForKey:@"id"] intValue]];
        [_testData removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self refreshTitle];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if(!self.noteDetailViewController){
        self.noteDetailViewController = [[YXNoteDetailViewController alloc] initWithNibName:@"YXNoteDetailViewController" bundle:nil];
    }
    NSDictionary *currentNote = _testData[indexPath.row];
    self.noteDetailViewController.noteid = [[currentNote objectForKey:@"id"] intValue];
//    NSLog(@"hit");
    [self.navigationController pushViewController:self.noteDetailViewController animated:YES];
    UIView *addView = [self.navigationController.view viewWithTag:1000];
    addView.hidden = YES;
}



@end
