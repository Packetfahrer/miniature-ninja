//
//  DetailViewController.m
//  PartyTwacker
//
//  Created by Kevin Collins on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Contact.h"
#import "EditViewController.h"

@implementation DetailViewController

@synthesize contactObj;


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
	
    [tableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
}


- (void) viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	self.title = contactObj.contactName;
    
	[tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
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
	[evController release];
	[selectedIndexPath release];
	[tableView release];
	[contactObj release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tblView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tblView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	tableView.backgroundColor = [UIColor clearColor];

	switch(indexPath.section) {
		case 0:
			cell.textLabel.text = contactObj.contactName;
			break;
		case 1:
			cell.textLabel.text = @"Change Gender";
			if(contactObj.gender != nil)
				cell.textLabel.text = [NSString stringWithFormat:@"%@", contactObj.gender];
			break;
		case 2:
			cell.textLabel.text = @"Change Date of Birth";
			if(contactObj.dob != nil)
				cell.textLabel.text = [NSString stringWithFormat:@"%@", contactObj.dob];
		break;
	}
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tblView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionName = nil;
	
	switch (section) {
		case 0:
			sectionName = [NSString stringWithFormat:@"Name"];
			break;			
		case 1:
			sectionName = [NSString stringWithFormat:@"Gender"];
			break;
		case 2:
			sectionName = [NSString stringWithFormat:@"Date of Birth"];
			break;
}
	
	return sectionName;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    // Show the disclosure indicator if editing.
    return (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
    return (self.editing) ? indexPath : nil;
}

- (void)tableView:(UITableView *)tblView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Keep track of the row selected.
	selectedIndexPath = indexPath;
	
	if(evController == nil)
		evController = [[EditViewController alloc] initWithNibName:@"EditView" bundle:nil];
	
	//Find out which field is being edited.
	switch(indexPath.section)
	{
		case 0:
			evController.keyOfTheFieldToEdit = @"contactName";
			evController.editValue = contactObj.contactName;
			
			//Object being edited.
			evController.objectToEdit = contactObj;
			
			//Push the edit view controller on top of the stack.
			[self.navigationController pushViewController:evController animated:YES];
			break;
		case 1:
			evController.keyOfTheFieldToEdit = @"gender";
			evController.editValue = contactObj.gender;
			//Object being edited.
			evController.objectToEdit = contactObj;
			
			//Push the edit view controller on top of the stack.
			[self.navigationController pushViewController:evController animated:YES];
			break;
		case 2:
			evController.keyOfTheFieldToEdit = @"dob";
			evController.editValue = contactObj.dob;
			//Object being edited.
			evController.objectToEdit = contactObj;
			
			//Push the edit view controller on top of the stack.
			[self.navigationController pushViewController:evController animated:YES];
			break;
	}
	
}

@end
