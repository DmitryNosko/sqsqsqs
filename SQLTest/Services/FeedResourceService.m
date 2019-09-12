//
//  FeedResourceService.m
//  SQLTest
//
//  Created by Dzmitry Noska on 9/12/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FeedResourceService.h"
#import "FeedResourceRepository.h"

@interface FeedResourceService()
@property (strong, nonatomic) FeedResourceRepository* feedResourceRepository;
@end

@implementation FeedResourceService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _feedResourceRepository = [FeedResourceRepository sharedFeedResourceRepository];
    }
    return self;
}

- (FeedResource *) addFeedResource:(FeedResource *) resource {
    return [self.feedResourceRepository addFeedResource:resource];
}

- (void) removeFeedResource:(FeedResource *) resource {
    [self.feedResourceRepository removeFeedResource:resource];
}

- (NSMutableArray<FeedResource *>*) feedResources {
    return [self.feedResourceRepository feedResources];
}

@end
