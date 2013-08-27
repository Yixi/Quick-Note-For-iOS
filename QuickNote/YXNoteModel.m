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

- (NSDictionary *)buildForList {
    NSDictionary *row;
    NSString *noteId = [NSString stringWithFormat:@"%d",self.noteid];
    NSString *title = self.title;
    NSString *tag = self.tag;
    NSString *updated = self.updated;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *day = [df dateFromString:updated];
    df.dateFormat = @"MMM d";
    updated = [df stringFromDate:day];
    row =  [[NSDictionary alloc] initWithObjectsAndKeys:noteId,@"id",title,@"title",tag,@"tags",updated,@"updated",nil];
    return row;
}

-(NSDictionary *)buildForNote {
    NSDictionary *row;
    NSString *noteId = [NSString stringWithFormat:@"%d",self.noteid];
    row = [[NSDictionary alloc] initWithObjectsAndKeys:noteId,@"id",_title,@"title",_tag,@"tags",_desc,@"desc",_list,@"list",_created,@"created",_updated,@"updated", nil];
    return row;
}

@end
