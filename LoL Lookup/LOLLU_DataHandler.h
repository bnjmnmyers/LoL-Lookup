//
//  LOLLU_DataHandler.h
//  LoL Lookup
//
//  Created by Benjamin Myers on 7/10/14.
//  Copyright (c) 2014 appguys.biz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LOLLU_DataHandler : NSObject <NSURLConnectionDataDelegate>

// CoreData Properties
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSEntityDescription *entity;
@property (nonatomic, strong) NSFetchedResultsController *fetchedInventoryController;
@property (nonatomic, strong) NSSortDescriptor *sort;
@property (nonatomic, strong) NSSortDescriptor *secondSort;
@property (nonatomic, strong) NSArray *sortDescriptors;
@property (nonatomic, strong) NSPredicate *predicate;


// Public Methods
- (void)getSummonerInfoByRegion:(NSString *)region summonerName:(NSString *)summonerName;
@end
