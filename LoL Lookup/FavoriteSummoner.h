//
//  FavoriteSummoner.h
//  LoL Lookup
//
//  Created by Benjamin Myers on 7/11/14.
//  Copyright (c) 2014 appguys.biz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecentGame;

@interface FavoriteSummoner : NSManagedObject

@property (nonatomic, retain) NSNumber * summonerID;
@property (nonatomic, retain) NSNumber * summonerLevel;
@property (nonatomic, retain) NSString * summonerName;
@property (nonatomic, retain) NSNumber * iconID;
@property (nonatomic, retain) NSSet *recentGame;
@end

@interface FavoriteSummoner (CoreDataGeneratedAccessors)

- (void)addRecentGameObject:(RecentGame *)value;
- (void)removeRecentGameObject:(RecentGame *)value;
- (void)addRecentGame:(NSSet *)values;
- (void)removeRecentGame:(NSSet *)values;

@end
