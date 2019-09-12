//
//  DBManager.h
//  SQLTest
//
//  Created by Dzmitry Noska on 9/12/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject
+ (instancetype) sharedDBManager;
- (NSString *) dataBasePath;
@end

