//
//  DatePickerViewController.m
//  Proof of Expense
//
//  Created by Kevin Collins on 2/28/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import "DatePickerViewController.h"


@implementation DatePickerViewController
@synthesize datePicker;

// The designated initializer. Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    NSDate *now = [[NSDate alloc] init];
    [datePicker setDate:now animated:YES];
    [now release];
    
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											  target:self action:@selector(cancel_Clicked:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
											   target:self action:@selector(save_Clicked:)] autorelease];
    UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setTintColor:[UIColor blueColor]];	

    [super viewDidLoad];
}
/*kcproof
- (void)viewWillDisappear:(BOOL)animated {
    datePicker.timeZone = [NSTimeZone localTimeZone];
    
    //kc    NSLog(@"Timezone:%@",datePicker.timeZone);
    
    
    NSDate *selected = [datePicker date];
    
    //------------kc
    NSDateFormatter* df_utc = [[[NSDateFormatter alloc] init] autorelease];
    //kc   [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df_utc setTimeZone:[NSTimeZone localTimeZone]];
    //kc    [df_utc setDateFormat:@"yyyy.MM.dd G 'at' HH:mm:ss zzz"];
    [df_utc setDateFormat:@"yyyy.MM.dd HH:mm:ss a"];
    
    
    NSDateFormatter* df_local = [[[NSDateFormatter alloc] init] autorelease];
    [df_local setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    [df_local setDateFormat:@"yyyy.MM.dd HH:mm:ss a"];
    
    NSString* ts_utc_string = [df_utc stringFromDate:selected];
    NSString* ts_local_string = [df_local stringFromDate:selected];
    
    //------------kc
    //kc    NSString *message = [[NSString alloc] initWithFormat:@"The date and time you selected is: %@", selected];
    //kc	[[NSUserDefaults standardUserDefaults] setObject:ts_local_string forKey:@"dateofevent"];
    [[NSUserDefaults standardUserDefaults] setObject:ts_utc_string forKey:@"dateofevent"];
	[self.navigationController dismissModalViewControllerAnimated:YES];

}
kcproof*/
- (void)viewWillAppear:(BOOL)animated {
    NSDate *now = [[NSDate alloc] init];
    [datePicker setDate:now animated:YES];
    [now release];

    self.title = @"Date of Event";

	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	NSString *strSelected = [user stringForKey:@"selected"];
	if ([strSelected isEqualToString:@"arrivalselected"]) self.title = @"Date of Arrival";
	if ([strSelected isEqualToString:@"departureselected"]) self.title = @"Date of Departure";
	
	[super viewWillAppear:YES];
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (IBAction) save_Clicked:(id)sender {
   datePicker.timeZone = [NSTimeZone localTimeZone];

//kc    NSLog(@"Timezone:%@",datePicker.timeZone);
   

   NSDate *selected = [datePicker date];
    
//------------kc
    NSDateFormatter* df_utc = [[[NSDateFormatter alloc] init] autorelease];
//kc   [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
      [df_utc setTimeZone:[NSTimeZone localTimeZone]];
//kc    [df_utc setDateFormat:@"yyyy.MM.dd G 'at' HH:mm:ss zzz"];
    [df_utc setDateFormat:@"yyyy.MM.dd HH:mm:ss a"];

    
    NSDateFormatter* df_local = [[[NSDateFormatter alloc] init] autorelease];
    [df_local setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    [df_local setDateFormat:@"yyyy.MM.dd HH:mm:ss a"];
    
    NSString* ts_utc_string = [df_utc stringFromDate:selected];

//------------kc
//kc    NSString *message = [[NSString alloc] initWithFormat:@"The date and time you selected is: %@", selected];
/*kc    NSString *message = [[NSString alloc] initWithFormat:@"The date and time you selected is: %@", ts_local_string];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Date and Time Selected" message:message delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [message release];
kc*/
//kc	[[NSUserDefaults standardUserDefaults] setObject:ts_local_string forKey:@"dateofevent"];
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	NSString *strSelected = [user stringForKey:@"selected"];
	if ([strSelected isEqualToString:@"arrivalselected"] || [strSelected isEqualToString:@"departureselected"]){
        if ([strSelected isEqualToString:@"arrivalselected"]){
            [[NSUserDefaults standardUserDefaults] setObject:ts_utc_string forKey:@"arrivaldate"];
        }
        if ([strSelected isEqualToString:@"departureselected"]){
            [[NSUserDefaults standardUserDefaults] setObject:ts_utc_string forKey:@"departuredate"];
        }
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:ts_utc_string forKey:@"dateofevent"];
    }
//kc     [self.navigationController dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [datePicker release];
    [super dealloc];
}
- (IBAction) cancel_Clicked:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end