//
//  YXTrashListViewController.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-30.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXTrashListViewController.h"
#import "YXItemCell.h"
#import "YXTrashDetailController.h"
#import "YXAppDelegate.h"

@interface YXTrashListViewController ()

@end

@implementation YXTrashListViewController


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
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"Setting"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(setting)];
    self.navigationItem.leftBarButtonItem = settingButton;


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setting{
    NSLog(@"setting hehe");
    [(YXAppDelegate *)[[UIApplication sharedApplication] delegate] makeSettingViewVisible];
    [self moveToRightSide];
}


#pragma mark - UI

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
        [overView addTarget:self action:@selector(restoreViewLocation) forControlEvents:UIControlEventTouchDown];
        [[[UIApplication sharedApplication] keyWindow] addSubview:overView];
    }];
}

- (void)restoreViewLocation{
    viewIsOutOfStage = NO;
    [UIView animateWithDuration:0.3
            animations:^{
                self.navigationController.view.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
            } completion:^(BOOL finished){
        UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:1024];
        [overView removeFromSuperview];
    }];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.NoteList count];
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
    if(!cell){
        UINib *nib = [UINib nibWithNibName:@"YXItemCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }

    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [self.NoteList objectAtIndex:row];

    cell.title = [rowData objectForKey:@"title"];
    cell.tags = [rowData objectForKey:@"tags"];
    cell.datetime = [rowData objectForKey:@"updated"];

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    if(!self.trashDetailViewController){
        self.trashDetailViewController = [[YXTrashDetailController alloc] initWithNibName:@"YXTrashDetailController" bundle:nil];
    }
    NSDictionary *currentNote = self.NoteList[indexPath.row];
    self.trashDetailViewController.noteid = [[currentNote objectForKey:@"id"] intValue];
    self.trashDetailViewController.folder = self.folder;

    [self.navigationController pushViewController:self.trashDetailViewController animated:YES];


}

@end
