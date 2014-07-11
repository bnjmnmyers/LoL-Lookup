//
//  LOLLU_MainViewController.m
//  LoL Lookup
//
//  Created by Benjamin Myers on 7/10/14.
//  Copyright (c) 2014 appguys.biz. All rights reserved.
//

// Controller Import
#import "LOLLU_MainViewController.h"

// Model Import
#import "LOLLU_DataHandler.h"

// Data Import

// REGIONS BR, EUNE, EUW, KR, LAN, LAS, NA, OCE, RU, TR

@interface LOLLU_MainViewController ()
{
	LOLLU_DataHandler *dataHandler;
}

@end

@implementation LOLLU_MainViewController

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
	
	_regionArray = [[NSArray alloc] initWithObjects:@"NA", @"BR", @"EUNE", @"EUW", @"KR", @"LAN", @"LAS", @"OCE", @"RU", @"TR", nil];
	
	_regionPicker.delegate = self;
	_tfSummonerName.delegate = self;
	
	//UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	//[self.view addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
	
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        return YES;
    }
	
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (void) hideKeyboard {
	[_activeField resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
	// number of vertical columns
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [_regionArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	return [_regionArray objectAtIndex:row];
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

- (IBAction)showRegionPicker:(id)sender
{
	_regionPickerCont.hidden = FALSE;
}

- (IBAction)selectRegion:(id)sender
{
	NSInteger row;
	
	row = [_regionPicker selectedRowInComponent:0];
	_lblRegion.text = [_regionArray objectAtIndex:row];
	NSLog(@"%@", [_regionArray objectAtIndex:row]);
	[self resignFirstResponder];
	_regionPickerCont.hidden = TRUE;
}

- (IBAction)lookupSummoner:(id)sender
{
	if (![_tfSummonerName.text isEqualToString:@""]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        ^{
           [dataHandler getSummonerInfoByRegion:[_lblRegion.text lowercaseString] andSummonerName:_tfSummonerName.text];
           dispatch_sync(dispatch_get_main_queue(), ^{
               [self performSegueWithIdentifier:@"segueToSummonerDetails" sender:self];
           });
        });
	} else {
		_alert = [[UIAlertView alloc]initWithTitle:@"Invalid Summoner Name" message:@"Please enter a valid summoner name for the selected region." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[_alert show];
	}
}
@end
