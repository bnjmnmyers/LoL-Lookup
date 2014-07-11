//
//  LOLLU_MainViewController.h
//  LoL Lookup
//
//  Created by Benjamin Myers on 7/10/14.
//  Copyright (c) 2014 appguys.biz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LOLLU_MainViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>

// UI Properties
@property (weak, nonatomic) IBOutlet UITextField *tfSummonerName;
@property (weak, nonatomic) IBOutlet UILabel *lblRegion;
@property (weak, nonatomic) IBOutlet UIPickerView *regionPicker;
@property (weak, nonatomic) IBOutlet UIView *regionPickerCont;
@property (strong, nonatomic) UIAlertView *alert;


// Variable Properties
@property (assign, nonatomic) BOOL canSegue;
@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) NSArray *regionArray;

// Actions
- (IBAction)showRegionPicker:(id)sender;
- (IBAction)selectRegion:(id)sender;
- (IBAction)lookupSummoner:(id)sender;

@end
