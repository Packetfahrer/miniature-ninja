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


@interface AddViewController : UIViewController <UIImagePickerControllerDelegate> {
	IBOutlet UIImageView *imgView;
	
	IBOutlet UITextField *txtContactName;
	IBOutlet UITextField *txtWeight;
    IBOutlet UILabel *lblDOB;
	IBOutlet UILabel *lblHeight;
	IBOutlet UISegmentedControl *txtGender;
	IBOutlet UISegmentedControl *txtActiveind;
	IBOutlet UITextField *txtTwitterID;
	DetailHeightViewController *dvController;
	DetailDOBViewController *dbController;
    
    UIPopoverController *popover;
    UIImagePickerController *imagePickerView;	


}
- (IBAction) editHeight: (id) sender;
- (IBAction) editDOB: (id) sender;
- (IBAction) editImage: (id) sender;


@end
