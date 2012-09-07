//
//  AddViewController.m
//  PartyTwacker
//
//  Created by Kevin Collins on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddViewController.h"
#import "Contact.h"
#import "DetailDOBViewController.h"

@implementation AddViewController

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Add Person";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											  target:self action:@selector(cancel_Clicked:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
											   target:self action:@selector(save_Clicked:)] autorelease];
    txtContactName.text = @"";
    txtContactName.delegate = self;	
	txtGender.selectedSegmentIndex = 0;
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setTintColor:[UIColor blueColor]];

}


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

	lblDOB.text = [user stringForKey:@"dob"];
}

- (void) viewWillDisappear:(BOOL)animated {
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) save_Clicked:(id)sender {
	
	CustomerAppDelegate *appDelegate = (CustomerAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	
	//Create a Contact Object.
	Contact *contactObj = [[Contact alloc] initWithPrimaryKey:0];
	contactObj.contactName = txtContactName.text;

//kc v1.3	contactObj.dob = txtDob.text;
	contactObj.dob =lblDOB.text;
//kc	contactObj.height = lblHeight.text;
    contactObj.height = [user stringForKey:@"image_path2"];
	
	//kc111009	contactObj.contact_id = 
	if (txtGender.selectedSegmentIndex == 0) {
		contactObj.gender = @"Male";
	}else {
		contactObj.gender = @"Female";
	}
		


	contactObj.isDirty = NO;
	contactObj.isDetailViewHydrated = YES;

	
	//Add the object
	[appDelegate addContact:contactObj];

	//**************************************************************
	//Initialize the tracker array. kc11192009
	[appDelegate refreshContact];
	//**************************************************************
	
	//Dismiss the controller.
	[contactObj release];
    txtContactName.text = @"";

	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) cancel_Clicked:(id)sender {
	
	//Dismiss the controller.
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void) editDOB:(id)sender {
    
	[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%@",txtContactName.text] forKey:@"name"];
    
	[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"dobselected"] forKey:@"selected"];
	if(dbController == nil) 
		dbController = [[DetailDOBViewController alloc] initWithNibName:@"DetailDOBView" bundle:nil];
	
	[dbController setHidesBottomBarWhenPushed:YES];
    /*kc    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:dbController];
     [pop setDelegate:self];
     [pop setPopoverContentSize:CGSizeMake(320, 480)];
     
     [pop presentPopoverFromRect:((UIButton *)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];	
     
     kc*/	
	[self.navigationController pushViewController:dbController animated:YES];
}

- (void)dealloc {

    [super dealloc];
}

@end
