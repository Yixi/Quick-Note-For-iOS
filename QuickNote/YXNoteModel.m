//
//  YXNoteModel.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-20.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXNoteModel.h"

@implementation YXNoteModel


- (id)init{
    if(self=[super init]){
        
    }
    return self;
}

- (id)initForList {
    NSDictionary *row;
    NSString *noteId = [NSString stringWithFormat:@"%d",self.noteid];
    NSString *title = self.title;
    NSString *tag = self.tag;
    NSString *updated = self.updated;
    row =  [[NSDictionary alloc] initWithObjectsAndKeys:noteId,@"id",title,@"title",tag,@"tags",updated,@"updated",nil];
    return row;
}

-(id)initForNote {
    NSDictionary *row;
    NSString *noteId = [NSString stringWithFormat:@"%d",self.noteid];
    row = [[NSDictionary alloc] initWithObjectsAndKeys:noteId,@"id",_title,@"title",_tag,@"tags",_desc,@"desc",_list,@"list",_created,@"created",_updated,@"updated", nil];
    return row;
}

@end
