//
//  YXTrashController.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-30.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXTrashController.h"
#import "YXDB.h"
@interface YXTrashController ()

@end

@implementation YXTrashController


- (id)initView {
    self = [super initWithNibName:@"YXTrashListViewController" bundle:nil];
    self.NoteList = [[YXDB alloc] getTrashNotes];

    UIBarButtonItem *emptyButton = [[UIBarButtonItem alloc] initWithTitle:@"empty"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(emptyTrashClick)];

    self.navigationItem.rightBarButtonItem = emptyButton;


    if(self){
        self.title = [NSString stringWithFormat:@"Trash(%d)",self.NoteList.count];
    }
    return self;
}

- (void)emptyTrashClick{
    NSLog(@"emptyTrash");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"clear trash"
                                                    message:@"Delete all notes in trash?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok",nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==1){
        [[YXDB alloc] emptyTrash];
        self.NoteList = [[YXDB alloc] getTrashNotes];
        [self.tableView reloadData];
        self.title = [NSString stringWithFormat:@"Trash(%d)",self.NoteList.count];
    }
}

@end
