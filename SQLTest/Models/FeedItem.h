//
//  FeedItem.h
//  SQLTest
//
//  Created by Dzmitry Noska on 9/11/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedResource.h"

@interface FeedItem : NSObject
@property (assign, nonatomic) NSInteger identifier;
@property (strong, nonatomic) NSString* itemTitle;
@property (strong, nonatomic) NSMutableString* link;
@property (strong, nonatomic) NSDate* pubDate;
@property (strong, nonatomic) NSMutableString* itemDescription;
@property (strong, nonatomic) NSString* enclosure;
@property (strong, nonatomic) NSString* imageURL;
@property (assign, nonatomic) BOOL isFavorite;
@property (assign, nonatomic) BOOL isReaded;
@property (assign, nonatomic) BOOL isAvailable;
@property (strong, nonatomic) NSURL* resourceURL;
@property (strong, nonatomic) FeedResource* resource;

- (instancetype)initWithID:(NSInteger) identifier itemTitle:(NSString *) itemTitle link:(NSMutableString *) link pubDate:(NSDate *) pubDate itemDescription:(NSMutableString *) itemDescription enclosure:(NSString *) enclosure imageURL:(NSString *) imageURL isFavorite:(BOOL) isFavorite isReaded:(BOOL) isReaded isAvailable:(BOOL) isAvailable resourceURL:(NSURL *) resourceURL resource:(FeedResource *) resource;
@end;
