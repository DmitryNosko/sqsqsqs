//
//  FeedItemService.m
//  SQLTest
//
//  Created by Dzmitry Noska on 9/12/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FeedItemService.h"
#import "FeedItemRepository.h"

@interface FeedItemService()
@property (strong, nonatomic) FeedItemRepository* feedItemRepository;
@end

@implementation FeedItemService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _feedItemRepository = [FeedItemRepository sharedFeedItemRepository];
    }
    return self;
}

- (NSMutableArray<FeedItem *>*) cleanSaveFeedItems:(NSMutableArray<FeedItem *>*) items {
    [self.feedItemRepository removeAllFeedItems];
    NSMutableArray<FeedItem *>* createdItems = [self.feedItemRepository addFeedItems:items];
    return createdItems;
}

- (FeedItem *) addFeedItem:(FeedItem *) item {
    return [self.feedItemRepository addFeedItem:item];
}

- (NSMutableArray<FeedItem *> *) addFeedItems:(NSMutableArray<FeedItem *>*) items {
    return [self.feedItemRepository addFeedItems:items];
}

- (NSMutableArray<FeedItem *>*) feedItems {
    return [self.feedItemRepository feedItems];
}

- (void)updateFeedItem:(FeedItem *)item {
    [self.feedItemRepository updateFeedItem:item];
}

- (void) removeFeedItem:(FeedItem *) item {
    [self.feedItemRepository removeFeedItem:item];
}

@end
