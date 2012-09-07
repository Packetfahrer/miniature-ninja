//
//  RootViewController.m
//  Proof of Expense
//
//  Created by Kevin Collins on 3/6/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewEventController.h"
#import "LineChart.h"
#import "Event.h"
//kcproof #import "EventAttendance.h"
#import "Reachability.h"
#import "MTViewControllerE.h"



//kcRootViewControllerTest Test #import "RootTrackerViewControllerTest.h"

@implementation RootViewController
//kc11292009 @synthesize navigationController;
@synthesize navigationBar, bypassUserImage, strEmailDetail, strEmailFinal, strEmailHeader;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //LITE Modification    return [appDelegate.contactArray count];
	return [appDelegate.eventArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	tableView.backgroundColor = [UIColor whiteColor]; 
	tableView.separatorColor = [UIColor grayColor];
	tableView.showsVerticalScrollIndicator = YES;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.textLabel.textColor = [UIColor blueColor];
	//Get the object from the array.
	Event *eventObj = [appDelegate.eventArray objectAtIndex:indexPath.row];
    //LITE Modification		Contact *contactObj = [appDelegate.contactArray objectAtIndex:0]; //LITE Modification
	if (![bypassUserImage isEqualToString:@"Access Not Available.  Internet connectivity required."]){
        //		NSData * imageData = [[NSData alloc] initWithContentsOfURL: contactObj.profileImageURL];							//kc v1.3
        //		cell.imageView.image = [UIImage imageWithData: imageData];															//kc v1.3
        //		[imageData release];																								//kc v1.3
		;
	}
	//Set the coffename.
	cell.textLabel.font = [UIFont systemFontOfSize:12];
	//	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	cell.textLabel.numberOfLines = 8;
	cell.textLabel.text = eventObj.contactName;
	cell.textLabel.text = [NSString stringWithFormat:@"Date: %@  Name: %@  \nType: %@ \nDetail: %@", 
						   eventObj.doe, eventObj.contactName, eventObj.eventType,
						   eventObj.eventDescription];	//Set the accessory type.

    lblTotalExpenseCount.text = [NSString localizedStringWithFormat:@"Total Count: %d",iTotalExpenses];
    lblTotalExpenses.text =  [NSString localizedStringWithFormat:@"Total Costs: $%.2f",fTotalExpenses];
	//Set the accessory type.
//kc	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	
    // Set up the cell
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic -- create and push a new view controller
	
	if(dvController == nil) 
		dvController = [[DetailViewEventController alloc] initWithNibName:@"DetailViewEventController" bundle:nil];
	
	Event *eventObj = [appDelegate.eventArray objectAtIndex:indexPath.row];
    //LITE Modification		Contact *contactObj = [appDelegate.contactArray objectAtIndex:0];
	
	//Get the detail view data if it does not exists.
	//We only load the data we initially want and keep on loading as we need.
	[eventObj hydrateDetailViewData];
	
	dvController.eventObj = eventObj;
	[dvController setHidesBottomBarWhenPushed:YES];
	[self.navigationController pushViewController:dvController animated:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];
	
    //kc11292009	UINavigationController *navigationController = [[UINavigationController alloc] init];
	
    //kc11292009	[self.view addSubview:[navigationController view]];
	appDelegate = (ProofAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.title = @"Events";    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											  target:self action:@selector(cancel_Clicked:)] autorelease];
	
	
	
	NSUserDefaults *bypass = [NSUserDefaults standardUserDefaults];
	bypassUserImage = [[NSString alloc] init];
	bypassUserImage = [bypass stringForKey:@"bypassTwitterImage"];
    //kc	self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Party-Tracker-Icon_Banner_Friends.png"]];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setTintColor:[UIColor blueColor]];
	//kc = [NSString localizedStringWithFormat:@"$ %.2f",0.00];
    
	
    
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		
		//Get the object to delete from the array.
		Event *eventObj = [appDelegate.eventArray objectAtIndex:indexPath.row];
		//Get the object to delete from the array.
		//LITE Modification			Contact *contactObj = [appDelegate.contactArray objectAtIndex:0]; //LITE Modification
		NSString *path = eventObj.event_photo;
		
        NSFileManager *fileManager = [NSFileManager defaultManager];
		NSData *imageData = [NSData dataWithContentsOfFile:path];  
		if (imageData == nil)
			nil;
		else 
			[fileManager removeItemAtPath:path error:NULL];

        //LITE Modification			Contact *contactObj = [appDelegate.contactArray objectAtIndex:0]; //LITE Modification
		[appDelegate removeEvent:eventObj];
		
		
		//Delete the object from the table.
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //LITE Modification			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:0] withRowAnimation:UITableViewRowAnimationFade];
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //	[appDelegate saveContact];
//kcDOE    [appDelegate refreshEvent];
	[tableView reloadData];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setTintColor:[UIColor blueColor]];
    fTotalExpenses = 0.00;
    iTotalExpenses = 0;
    Event *eventObj = @""; //kc
    int i = 0;
    for (i = 0; i < [appDelegate.eventArray count]; i++) {	
        eventObj = [appDelegate.eventArray objectAtIndex:i];

        if ([eventObj.total_costs length] > 1){
            fTotalExpenses = fTotalExpenses + [eventObj.total_costs floatValue];
        }
        iTotalExpenses = iTotalExpenses + 1;
    }
    lblTotalExpenseCount.text = [NSString localizedStringWithFormat:@"Total Count: %d",iTotalExpenses];
    lblTotalExpenses.text =  [NSString localizedStringWithFormat:@"Total Costs: $%.2f",fTotalExpenses];

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
 	[super setEditing:editing animated:animated];
    [tableView setEditing:editing animated:YES];
	
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


- (void)dealloc {
	[dvController release];


	[addNavigationController release];
	[bypassUserImage release];
    
    [super dealloc];
}
- (IBAction) emailReport: (id) sender {
    
    //***********************************Reachability Modification*********************************
	hostError.hidden = YES;
	wifiError.hidden = YES;
	internetError.hidden = YES;
	hostError.text = @"";
    //***********************************Reachability Modification*********************************  
	//*****************************************Reachability Modification***************************************
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
    //Change the host name here to change the server your monitoring
	//    remoteHostLabel.text = [NSString stringWithFormat: @"Remote Host: %@", @"www.apple.com"];
	hostReach = [[Reachability reachabilityWithHostName: @"www.google.com"] retain];
	[hostReach startNotifer];
	[self updateInterfaceWithReachability: hostReach];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifer];
	[self updateInterfaceWithReachability: internetReach];
	
    //kc   wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
    //kc	[wifiReach startNotifer];
    //kc	[self updateInterfaceWithReachability: wifiReach];
	//*****************************************Reachability Modification***************************************	
/*kcproof

 NSString *gas_brand;
 NSString *location;

 NSString *start_odometer;
 NSString *end_odometer;
 NSString *flight_number;
 NSString *confirmation_number;
 NSString *arrival_date;
 NSString *departure_date;
 kcproof*/
	
    //kc	[self textFieldShouldReturn:stringToSend];
    if ([hostError.text length] == 0){

        NSString *str1 =  @"<TABLE border=1><TR><TD>Name</TD><TD>Date</TD><TD>Type</TD><TD>Description</TD><TD>Notes</TD><TD>Total Expense</TD><TD>Pmt Method</TD><TD>Odometer</TD><TD>CPG</TD><TD>Gallons</TD><TD>Miles Traveled</TD><TD>MPG</TD><TD>Fuel Type</TD><TD>Location</TD><TD>Fuel Brand</TD><TD>Start Odometer</TD><TD>End Odometer</TD><TD>Flight Number</TD><TD>Confirmation Number</TD><TD>Date of Arrival</TD><TD>Date of Departure</TD>";
        str1 = [str1 stringByAppendingString:@"</TR>"];
        int i;
        int i2;
        /*kc	for (i = 0; i < [appDelegate.exerciseActivityArray count]; i++) {		
         ExerciseActivity *exerciseActivityObj = [appDelegate.exerciseActivityArray objectAtIndex:i];
         strEmailDetail = [NSString stringWithFormat:@"<TR><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD></TR>",
         exerciseActivityObj.name,exerciseActivityObj.asof_date ,exerciseActivityObj.type,exerciseActivityObj.exercise];
         str1 = [str1 stringByAppendingString:strEmailDetail];
         }
         kc*/
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init]; //kc

        NSString *path = @"";     //kc
        NSString *strReformat = @"";
        NSData *imageData = [NSData dataWithContentsOfFile:path]; //kc
        Event *eventObj = @""; //kc

        for (i = 0; i < [appDelegate.eventArray count]; i++) {	
                eventObj = [appDelegate.eventArray objectAtIndex:i];

            
                strEmailDetail = [NSString stringWithFormat:@"<TR><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD><TD>%@</TD></TR>",
                                  eventObj.contactName,eventObj.doe ,eventObj.eventType,eventObj.eventDescription, eventObj.notes, eventObj.total_costs,eventObj.payment_type, eventObj.odometer, eventObj.cost_per_gallon, eventObj.gallons, eventObj.miles, eventObj.miles_per_gallon, eventObj.fuel_type, eventObj.location, eventObj.gas_brand, eventObj.start_odometer, eventObj.end_odometer, eventObj.flight_number, eventObj.confirmation_number, eventObj.arrival_date, eventObj.departure_date];
                str1 = [str1 stringByAppendingString:strEmailDetail];	
                path = eventObj.event_photo;
    //kc            NSLog(@"PhotoPath:%@",eventObj.event_photo);
                imageData = [NSData dataWithContentsOfFile:path];  
                // adding the attachment to he message  
                if ([path length] > 10){    //kc
 //kc                   NSLog(@"Path = %@",path);
                    strReformat = [[[eventObj.doe stringByReplacingOccurrencesOfString:@"." withString:@"-"] stringByReplacingOccurrencesOfString:@":" withString:@"-"] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                    [controller addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@-%@",eventObj.eventType,strReformat]];  	
                }
        }
        
        str1 = [str1 stringByAppendingString:@"</TABLE><TABLE><TR><TD><b>Tip:  You can copy and paste the above tables directly into Excel.</b></TD></TR></TABLE><BR><BR>"];
        str1 = [str1 stringByAppendingString:@"This report was generated with <a href=http://www.life-applications.com>Proof of Expense</a></font></b></td></tr>"];
        
        if ([MFMailComposeViewController canSendMail]){	
    //kc		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:@"Proof of Expense"];
            [controller setMessageBody:str1 isHTML:YES];
        
            [controller setHidesBottomBarWhenPushed:YES]; //kctest12252010
            [self presentModalViewController:controller animated:YES];
    //kc		[controller release];
        }
        [controller release];
    } else {
		UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection Alert!" 
														  message:@"This is an interactive report requiring Internet Connectivity.  Please obtain an Internet connection before selecting this option." 
														 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[myAlert show];
		[myAlert release];

    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}
- (IBAction) chartReport: (id) sender {

    if(lnController == nil)
        lnController = [[LineChart alloc] initWithNibName:@"LineChart" bundle:nil];
    
    if(addNavigationController == nil){
        addNavigationController = [[UINavigationController alloc] initWithRootViewController:lnController];
    }else {
        [addNavigationController release];
        addNavigationController = [[UINavigationController alloc] initWithRootViewController:lnController];
        
    }
    
    [self.navigationController presentModalViewController:addNavigationController animated:YES]; 

}

//*******************************************Reachability Modification*****************************************
- (void) configureTextField:  (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
    NSString* statusString= @"";
	hostError.text = @"";
	wifiError.text = @"";
	internetError.text = @"";
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
			hostError.text =  @"Access Not Available.  Internet connectivity required.";
	//kc		hostError.hidden = NO;
            //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
            connectionRequired= NO;  
            break;
        }
            /*           
             case ReachableViaWWAN:
             {
             statusString = @"Reachable WWAN";
             
             break;
             }
             case ReachableViaWiFi:
             {
             statusString = @"Reachable WiFi";
             break;
             }
             */
    }
    /*       if(connectionRequired)
     {
     statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
     }
     hostError.text= statusString;
     */
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
		[self configureTextField: curReach];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        /*        BOOL connectionRequired= [curReach connectionRequired];
         
         //kc        hostError.hidden = (netStatus != ReachableViaWWAN);
         NSString* baseLabel=  @"";
         if(connectionRequired)
         {
         baseLabel=  @"Cellular data network is available.\n  Internet traffic will be routed through it after a connection is established.";
         }
         else
         {
         baseLabel=  @"Cellular data network is active.\n  Internet traffic will be routed through it.";
         }
         hostError.text= baseLabel;
         */
    }
    
	if(curReach == internetReach)
	{	
		[self configureTextField: curReach];
	}
    //	if(curReach == wifiReach)
    //	{	
    //		[self configureTextField: curReach];
    //	}
	
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}
- (IBAction) viewReceipts: (id) sender {
	appDelegate = (ProofAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
	if ([appDelegate.eventArray count] == 0) {
		UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Proof of Expense currently has no receipt data." 
														  message:@"Please begin adding expense data." 
														 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[myAlert show];
		[myAlert release];
		
	}else {
        [appDelegate saveEvent];
        mtController = nil;
        [mtController release];
        if(mtController == nil)
            mtController = [[MTViewControllerE alloc] initWithNibName:@"MTViewControllerE" bundle:nil];
        
        if(addNavigationController == nil){
            addNavigationController = [[UINavigationController alloc] initWithRootViewController:mtController];
        }else {
            [addNavigationController release];
            addNavigationController = [[UINavigationController alloc] initWithRootViewController:mtController];
            
        }
        [self presentModalViewController:addNavigationController animated:YES]; 
        
        //kc        [self.navigationController presentModalViewController:addNavigationController animated:YES]; 
    }
}
@end

