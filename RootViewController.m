//
//  RootViewController.m
//  Proof of Expense
//
//  Created by Kevin Collins on 3/6/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "Contact.h"
#import "AddViewController.h"



@implementation RootViewController
@synthesize navigationBar;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [appDelegate.contactArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";

	tabView.backgroundColor = [UIColor whiteColor]; 
	tabView.separatorColor = [UIColor grayColor];
	tabView.showsVerticalScrollIndicator = YES;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.textLabel.textColor = [UIColor blueColor];
    
	//Get the object from the array.
	Contact *contactObj = [appDelegate.contactArray objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:12];
	cell.textLabel.numberOfLines = 8;
	cell.textLabel.text = [NSString stringWithFormat:@"Name: %@  DOB: %@", 
						   contactObj.contactName, contactObj.dob];	//Set the accessory type.


	//Set the accessory type.
//kc	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	
    // Set up the cell
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic -- create and push a new view controller
	
	if(dvController == nil) 
		dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
	
	Contact *contactObj = [appDelegate.contactArray objectAtIndex:indexPath.row];
 
	//We only load the data we initially want and keep on loading as we need.
	[contactObj hydrateDetailViewData];
	
	dvController.contactObj = contactObj;
	[dvController setHidesBottomBarWhenPushed:YES];
	[self.navigationController pushViewController:dvController animated:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];
	
 	appDelegate = (CustomerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.title = @"Contacts";    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											  target:self action:@selector(cancel_Clicked:)] autorelease];
	
	
	
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setTintColor:[UIColor blueColor]];
    
	
    
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		Contact *contactObj = [appDelegate.contactArray objectAtIndex:indexPath.row];

		//Get the object to delete from the array.

		[appDelegate removeContact:contactObj];
				
		//Delete the object from the table.
		[tabView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[tabView reloadData];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setTintColor:[UIColor blueColor]];

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
 	[super setEditing:editing animated:animated];
    [tabView setEditing:editing animated:YES];
	
	//Do not let the user add if the app is in edit mode.
	if(editing)
 		self.navigationItem.leftBarButtonItem.enabled = NO;
 	else
 		self.navigationItem.leftBarButtonItem.enabled = YES;
}	

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}



- (IBAction) cancel_Clicked:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction) addContact: (id) sender{
	[[NSUserDefaults standardUserDefaults] setObject:@"Required" forKey:@"dateofbirth"];	

	if(adController == nil)
		adController = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
	
	if(addNavigationController == nil){
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:adController];
	}else {
		[addNavigationController release];
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:adController];
		
	}

    [self presentModalViewController:addNavigationController animated:YES];	
}

- (void)dealloc {
	[dvController release];
    [adController release];

	[addNavigationController release];
    
    [super dealloc];
}

@end

