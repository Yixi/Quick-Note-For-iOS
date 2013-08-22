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
//    NSString *noteId =(NSString *)self.noteid;
    NSString *title = self.title;
    NSString *tag = self.tag;
    NSString *updated = self.updated;
    row =  [[NSDictionary alloc] initWithObjectsAndKeys:title,@"title",tag,@"tags",updated,@"updated",nil];
    return row;
}

@end
