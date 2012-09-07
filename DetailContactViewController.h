//
//  DetailContactViewController.h
//  Proof of Expense
//
//  Created by Kevin Collins on 3/4/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Contact;
@class AddViewController;

@interface DetailContactViewController : UIViewController <UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource > {
	NSMutableArray *comp1;
	NSString *strChild;
	NSString *categoryID;
    AddViewController *acController;
	
	IBOutlet UIPickerView *pvMeals;
	IBOutlet UITextField *txtField;
	IBOutlet UILabel *lblField;
	IBOutlet UISegmentedControl *segField;
	NSString *keyOfTheFieldToEdit;
	NSString *editValue;
	id objectToEdit;
	ProofAppDelegate *appDelegate;
	int childInt;
	UINavigationController *addNavigationController;

	
	
}

@property (nonatomic, retain) id objectToEdit;
@property (nonatomic, retain) NSString *keyOfTheFieldToEdit;
@property (nonatomic, retain) NSString *editValue;
@property (nonatomic, retain) NSString *strChild;
@property (nonatomic, retain) NSString *categoryID;


- (IBAction) save_Clicked:(id)sender;
- (IBAction) cancel_Clicked:(id)sender;
- (IBAction) changeSegType: (id) sender;
- (IBAction) addContact: (id) sender; 

@end