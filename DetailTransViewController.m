//
//  DetailTransViewController.m
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import "DetailTransViewController.h"
#import "Trans.h"
#import "EditTransViewController.h"

@implementation DetailTransViewController

@synthesize transObj;


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
	self.title = transObj.transaction_description;
    
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
	[transObj release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tblView {
    return 2;
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
			cell.textLabel.text = transObj.transaction_description;
			break;
		case 1:
			cell.textLabel.text = @"Date of Transaction";
			if(transObj.doe != nil)
				cell.textLabel.text = [NSString stringWithFormat:@"%@", transObj.doe];
			break;
	}
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tblView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionName = nil;
	
	switch (section) {
		case 0:
			sectionName = [NSString stringWithFormat:@"Description"];
			break;			
		case 1:
			sectionName = [NSString stringWithFormat:@"Date"];
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
		evController = [[EditTransViewController alloc] initWithNibName:@"EditTransViewController" bundle:nil];
	
	//Find out which field is being edited.
	switch(indexPath.section)
	{
		case 0:
			evController.keyOfTheFieldToEdit = @"contactName";
			evController.editValue = transObj.transaction_description;
			
			//Object being edited.
			evController.objectToEdit = transObj;
			
			//Push the edit view controller on top of the stack.
			[self.navigationController pushViewController:evController animated:YES];
			break;
		case 1:
			evController.keyOfTheFieldToEdit = @"gender";
			evController.editValue = transObj.doe;
			//Object being edited.
			evController.objectToEdit = transObj;
			
			//Push the edit view controller on top of the stack.
			[self.navigationController pushViewController:evController animated:YES];
			break;
	}
	
}

@end
