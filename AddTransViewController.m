//
//  AddTransViewController.m
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import "AddTransViewController.h"
#import "Trans.h"
#import "DatePickerViewController.h"
#import "DetailContactViewController.h"

@implementation AddTransViewController
@synthesize navigationBar;

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Add Transaction";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											  target:self action:@selector(cancel_Clicked:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
											   target:self action:@selector(save_Clicked:)] autorelease];
    txtTransactionDescription.text = @"";
    txtTransactionDescription.delegate = self;	
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setTintColor:[UIColor blueColor]];
    
}


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	lblDOE.text = [user stringForKey:@"dateofevent"];
	lblName.text = [user stringForKey:@"contactname"];

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
	
	//Create a Contact Object.
	Trans *transObj = [[Trans alloc] initWithPrimaryKey:0];
	transObj.transaction_description = txtTransactionDescription.text;
    
    //kc v1.3	contactObj.dob = txtDob.text;
	transObj.doe =lblDOE.text;
      
    transObj.contactName = lblName.text;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    int i1 =[[user stringForKey:@"childint"] intValue]; 
    if ((i1 < [appDelegate.contactArray count] & i1 > [appDelegate.contactArray count]) || [lblName.text isEqualToString:@"Required"] || [lblDOE.text isEqualToString:@"Required"]){
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Select a Person and a Transaction Date" 
                                                          message:@"Please select a person and the Date of Transaction." 
                                                         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [myAlert show];
        [myAlert release];
        

    } else {
        transObj.contact_id = [user stringForKey:@"contactid"];   
        
        transObj.isDirty = NO;
        transObj.isDetailViewHydrated = YES;
        
        
        //Add the object
        [appDelegate addTrans:transObj];
        
        //**************************************************************
        //Initialize the tracker array. kc11192009
        [appDelegate refreshTrans];
        //**************************************************************
        
        //Dismiss the controller.
        [transObj release];
        txtTransactionDescription.text = @"";
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
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

- (void) editDOE:(id)sender {
    
	[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%@",txtTransactionDescription.text] forKey:@"name"];
    
	[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"doeselected"] forKey:@"selected"];
	if(dvController == nil) 
		dvController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
	
	[dvController setHidesBottomBarWhenPushed:YES];
    /*kc    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:dbController];
     [pop setDelegate:self];
     [pop setPopoverContentSize:CGSizeMake(320, 480)];
     
     [pop presentPopoverFromRect:((UIButton *)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];	
     
     kc*/	
	[self.navigationController pushViewController:dvController animated:YES];
}
- (IBAction) nameClicked: (id) sender{
    
	if(dcController == nil)
		dcController = [[DetailContactViewController alloc] initWithNibName:@"DetailContactViewController" bundle:nil];
	
	if(addNavigationController == nil){
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:dcController];
	}else {
		[addNavigationController release];
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:dcController];
		
	}
	
    //kc	[self.navigationController presentModalViewController:addNavigationController animated:YES];
	[self presentModalViewController:addNavigationController animated:YES];
    
    
}

- (void)dealloc {
    
    [super dealloc];
}

@end
