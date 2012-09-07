//
//  Contact.h
//  PartyTwacker
//
//  Created by Kevin Collins on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <sqlite3.h>



@interface Contact : NSObject {
	
	NSInteger contactID;
	NSString *contactName;
	NSString *contact_id;
	NSString *dob;
	NSString *height; 
	NSString *gender;
	
	//Intrnal variables to keep track of the state of the object.
	BOOL isDirty;
	BOOL isDetailViewHydrated;
	
	NSArray		*statusUpdates;
	
}

@property (nonatomic, readonly) NSInteger contactID;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *dob;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *contact_id;

@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;


//Static methods.
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
- (void) deleteContact;
- (void) addContact;
- (void) hydrateDetailViewData;
- (void) saveAllData;

@end
