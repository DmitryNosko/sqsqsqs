//
//  FeedItemRepository.h
//  SQLTest
//
//  Created by USER on 9/11/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"
#import <sqlite3.h>

@interface FeedItemRepository : NSObject {
    sqlite3* rssDataBase;
}

+ (instancetype) sharedFeedItemRepository;
- (FeedItem *) addFeedItem:(FeedItem *) item;
- (NSMutableArray<FeedItem *> *) addFeedItems:(NSMutableArray<FeedItem *>*) items;
- (NSMutableArray<FeedItem *>*) feedItems;
- (void) updateFeedItem:(FeedItem *) item;
- (void) removeFeedItem:(FeedItem *) item;
- (void) removeAllFeedItems;
@end
