//
//  YXNoteModel.h
//  QuickNote
//
//  Created by Yixi Liu on 13-8-20.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXNoteModel : NSObject

@property NSInteger noteid;
@property (retain)NSString *title;
@property (retain)NSString *desc;
@property (retain)NSString *tag;
@property (retain)NSString *list;
@property (retain)NSString *created;
@property (retain)NSString *updated;

- (id)initForList;
- (id)initForNote;
@end
