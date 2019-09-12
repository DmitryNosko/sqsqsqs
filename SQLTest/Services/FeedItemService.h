//
//  FeedItemService.h
//  SQLTest
//
//  Created by Dzmitry Noska on 9/12/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

@interface FeedItemService : NSObject
- (NSMutableArray<FeedItem *>*) cleanSaveFeedItems:(NSMutableArray<FeedItem *>*) items;
- (FeedItem *) addFeedItem:(FeedItem *) item;
- (NSMutableArray<FeedItem *> *) addFeedItems:(NSMutableArray<FeedItem *>*) items;
- (NSMutableArray<FeedItem *>*) feedItems;
- (void) updateFeedItem:(FeedItem *) item;
- (void) removeFeedItem:(FeedItem *) item;
@end

