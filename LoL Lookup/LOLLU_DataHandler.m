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
#import "CurrentSummoner.h"
#import "FavoriteSummoner.h"
#import "RecentGame.h"

// Utilities Import
#import "Reachability.h"

#define LOL_API_KEY @"api_key=d703a62d-6193-4588-9c39-9951d0801736"

#define MASHAPE_API_KEY_TESTING @"NX13aC5xJmmshfYmFrV4MV7j4qrgp1zZ22OjsnYJar1c7BkNeq"

#define MASHAPE_API_KEY_PRODUCTION @"3sHiFRz34ymshXwMZsKYj3LVqT1op1GziAFjsnZ0KLiKL23DI4"

#define BASE_URL @"https://na.api.pvp.net/api/lol/"

#define MASHAPE_BASE_URL @"https://community-league-of-legends.p.mashape.com/api/v1.0/"

#define SUMMONER_INFO @"/v1.4/summoner/by-name/"

#define RECENT_GAMES @"/v1.3/game/by-summoner/"

#define CURRENT_GAME_INFO @"/summoner/retrieveInProgressSpectatorGameInfo/"

// SUMMONER_URL
// na.api.pvp.net/api/lol/{region}/v1.4/summoner/by-name/{summoner_name}?api_key={api_key}

// ALL_CHAMPIONS
// na.api.pvp.net/api/lol/static-data/{region}/v1.2/champion

// RECENT_GAMES
// na.api.pvp.net/api/lol/{region}/v1.3/game/by-summoner/{summoner_id}/recent

// CURRENT_GAME_INFO
// community-league-of-legends.p.mashape.com/api/v1.0/{region}/summoner/retrieveInProgressSpectatorGameInfo/{Summonername}

@implementation LOLLU_DataHandler
{
	CoreDataHandler *coreDataHandler;
	Reachability *internetReachable;
}

- (BOOL)getSummonerInfoByRegion:(NSString *)region andSummonerName:(NSString *)summonerName
{
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	coreDataHandler = [[CoreDataHandler alloc] init];
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@?%@", BASE_URL, region, SUMMONER_INFO, summonerName, LOL_API_KEY];
    NSString *encodedURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSLog(@"URL STRING: %@", encodedURLString);
    NSURL *url = [NSURL URLWithString:encodedURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil ];
	NSDictionary *summonerFullDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
	NSLog(@"%@", summonerFullDict);
	if ([summonerFullDict count] > 0) {
		[coreDataHandler clearEntity:@"CurrentSummoner" withFetchRequest:_fetchRequest];
		NSDictionary *summonerInfo = [summonerFullDict objectForKey:[summonerName lowercaseString]];
		CurrentSummoner *newSummoner = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentSummoner" inManagedObjectContext:[self managedObjectContext]];
		newSummoner.summonerID = [summonerInfo objectForKey:@"id"];
		newSummoner.summonerName = [summonerInfo objectForKey:@"name"];
		newSummoner.summonerLevel = [summonerInfo objectForKey:@"summonerLevel"];
		newSummoner.iconID = [summonerInfo objectForKey:@"profileIconId"];
		[self.managedObjectContext save:nil];
		_canSegue = TRUE;
	} else {
		_canSegue = FALSE;
	}
	NSLog(@"CAN IT?: %d", _canSegue);
	return _canSegue;
}

- (void)getRecentGamesByRegion:(NSString *)region andSummonerID:(int)summonerID
{
	NSLog(@"MADE IT 3");
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	_fetchRequest = [[NSFetchRequest alloc] init];
	_entity = [NSEntityDescription entityForName:@"CurrentSummoner" inManagedObjectContext:[self managedObjectContext]];
	_predicate = [NSPredicate predicateWithFormat:@"summonerID = %d", summonerID];
	
	[_fetchRequest  setEntity:_entity];
	[_fetchRequest setPredicate:_predicate];
	
	NSError *error;
	NSArray *fetchedObject = [[self managedObjectContext] executeFetchRequest:_fetchRequest error:&error];
	
	CurrentSummoner *currentSummoner = [fetchedObject objectAtIndex:0];
	
	coreDataHandler = [[CoreDataHandler alloc] init];
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@%d/recent?%@", BASE_URL, region, RECENT_GAMES, summonerID, LOL_API_KEY];
    NSString *encodedURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSLog(@"URL STRING: %@", encodedURLString);
    NSURL *url = [NSURL URLWithString:encodedURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
	
	// Use Main thread to download inventory data
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
		 if (data.length > 0 && connectionError == nil)
		 {
			 [coreDataHandler clearEntity:@"RecentGame" withFetchRequest:_fetchRequest];
			 
			 NSDictionary *recentGames = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
			 NSDictionary *games = [recentGames objectForKey:@"games"];
			 NSLog(@"GAMES: %@", games);
			 for (NSDictionary *game in games) {
				 RecentGame *newGame = [NSEntityDescription insertNewObjectForEntityForName:@"RecentGame" inManagedObjectContext:[self managedObjectContext]];
				 newGame.gameID = [game objectForKey:@"gameId"];
				 NSDictionary *gameStats = [game objectForKey:@"stats"];
				 newGame.minionsKilled = [gameStats objectForKey:@"minionsKilled"];
				 newGame.numberOfChampionKills = [gameStats objectForKey:@"championsKilled"];
				 newGame.numberOfDeaths = [gameStats objectForKey:@"numDeaths"];
				 newGame.turretsKilled = [gameStats objectForKey:@"turretsKilled"];
				 newGame.wardsPlaced = [gameStats objectForKey:@"wardPlaced"];
				 newGame.win = [gameStats objectForKey:@"win"];
				 [currentSummoner addRecentGameObject:newGame];
				 [newGame setValue:currentSummoner forKeyPath:@"summoner"];
			 }
		 }
		 [self.managedObjectContext save:nil];
     }];
}

- (void)getCurrentGameInfoByRegion:(NSString *)region andSummonerName:(NSString *)summonerName
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", MASHAPE_BASE_URL, region, CURRENT_GAME_INFO, summonerName];
    NSString *encodedURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSDictionary *headers = @{@"X-Mashape-Key": MASHAPE_API_KEY_TESTING};
    NSURL *url = [NSURL URLWithString:encodedURLString];
    NSLog(@"%@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSDictionary *currentGameInfoDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSLog(@"%@", currentGameInfoDict);
}

@end
