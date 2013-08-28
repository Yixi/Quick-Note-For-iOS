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
    updated = [self formatDate:updated];
    row =  [[NSDictionary alloc] initWithObjectsAndKeys:noteId,@"id",title,@"title",tag,@"tags",updated,@"updated",nil];
    return row;
}

-(NSDictionary *)buildForNote {
    NSDictionary *row;
    NSString *noteId = [NSString stringWithFormat:@"%d",self.noteid];
    NSString *updated = [self formatDate:_updated];
    row = [[NSDictionary alloc] initWithObjectsAndKeys:noteId,@"id",_title,@"title",_tag,@"tags",_desc,@"desc",_list,@"list",_created,@"created",updated,@"updated", nil];
    return row;
}

-(NSString *)formatDate:(NSString *)date{
    //data format 2012-08-24 11:00:00;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *day = [df dateFromString:date];
    df.dateFormat = @"MMM d";
    return [df stringFromDate:day];
}

@end
