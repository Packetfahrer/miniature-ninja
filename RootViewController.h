//
//  RootViewController.h
//  Proof of Expense
//
//  Created by Kevin Collins on 3/6/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class DetailViewEventController;
@class RootViewController;
@class LineChart;
@class Event;
@class MTViewControllerE;
//kcproof @class EventAttendance;




@interface RootViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate> {
    IBOutlet UITableView *tableView;

	IBOutlet UINavigationBar *navigationBar;
	ProofAppDelegate *appDelegate;
	RootViewController *rootViewController;
	DetailViewEventController *dvController;
    LineChart *lnController;
	NSString *bypassUserImage; 
    //kc11292009	UINavigationController *navigationController;
    MTViewControllerE *mtController;
	UINavigationController *addNavigationController;
	//kc11192009	Tab1Controller *tab1;
    NSString *strEmailDetail;
	NSString *strEmailFinal;
	NSString *strEmailHeader;
    float   fTotalExpenses;
    int     iTotalExpenses;
    IBOutlet UILabel *lblTotalExpenseCount;
    IBOutlet UILabel *lblTotalExpenses;
    
    IBOutlet UILabel *wifiError;
	IBOutlet UILabel *internetError;
	IBOutlet UILabel *hostError;
	
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;

}

//kc 11292009 @property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) NSString *bypassUserImage;
@property (nonatomic, retain) NSString *strEmailDetail;
@property (nonatomic, retain) NSString *strEmailFinal;
@property (nonatomic, retain) NSString *strEmailHeader;



- (IBAction) emailReport: (id) sender;
- (IBAction) viewReceipts: (id) sender;


@end
