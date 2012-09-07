//
//  AddViewController.m
//  PartyTwacker
//
//  Created by Kevin Collins on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddViewController.h"
#import "Contact.h"
#import "DetailViewController.h"

@implementation AddViewController

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Add Person";
    imagePickerView = [[UIImagePickerController alloc] init];
    imagePickerView.delegate = self;
    imagePickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;		
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											  target:self action:@selector(cancel_Clicked:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
											   target:self action:@selector(save_Clicked:)] autorelease];
    txtContactName.text = @"";
    txtContactName.delegate = self;	
	txtGender.selectedSegmentIndex = 0;

//	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	lblHeight.text = 		[user stringForKey:@"height"];

	//Set the textboxes to empty string.
//	txtContactName.text = [user stringForKey:@"name"];
	txtWeight.text = @"";
	lblDOB.text = [user stringForKey:@"dob"];
	txtTwitterID.text = @"";
	txtActiveind.selectedSegmentIndex = 1;
//kc   [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@""] forKey:@"image_path2"];
	UIImage *uiiv = [[UIImage alloc] init];
	imgView.image = uiiv;
	//kc110609	txtActiveind.text = @"";
	
//	[txtContactName becomeFirstResponder];
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
	
	ProofAppDelegate *appDelegate = (ProofAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	
	//Create a Contact Object.
	Contact *contactObj = [[Contact alloc] initWithPrimaryKey:0];
	NSString *strName = txtContactName.text;
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

/*kc- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	[theTextField resignFirstResponder];
	return YES;
}kc*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void) editHeight:(id)sender {
	[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%@",txtContactName.text] forKey:@"name"];

	[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"heightselected"] forKey:@"selected"];
	if(dvController == nil) 
		dvController = [[DetailHeightViewController alloc] initWithNibName:@"DetailHeightView" bundle:nil];
	
	[dvController setHidesBottomBarWhenPushed:YES];
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:dvController];
    [pop setDelegate:self];
    [pop setPopoverContentSize:CGSizeMake(320, 216)];
    
    [pop presentPopoverFromRect:((UIButton *)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];	
	

	
//kc	[self.navigationController pushViewController:dvController animated:YES];
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
	[txtContactName release];
	[lblDOB release];
	[txtGender release];
	[lblHeight release];
	[txtWeight release];
	[txtActiveind release];
	[txtTwitterID release];
    [super dealloc];
}
- (void)popoverControllerDidDismissPopover:
(UIPopoverController *)popoverController {
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	lblHeight.text = 		[user stringForKey:@"height"];
    
	//Set the textboxes to empty string.
    //	txtContactName.text = [user stringForKey:@"name"];
    
	txtWeight.text = @"";
	lblDOB.text = [user stringForKey:@"dob"];
	txtTwitterID.text = @"";
	txtGender.selectedSegmentIndex = 0;
	txtActiveind.selectedSegmentIndex = 1;
	//kc110609	txtActiveind.text = @"";
	
    //	[txtContactName becomeFirstResponder];

}

- (IBAction) editImage: (id) sender {
	NSString *strName    = txtContactName.text;
    
	if ([strName isEqualToString:@"Required"] || [strName length] == 0){
		UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Name has to be selected!" 
														  message:@"Please provide Name before selecting an image." 
														 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[myAlert show];
		[myAlert release];
		
	}else {
        //kc		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        //kc			[self presentModalViewController:imagePickerView animated:YES];
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
			[self presentModalViewController:imagePickerView animated:YES];         
	}
	
}
//*****************************************//kcauto_doc_manager**************************************************
/*kc - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)dictionary {

    [picker dismissModalViewControllerAnimated:YES];
	
    //kc11182009    NSData * imageData = UIImagePNGRepresentation(image);
	//kcauto_doc_manager    CGFloat compressionQuality = 100.0;
	//kcauto_doc_manager    NSData * imageData = UIImageJPEGRepresentation(image, compressionQuality);
    //    NSData * imageData = UIImagePNGRepresentation(image);
	NSData * imageData = UIImageJPEGRepresentation(image,0.25f);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	
	
    NSString *strImageFileName = [NSString stringWithFormat:@"%@%@.jpeg",[user stringForKey:@"childint"],[NSDate date]];
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:strImageFileName];
    [imageData writeToFile:[NSString stringWithFormat:@"%@",imagePath] atomically:YES];
    [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%@",imagePath] forKey:@"image_path2"];
	UIImage *uiiv = [[UIImage alloc] initWithContentsOfFile:imagePath];
	imgView.image = uiiv;
	[uiiv release];
    //  lblNotes.hidden = NO;
}
kc*/
- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   [picker dismissModalViewControllerAnimated:YES];
	
    //kc11182009    NSData * imageData = UIImagePNGRepresentation(image);
	//kcauto_doc_manager    CGFloat compressionQuality = 100.0;
	//kcauto_doc_manager    NSData * imageData = UIImageJPEGRepresentation(image, compressionQuality);
    //    NSData * imageData = UIImagePNGRepresentation(image);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	NSData * imageData = UIImageJPEGRepresentation(image,0.25f);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	
	
    NSString *strImageFileName = [NSString stringWithFormat:@"%@%@.jpeg",[user stringForKey:@"childint"],[NSDate date]];
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:strImageFileName];
    [imageData writeToFile:[NSString stringWithFormat:@"%@",imagePath] atomically:YES];
    [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%@",imagePath] forKey:@"image_path2"];
	UIImage *uiiv = [[UIImage alloc] initWithContentsOfFile:imagePath];
	imgView.image = uiiv;
	[uiiv release];
    //  lblNotes.hidden = NO;
}

@end
