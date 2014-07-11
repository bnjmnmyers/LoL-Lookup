//
//  RecentGame.h
//  LoL Lookup
//
//  Created by Benjamin Myers on 7/11/14.
//  Copyright (c) 2014 appguys.biz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CurrentSummoner, FavoriteSummoner;

@interface RecentGame : NSManagedObject

@property (nonatomic, retain) NSNumber * championID;
@property (nonatomic, retain) NSNumber * gameID;
@property (nonatomic, retain) NSString * gameType;
@property (nonatomic, retain) NSNumber * minionsKilled;
@property (nonatomic, retain) NSNumber * numberOfChampionKills;
@property (nonatomic, retain) NSNumber * numberOfDeaths;
@property (nonatomic, retain) NSNumber * numberOfMinionKills;
@property (nonatomic, retain) NSNumber * wardsPlaced;
@property (nonatomic, retain) NSNumber * win;
@property (nonatomic, retain) NSNumber * turretsKilled;
@property (nonatomic, retain) CurrentSummoner *summoner;
@property (nonatomic, retain) FavoriteSummoner *favorite;

@end
