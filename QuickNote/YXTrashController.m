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
    if(self){
        self.title = [NSString stringWithFormat:@"Trash(%d)",self.NoteList.count];
    }
    return self;
}




@end
