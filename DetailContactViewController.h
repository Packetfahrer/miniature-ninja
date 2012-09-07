//
//  DetailContactViewController.h
//  Proof of Expense
//
//  Created by Kevin Collins on 3/4/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Contact;

@interface DetailContactViewController : UIViewController <UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource > {
	NSMutableArray *comp1;
	NSString *categoryID;
	NSString *strContact;
	int contactInt;
	IBOutlet UIPickerView *pvContacts;
	
	NSString *keyOfTheFieldToEdit;
	NSString *editValue;
	id objectToEdit;
	CustomerAppDelegate *appDelegate;
	UINavigationController *addNavigationController;

	
	
}

@property (nonatomic, retain) id objectToEdit;
@property (nonatomic, retain) NSString *keyOfTheFieldToEdit;
@property (nonatomic, retain) NSString *editValue;
@property (nonatomic, retain) NSString *categoryID;
@property (nonatomic, retain) NSString *strContact;



- (IBAction) save_Clicked:(id)sender;
- (IBAction) cancel_Clicked:(id)sender;
- (IBAction) changeSegType: (id) sender;

@end