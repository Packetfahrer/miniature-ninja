//
//  EditViewController.h
//  PartyTwacker
//
//  Created by Kevin Collins on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
//	__Fit_2_QuitAppDelegate *appDelegate;

	IBOutlet UITextField *txtField;
	IBOutlet UILabel *lblField;
	IBOutlet UISegmentedControl *segField;
	NSString *keyOfTheFieldToEdit;
	NSString *editValue;
	id objectToEdit;
	NSMutableArray *comp1;
	NSMutableArray *comp2;
	NSMutableArray *comp3;
	NSString *strMonth;
	NSString *strDay;
	NSString *strYear;
	IBOutlet UIPickerView *pvDOB;

	
}

@property (nonatomic, retain) id objectToEdit;
@property (nonatomic, retain) NSString *keyOfTheFieldToEdit;
@property (nonatomic, retain) NSString *editValue;

- (IBAction) save_Clicked:(id)sender;
- (IBAction) cancel_Clicked:(id)sender;
- (IBAction) changeSegType: (id) sender;
- (void)displayDate;

@property (nonatomic, retain) NSString *strMonth;
@property (nonatomic, retain) NSString *strDay;
@property (nonatomic, retain) NSString *strYear;

@end

