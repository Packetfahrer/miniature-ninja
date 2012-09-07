//
//  AddTransViewController.h
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import <UIKit/UIKit.h>



@class Trans;
@class DatePickerViewController;
@class DetailContactViewController; 


@interface AddTransViewController : UIViewController <UITextFieldDelegate> {
	
	IBOutlet UITextField *txtTransactionDescription;
    IBOutlet UILabel *lblDOE;
	IBOutlet UILabel *lblName;

	DatePickerViewController *dvController;    
    DetailContactViewController *dcController;
	UINavigationController *addNavigationController;
    
    
}
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

- (IBAction) editDOE: (id) sender;
- (IBAction) nameClicked: (id) sender;

@end
