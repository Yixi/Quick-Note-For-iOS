//
//  YXDB.m
//  QuickNote
//
//  Created by Yixi Liu on 13-8-20.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import "YXDB.h"
#import "sqlite3.h"
#import "YXNoteModel.h"

#define DBFilename  @"QuickNote.db"

@implementation YXDB

- (NSString *)dbFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:DBFilename];
}

- (void)initDatabase{
    NSString *path = [self dbFilePath];
    if(sqlite3_open([path UTF8String], &dataBase)!= SQLITE_OK){
        sqlite3_close(dataBase);
        NSAssert(0, @"Failed to open database");
    }

    NSString *createNoteTable = @"CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY,title TEXT NOT NULL,desc TEXT,url TEXT,list TEXT DEFAULT '',tag TEXT,lastSyncHash TEXT,updated DATETIME DEFAULT CURRENT_TIMESTAMP,created DATETIME DEFAULT CURRENT_TIMESTAMP);";
    char *errorMsg;
    if(sqlite3_exec(dataBase, [createNoteTable UTF8String], NULL, NULL, &errorMsg)!= SQLITE_OK){
        sqlite3_close(dataBase);
        NSAssert(0,@"Error createing table: %s", errorMsg);
    }
    NSString *createDiigoTable = @"CREATE TABLE IF NOT EXISTS diigo (id INTEGER PRIMARY KEY, local_id INTEGER, server_id INTEGER DEFAULT -1, server_created_at DATETIME DEFAULT -1, server_updated_at DATETIME DEFAULT -1,user_id INTEGER DEFAULT -1, mode INTEGER DEFAULT 2, sync_flag SMALLINT(2) DEFAULT 0,FOREIGN KEY(local_id) REFERENCES notes(id));";
    if(sqlite3_exec(dataBase, [createDiigoTable UTF8String], NULL, NULL, &errorMsg)!= SQLITE_OK){
        sqlite3_close(dataBase);
        NSAssert(0,@"Error createing table: %s", errorMsg);
    }
    NSString *createDBTrigger = @"CREATE TRIGGER IF NOT EXISTS note_updated AFTER UPDATE OF title, desc, url, list, tag ON notes BEGIN UPDATE notes SET updated = DATETIME() WHERE id=OLD.id AND (OLD.title<>NEW.title OR OLD.desc<>NEW.desc OR OLD.url<>NEW.url OR OLD.list<>NEW.list OR OLD.tag<>NEW.tag);UPDATE diigo SET sync_flag=0 WHERE local_id = OLD.id;END;";
    if(sqlite3_exec(dataBase, [createDBTrigger UTF8String], NULL, NULL, &errorMsg)!= SQLITE_OK){
        sqlite3_close(dataBase);
        NSAssert(0,@"Error createing trigger: %s", errorMsg);
    }
    //listen notes insert
    NSString *createDiigoTrigger = @"CREATE TRIGGER IF NOT EXISTS diigo_insert AFTER INSERT ON notes BEGIN INSERT INTO diigo (local_id, server_created_at, server_updated_at) VALUES (NEW.id, NEW.created, NEW.updated);END;";
    if(sqlite3_exec(dataBase,[createDiigoTrigger UTF8String],NULL,NULL,&errorMsg)!= SQLITE_OK){
        sqlite3_close(dataBase);
        NSAssert(0,@"Error createing trigger: %s", errorMsg);
    }
    //listen notes delete
    NSString *createDeleteDiigoTrigger = @"CREATE TRIGGER IF NOT EXISTS diigo_delete AFTER DELETE ON notes BEGIN DELETE FROM diigo WHERE local_id = OLD.id;END;";
    if(sqlite3_exec(dataBase, [createDeleteDiigoTrigger UTF8String], NULL, NULL, &errorMsg)!= SQLITE_OK){
        sqlite3_close(dataBase);
        NSAssert(0,@"Error createing trigger: %s", errorMsg);
    }




    sqlite3_close(dataBase);
}

#pragma mark - Database for notes

- (NSMutableArray *)getAllNotes {
    NSMutableArray *sqlArray = [[NSMutableArray alloc] init];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    if(sqlite3_open([[self dbFilePath] UTF8String], &dataBase)!= SQLITE_OK){
        sqlite3_close(dataBase);
        NSAssert(0, @"Failed to open database");
    }

//    char *insertTestData = "INSERT INTO notes (title,tag) values(?,?);";
//    sqlite3_stmt *stmt;
//    if(sqlite3_prepare_v2(dataBase, insertTestData, -1, &stmt, nil) == SQLITE_OK){
//        sqlite3_bind_text(stmt, 1, "Test note", -1, NULL);
//        sqlite3_bind_text(stmt, 2, "diigo job", -1, NULL);
//    }
//    if(sqlite3_step(stmt)!= SQLITE_DONE){
//        //        NSAssert(0,@"Error insert data %s",errorMsg);
//        NSLog(@"error insert data");
//    }


    NSString *getAllNotesQuery = @"SELECT id,title,tag,updated FROM notes WHERE list=''";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(dataBase, [getAllNotesQuery UTF8String], -1, &stmt, nil) == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW){
            YXNoteModel *note = [[YXNoteModel alloc]init];
            note.noteid = sqlite3_column_int(stmt, 0);
            char *titleData = (char *)sqlite3_column_text(stmt, 1);
            note.title = [[NSString alloc] initWithUTF8String:titleData];
            char *tagData = (char *)sqlite3_column_text(stmt, 2);
            note.tag = [[NSString alloc] initWithUTF8String:tagData];
            char *updateData = (char *)sqlite3_column_text(stmt, 3);
            note.updated = [[NSString alloc] initWithUTF8String:updateData];

//            NSDictionary *row = [[NSDictionary alloc] initWithObjectsAndKeys:note.title,@"title",note.tag,@"tags",note.updated,@"updated",nil];

//            [sqlArray addObject:[note initForList]];
            [sqlArray insertObject:[note initForList] atIndex:0];
        }
    }
    returnArray = [sqlArray mutableCopy];
    return returnArray;
}

- (id)insertNewNote:(NSString *)title tag:(NSString *)tag desc:(NSString *)desc {

    if(sqlite3_open([[self dbFilePath] UTF8String], &dataBase)!= SQLITE_OK){
        sqlite3_close(dataBase);
        NSAssert(0, @"Failed to open database");
    }

    char *insertNewNoteQuery = "INSERT INTO notes(title,tag,desc) VALUES(?,?,?);";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(dataBase, insertNewNoteQuery, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [title UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [tag UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [desc UTF8String], -1, NULL);
    }
    if(sqlite3_step(stmt)!= SQLITE_DONE){
        //        NSAssert(0,@"Error insert data %s",errorMsg);
        NSLog(@"error insert data");
    }

    sqlite3_int64 noteid = sqlite3_last_insert_rowid(dataBase);
    NSInteger pid = (NSInteger)noteid;
    sqlite3_finalize(stmt);
    sqlite3_close(dataBase);

    NSDictionary *note = [self LoadNoteWithId:pid];

    return note;
}

- (id)LoadNoteWithId:(NSInteger)noteid {
    NSDictionary *newnote;

    if(sqlite3_open([[self dbFilePath] UTF8String], &dataBase)!= SQLITE_OK){
        sqlite3_close(dataBase);
        NSAssert(0, @"Failed to open database");
    }

    NSString *SelectNoteQuery = [NSString stringWithFormat:@"SELECT id,title,desc,list,tag,updated,created FROM notes WHERE id=%d;",noteid];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(dataBase, [SelectNoteQuery UTF8String], -1, &stmt, nil) == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW){
            YXNoteModel *note = [[YXNoteModel alloc] init];
            note.noteid = sqlite3_column_int(stmt, 0);
            note.title = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 1)];
            note.desc = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 2)];
            note.list = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 3)];
            note.tag = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 4)];
            note.updated = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 5)];
            note.created = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 6)];

            newnote = [note initForNote];
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(dataBase);
    return newnote;
}

- (void)SaveNote:(NSInteger)noteid title:(NSString *)title desc:(NSString *)desc tag:(NSString *)tag {
    if(sqlite3_open([[self dbFilePath] UTF8String], &dataBase)!= SQLITE_OK){
        sqlite3_close(dataBase);
        NSAssert(0, @"Failed to open database");
    }
    sqlite3_stmt *stmt;

    char *updateNoteQuery = "UPDATE notes SET title=?,desc=?,tag=? WHERE id=?;";
    if(sqlite3_prepare_v2(dataBase, updateNoteQuery, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [title UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [desc UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [tag UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 4, noteid);
    }
    if(sqlite3_step(stmt)!= SQLITE_DONE){
        NSLog(@"Error update data");
    }


    sqlite3_finalize(stmt);
    sqlite3_close(dataBase);
}



@end

