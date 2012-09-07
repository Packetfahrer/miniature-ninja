//
//  DetailDOBViewController.h
//  Auto Bio
//
//  Created by Kevin Collins on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailDOBViewController : UIViewController < UIPickerViewDelegate, UIPickerViewDataSource > {
	NSMutableArray *comp1;
	NSMutableArray *comp2;
	NSMutableArray *comp3;
	NSString *strMonth;
	NSString *strDay;
	NSString *strYear;
	NSString *categoryID;

	IBOutlet UIPickerView *pvMeals;
	IBOutlet UITextField *txtField;
	IBOutlet UILabel *lblField;
	IBOutlet UISegmentedControl *segField;
	NSString *keyOfTheFieldToEdit;
	NSString *editValue;
	id objectToEdit;
	CustomerAppDelegate *appDelegate;
	int autoInt;
	
	
	
}

@property (nonatomic, retain) id objectToEdit;
@property (nonatomic, retain) NSString *keyOfTheFieldToEdit;
@property (nonatomic, retain) NSString *editValue;
@property (nonatomic, retain) NSString *strMonth;
@property (nonatomic, retain) NSString *strDay;
@property (nonatomic, retain) NSString *strYear;
@property (nonatomic, retain) NSString *categoryID;


- (IBAction) save_Clicked:(id)sender;
- (IBAction) cancel_Clicked:(id)sender;
- (IBAction) changeSegType: (id) sender;
- (void)displayDate;

@end
