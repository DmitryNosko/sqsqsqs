//
//  DBContextCreator.h
//  SQLTest
//
//  Created by Dzmitry Noska on 9/12/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBContextCreator : NSObject {
    sqlite3* rssDataBase;
}
- (void) createDB;
@end

