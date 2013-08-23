//
//  YXDB.h
//  QuickNote
//
//  Created by Yixi Liu on 13-8-20.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface YXDB : NSObject
{
    sqlite3 *dataBase;
}

- (void)initDatabase;
- (NSMutableArray *)getAllNotes;
- (id)insertNewNote:(NSString *)title tag:(NSString *)tag desc:(NSString *)desc;
- (id)LoadNoteWithId:(NSInteger)noteid;
- (void)SaveNote:(NSInteger)noteid title:(NSString *)title desc:(NSString *)desc tag:(NSString *)tag;
@end
