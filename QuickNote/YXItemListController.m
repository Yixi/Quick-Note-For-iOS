//
//  YXItemListController.m
//  QuickNote
//
//  Created by Yixi Liu on 13-7-18.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXItemListController.h"
#import "YXItemCell.h"
#import "YXNoteDetailViewController.h"
#import "YXDB.h"

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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(addNote:)];
    self.navigationItem.leftBarButtonItem = settingButton;
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData{
    self.testData = [[YXDB alloc] getAllNotes];
    [self.tableView reloadData];
    [self refreshTitle];
}

- (void)setting:(id)sender{
    NSLog(@"Setting button click");
}

- (void)addNote:(id)sender{
    NSLog(@"Add Note");
    NSDictionary *newInsertnote = [[YXDB alloc] insertNewNote:@"New Note" tag:@"ios" desc:@""];
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
}

@end
