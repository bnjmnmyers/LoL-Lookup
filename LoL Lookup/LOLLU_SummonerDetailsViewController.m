//
//  LOLLU_SummonerDetailsViewController.m
//  LoL Lookup
//
//  Created by Benjamin Myers on 7/10/14.
//  Copyright (c) 2014 appguys.biz. All rights reserved.
//

// Controllers Import
#import "LOLLU_SummonerDetailsViewController.h"

// Models Import
#import "LOLLU_DataHandler.h"

@interface LOLLU_SummonerDetailsViewController ()
{
    LOLLU_DataHandler *dataHandler;
}
@end

@implementation LOLLU_SummonerDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataHandler = [[LOLLU_DataHandler alloc] init];
    [dataHandler getRecentGamesByRegion:@"na" andSummonerID:24673152];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
