//
//  CustomerFirstViewController.m
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import "CustomerFirstViewController.h"
#import "RootViewController.h"
#import "TranViewController.h"

@implementation CustomerFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"Home");
        self.tabBarItem.image = [UIImage imageNamed:@"53-house"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	appDelegate = (CustomerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void) viewContacts:(id)sender {
    [appDelegate saveContact];
    if(rtController == nil)
        rtController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    
    if(addNavigationController == nil){
        addNavigationController = [[UINavigationController alloc] initWithRootViewController:rtController];
    }else {
        [addNavigationController release];
        addNavigationController = [[UINavigationController alloc] initWithRootViewController:rtController];
        
    }
    [self presentModalViewController:addNavigationController animated:YES]; 
    
}
- (void) viewTransactions:(id)sender {
    [appDelegate saveTrans];
    if(tvController == nil)
        tvController = [[TranViewController alloc] initWithNibName:@"TranViewController" bundle:nil];
    
    if(addNavigationController == nil){
        addNavigationController = [[UINavigationController alloc] initWithRootViewController:tvController];
    }else {
        [addNavigationController release];
        addNavigationController = [[UINavigationController alloc] initWithRootViewController:tvController];
        
    }
    [self presentModalViewController:addNavigationController animated:YES]; 
    
}

@end
