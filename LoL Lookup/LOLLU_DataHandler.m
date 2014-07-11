//
//  LOLLU_DataHandler.m
//  LoL Lookup
//
//  Created by Benjamin Myers on 7/10/14.
//  Copyright (c) 2014 appguys.biz. All rights reserved.
//

// Models Import
#import "LOLLU_DataHandler.h"
#import "CoreDataHandler.h"

// Data Import


// Utilities Import
#import "Reachability.h"

#define API_KEY @"api_key=d703a62d-6193-4588-9c39-9951d0801736"

#define BASE_URL @"https://na.api.pvp.net/api/lol/"

#define SUMMONER_INFO @"/v1.4/summoner/by-name/"

#define RECENT_GAMES @"/v1.3/game/by-summoner/"

// SUMMONER_URL
//na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/Bizawesome?api_key=d703a62d-6193-4588-9c39-9951d0801736

// ALL_CHAMPIONS
//na.api.pvp.net/api/lol/static-data/na/v1.2/champion

//RECENT_GAMES
//na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/24673152/recent

@implementation LOLLU_DataHandler
{
	CoreDataHandler *coreDataHandler;
	Reachability *internetReachable;
}

- (void)getSummonerInfoByRegion:(NSString *)region andSummonerName:(NSString *)summonerName
{
    NSLog(@"BOOM");
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	coreDataHandler = [[CoreDataHandler alloc] init];
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@?%@", BASE_URL, region, SUMMONER_INFO, summonerName, API_KEY ];
	NSLog(@"URL STRING: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
	
	// Use Main thread to download inventory data
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
		 if (data.length > 0 && connectionError == nil)
		 {
			 NSDictionary *summonerInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
			 NSLog(@"%@", summonerInfo);
		 }
    }];
}

- (void)getRecentGamesByRegion:(NSString *)region andSummonerID:(int)summonerID
{
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	coreDataHandler = [[CoreDataHandler alloc] init];
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%d/recent?%@", BASE_URL, region, RECENT_GAMES, summonerID, API_KEY];
	NSLog(@"URL STRING: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
	
	// Use Main thread to download inventory data
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
		 if (data.length > 0 && connectionError == nil)
		 {
			 NSDictionary *recentGames = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
			 NSLog(@"%@", recentGames);
		 }
     }];
}

@end
