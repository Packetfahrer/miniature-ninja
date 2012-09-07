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
@synthesize objectToEdit, keyOfTheFieldToEdit, editValue, strContact, categoryID;
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
	appDelegate = (CustomerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	[self initComp1];
	
	self.title = @"Name";	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											  target:self action:@selector(cancel_Clicked:)] autorelease];
	

    UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setTintColor:[UIColor blueColor]];	
	
	
	
	self.categoryID = @"REQUIRED";
    if ([appDelegate.contactArray count]  > 0){
        pvContacts.hidden = NO;
        [pvContacts becomeFirstResponder];
        [pvContacts reloadAllComponents];   
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                   target:self action:@selector(save_Clicked:)] autorelease];
        Contact *childObj = [appDelegate.contactArray objectAtIndex:[pvContacts selectedRowInComponent:0]];
        contactInt =  childObj.contactID;
        strContact =  childObj.contactName;
    } else {
        pvContacts.hidden = YES;        
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
	contactInt =  childObj.contactID;
	strContact =  childObj.contactName;
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
	[editValue release];
	[keyOfTheFieldToEdit release];
	[objectToEdit release];
    [super dealloc];
}

- (IBAction) save_Clicked:(id)sender {
	
	self.categoryID = [NSString stringWithFormat:@"%d",contactInt];
	if (self.categoryID  == nil) {
		UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Name has to be selected!" 
														  message:@"Please select a Name before saving." 
														 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[myAlert show];
		[myAlert release];
		
	}else {
		[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:self.categoryID] forKey:@"contactid"];

		[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:strContact] forKey:@"contactname"];
		
		
		
		
		//Pop back to the detail view.
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
    
    
    
}

- (IBAction) cancel_Clicked:(id)sender {
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}




@end
