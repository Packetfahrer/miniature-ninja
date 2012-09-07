//
//  AddViewController.h
//  PartyTwacker
//
//  Created by Kevin Collins on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@class Contact;
@class DetailHeightViewController;
@class DetailDOBViewController;


@interface AddViewController : UIViewController <UITextFieldDelegate> {
	
	IBOutlet UITextField *txtContactName;
    IBOutlet UILabel *lblDOB;
	IBOutlet UISegmentedControl *txtGender;
	DetailDOBViewController *dbController;



}
- (IBAction) editDOB: (id) sender;


@end
