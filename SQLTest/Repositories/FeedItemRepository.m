//
//  FeedItemRepository.m
//  SQLTest
//
//  Created by USER on 9/11/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FeedItemRepository.h"
#import "DBManager.h"

@interface FeedItemRepository()
@property (strong, nonatomic) NSDateFormatter* dateFormatter;
@end

static NSString* const INSERT_FEEDITEM = @"INSERT INTO FeedItem (itemTitle, link, pubDate, itemDescription, enclousure, imageURL, isFavorite, isReaded, isAvailable, resourceURL, resourceID) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")";
static NSString* const UPDATE_FEEDITEM = @"UPDATE FeedItem SET isFavorite = \"%@\", isReaded = \"%@\", isAvailable = \"%@\" WHERE ID = \"%@\"";
static const char* SELECT_FEEDITEM = "SELECT fi.ID, fi.itemTitle, fi.link, fi.pubDate, fi.itemDescription, fi.enclousure, fi.imageURL, fi.isFavorite, fi.isReaded, fi.isAvailable, fi.resourceURL, fr.ID, fr.name, fr.url FROM FeedItem AS fi JOIN FeedResource AS fr ON fi.resourceID = fr.ID;";
static NSString* const DELETE_FEEDITEM = @"DELETE FROM FeedItem WHERE FeedItem.id = \"%@\"";
static const char* DELETE_ALL_FEEDITEMS = "DELETE FROM FeedItem";

@implementation FeedItemRepository

static FeedItemRepository* shared;

+(instancetype) sharedFeedItemRepository {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [FeedItemRepository new];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
        [_dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    }
    return self;
}

#pragma mark - FeedItem Requests

- (FeedItem *) addFeedItem:(FeedItem *) item {
    
    sqlite3_stmt *statement;
    const char *dbpath = [[[DBManager sharedDBManager] dataBasePath] UTF8String];
    
    if (sqlite3_open(dbpath, &rssDataBase) == SQLITE_OK) {
        
        NSString *insertFeedItem = [NSString stringWithFormat:INSERT_FEEDITEM,
                                    item.itemTitle,
                                    item.link,
                                    item.pubDate,
                                    item.itemDescription,
                                    item.enclosure,
                                    item.imageURL,
                                    @(item.isFavorite),
                                    @(item.isReaded),
                                    @(item.isAvailable),
                                    item.resourceURL,
                                    @(item.resource.identifier)
                                    ];
        const char *insertStatement = [insertFeedItem UTF8String];
        
        sqlite3_prepare_v2(rssDataBase, insertStatement, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSInteger lastRowID = sqlite3_last_insert_rowid(rssDataBase);
            item.identifier = lastRowID;
            NSLog(@"FeedItem added with lastRowID = %@", @(lastRowID));
        } else {
            NSLog(@"Failed to add FeedItem by insertStatement = %@", @(insertStatement));
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(rssDataBase);
    }
    
    return item;
}

- (NSMutableArray<FeedItem *> *) addFeedItems:(NSMutableArray<FeedItem *>*) items {
    
    NSMutableArray<FeedItem *>* resultItems = [[NSMutableArray alloc] init];
    for (FeedItem* item in items) {
        [resultItems addObject:[self addFeedItem:item]];
    }
    
    return resultItems;
}

- (void) updateFeedItem:(FeedItem *) item {
    
    sqlite3_stmt *statement;
    
    const char *dbpath = [[[DBManager sharedDBManager] dataBasePath] UTF8String];
    
    if (sqlite3_open(dbpath, &rssDataBase) == SQLITE_OK) {
        
        NSString *updateFeedItem = [NSString stringWithFormat:UPDATE_FEEDITEM, @(item.isFavorite), @(item.isReaded), @(item.isAvailable), @(item.identifier)];
        const char *updateStatement = [updateFeedItem UTF8String];
        
        sqlite3_prepare_v2(rssDataBase, updateStatement, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_reset(statement);
            NSLog(@"Success to update FeedItem by updateStatement = %@", @(updateStatement));
        } else {
            NSLog(@"Failed to update FeedItem by updateStatement = %@", @(updateStatement));
        }
    }
}

- (NSMutableArray<FeedItem *>*) feedItems {
    
    const char *dbpath = [[[DBManager sharedDBManager] dataBasePath] UTF8String];
    sqlite3_stmt *statement;
    NSMutableArray<FeedItem *>* resources = [NSMutableArray array];
    
    if (sqlite3_open(dbpath, &rssDataBase) == SQLITE_OK) {
        
        if (sqlite3_prepare_v2(rssDataBase, SELECT_FEEDITEM, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSInteger itemID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)].integerValue;
                NSString *itemTitle = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSMutableString* link = [[NSMutableString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSDate *pubDate = [self dateFromString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)]];
                NSMutableString *itemDescription = [[NSMutableString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *enclousure = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *imageURL = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                BOOL isFavorite = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)] boolValue];
                BOOL isReaded = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)] boolValue];
                BOOL isAvailable = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)] boolValue];
                NSURL *resourceURL = [NSURL URLWithString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)]];
                
                NSInteger resourceID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)].integerValue;
                NSString *resourceName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                NSURL *resURL = [NSURL URLWithString:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)]];
                
                FeedResource* resource = [[FeedResource alloc] initWithID:resourceID name:resourceName url:resURL];
                FeedItem* item = [[FeedItem alloc] initWithID:itemID
                                                    itemTitle:itemTitle
                                                         link:link
                                                      pubDate:pubDate
                                              itemDescription:itemDescription
                                                    enclosure:enclousure
                                                     imageURL:imageURL
                                                   isFavorite:isFavorite
                                                     isReaded:isReaded
                                                  isAvailable:isAvailable
                                                  resourceURL:resourceURL
                                                     resource:resource];
                [resources addObject:item];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(rssDataBase);
    }
    
    return resources;
}

- (void) removeFeedItem:(FeedItem *) item {
    
    const char *dbpath = [[[DBManager sharedDBManager] dataBasePath] UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &rssDataBase) == SQLITE_OK) {
        
        const char *deleteStatement = [[NSString stringWithFormat:DELETE_FEEDITEM, @(item.identifier)] UTF8String];

        sqlite3_prepare_v2(rssDataBase, deleteStatement, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"FeedItem removed by id = %@", @(item.identifier));
        } else {
            NSLog(@"Failed to remove FeedItem by id = %@", @(item.identifier));
        }
        sqlite3_finalize(statement);
        sqlite3_close(rssDataBase);
    }
    
}

- (void) removeAllFeedItems {
    
    const char *dbpath = [[[DBManager sharedDBManager] dataBasePath] UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &rssDataBase) == SQLITE_OK) {
        
        sqlite3_prepare_v2(rssDataBase, DELETE_ALL_FEEDITEMS, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"FeedItems removed");
        } else {
            NSLog(@"Failed to remove all FeedItems");
        }
        sqlite3_finalize(statement);
        sqlite3_close(rssDataBase);
    }
}

- (NSDate *) dateFromString:(NSString *) dateString {
    NSDate* date = [self.dateFormatter dateFromString:dateString];
    return date;
}

@end
