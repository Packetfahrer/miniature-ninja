//
//  DetailContactViewController.m
//  Proof of Expense
//
//  Created by Kevin Collins on 3/4/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import "DetailContactViewController.h"
#import "Contact.h"
#import "AddViewController.h"

@implementation DetailContactViewController
@synthesize objectToEdit, keyOfTheFieldToEdit, editValue, strChild, categoryID;
- (void)initComp1 {
	comp1 = [[NSMutableArray alloc] init];
	for (NSString *child_id in appDelegate.contactArray) {
		[comp1 addObject:child_id];
		
	}
}
// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	
}
- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:YES];
	appDelegate = (ProofAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	[self initComp1];
	
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	NSString *strSelected = [user stringForKey:@"selected"];
	self.title = @"Name";	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											  target:self action:@selector(cancel_Clicked:)] autorelease];
	

    UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setTintColor:[UIColor blueColor]];	
	
	
	
	self.categoryID = @"REQUIRED";
	txtField.hidden = NO;
    if ([appDelegate.contactArray count]  > 0){
        pvMeals.hidden = NO;
        [pvMeals becomeFirstResponder];
        [pvMeals reloadAllComponents];   
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                   target:self action:@selector(save_Clicked:)] autorelease];
        Contact *childObj = [appDelegate.contactArray objectAtIndex:[pvMeals selectedRowInComponent:0]];
        childInt =  childObj.contactID;
        strChild =  childObj.contactName;
        txtField.text = childObj.contactName;
    } else {
        pvMeals.hidden = YES;        
    }

	
	
	
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	//kc111009	NSLog(@"AddTrackerViewController made it to number of components");
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [comp1 count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
	//kc111009	NSLog(@"AddTrackerViewController made it to widthForComponent");
	return 300;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	//kc110909- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view  {
	//kc111009	NSLog(@"AddTrackerViewController made it to viewForRow");
	Contact *childObj = [appDelegate.contactArray objectAtIndex:row];
	return childObj.contactName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	Contact *childObj = [appDelegate.contactArray objectAtIndex:row];
	childInt =  childObj.contactID;
	strChild =  childObj.contactName;
    txtField.text = childObj.contactName;
}

- (IBAction) changeSegType: (id) sender
{
	if (self.keyOfTheFieldToEdit == @"gender") {
		if (segField.selectedSegmentIndex == 0){
			lblField.text = @"Male";
		}else{
			lblField.text = @"Female";
		}
	}
	//kc v1.3	if (self.keyOfTheFieldToEdit == @"active_ind") {
	//kc v1.3		if (segField.selectedSegmentIndex == 0){
	//kc v1.3			lblField.text = @"Yes";
	//kc v1.3		}else{
	//kc v1.3			lblField.text = @"No";
	//kc v1.3		}
	//kc v1.3	}
	
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[txtField release];
	[lblField release];
	[editValue release];
	[keyOfTheFieldToEdit release];
	[objectToEdit release];
    [super dealloc];
}

- (IBAction) save_Clicked:(id)sender {
	
	self.categoryID = [NSString stringWithFormat:@"%d",childInt];
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	if (childInt == nil) {
		UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Name has to be selected!" 
														  message:@"Please select a Name before saving." 
														 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[myAlert show];
		[myAlert release];
		
	}else {
		NSString *strSelected = [user stringForKey:@"selected"];
		[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:self.categoryID] forKey:@"childint"];
		[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:self.categoryID] forKey:@"contactid"];

		[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:strChild] forKey:@"contactname"];
		
		
		
		
		//Pop back to the detail view.
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
    
    
    
}

- (IBAction) cancel_Clicked:(id)sender {
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction) addContact: (id) sender{
    
	[[NSUserDefaults standardUserDefaults] setObject:@"Required" forKey:@"dateofbirth"];	
	
	if(acController == nil)
		acController = [[AddViewController alloc] initWithNibName:@"AddView" bundle:nil];
	
	if(addNavigationController == nil){
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:acController];
	}else {
		[addNavigationController release];
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:acController];
		
	}
	
	[self.navigationController presentModalViewController:addNavigationController animated:YES];
}


@end
