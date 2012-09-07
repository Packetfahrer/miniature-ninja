//
//  Contact.m
//  
//
//  Created by Kevin Collins on 09/02/2012
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"


static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *detailStmt = nil;
static sqlite3_stmt *updateStmt = nil;

@implementation Contact

@synthesize contactID, contactName, dob, isDirty, isDetailViewHydrated, height, gender, contact_id;


+ (void) getInitialDataToDisplay:(NSString *)dbPath {
	
	CustomerAppDelegate *appDelegate = (CustomerAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		const char *sql = "select ID,case when Name ISNULL then ' ' else Name end Name, case when dob ISNULL then ' ' else dob end dob, case when height ISNULL then ' ' else height end height, case when gender ISNULL then ' ' else gender end gender, id as contactID from contact order by Name";
		sqlite3_stmt *selectstmt;

		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"Yes"] forKey:@"contactAdded"];

				NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				Contact *contactObj = [[Contact alloc] initWithPrimaryKey:primaryKey];
				contactObj.contactName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				contactObj.dob = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
				contactObj.height = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];

				contactObj.gender = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
				int i = sqlite3_column_int(selectstmt, 5);
				contactObj.contact_id =  [NSString stringWithFormat:@"%d", i];				//kc111009				
				
				
				contactObj.isDirty = NO;
				[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%@",contactObj.contactName] forKey:@"defaultUser"];
				[appDelegate.contactArray addObject:contactObj];
				[contactObj release];

			}
		}
	}
	else
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
}

+ (void) finalizeStatements {
	
	if (database) sqlite3_close(database);
	if (deleteStmt) sqlite3_finalize(deleteStmt);
	if (addStmt) sqlite3_finalize(addStmt);
	if (detailStmt) sqlite3_finalize(detailStmt);
	if (updateStmt) sqlite3_finalize(updateStmt);
}

- (id) initWithPrimaryKey:(NSInteger) pk {
	
	[super init];
	contactID = pk;
	[[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%d",contactID] forKey:@"contactID"];

	isDetailViewHydrated = NO;
	
	return self;
}

- (void) deleteContact {
	
	if(deleteStmt == nil) {
		const char *sql = "delete from contact where ID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	//When binding parameters, index starts from 1 and not zero.
	sqlite3_bind_int(deleteStmt, 1, contactID);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
}

- (void) addContact {
	
	if(addStmt == nil) {
		const char *sql = "insert into contact(name, dob, height, gender) Values(?, ?, ?, ?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_text(addStmt, 1, [contactName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 2, [dob UTF8String], -1, SQLITE_TRANSIENT);

	sqlite3_bind_text(addStmt, 3, [height UTF8String], -1, SQLITE_TRANSIENT);

	sqlite3_bind_text(addStmt, 4, [gender UTF8String], -1, SQLITE_TRANSIENT);
	
	
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		contactID = sqlite3_last_insert_rowid(database);


	//Reset the add statement.
	sqlite3_reset(addStmt);
}

- (void) hydrateDetailViewData {
	
	//If the detail view is hydrated then do not get it from the database.
	if(isDetailViewHydrated) return;
	
	if(detailStmt == nil) {
		const char *sql = "Select name, dob, height, gender, id as contact_id  from contact Where ID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
	}
	
	//kc110609	sqlite3_bind_int(detailStmt, 1, contactID);
	sqlite3_bind_int(detailStmt, 1, contactID);
	
	if(SQLITE_DONE != sqlite3_step(detailStmt)) {
		;
	}
	else
		NSAssert1(0, @"Error while getting the price of coffee. '%s'", sqlite3_errmsg(database));
	
	//Reset the detail statement.
	sqlite3_reset(detailStmt);
	
	//Set isDetailViewHydrated as YES, so we do not get it again from the database.
	isDetailViewHydrated = YES;
}

- (void) saveAllData {
	
	if(isDirty) {
		
		if(updateStmt == nil) {
			const char *sql = "update contact Set name = ?, dob = ?, height = ?, gender = ? Where ID = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) 
				NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_text(updateStmt, 1, [contactName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStmt, 2, [dob UTF8String], -1, SQLITE_TRANSIENT);

		sqlite3_bind_text(updateStmt, 3, [height UTF8String], -1, SQLITE_TRANSIENT);

		sqlite3_bind_text(updateStmt, 4, [gender UTF8String], -1, SQLITE_TRANSIENT);
		
		
		sqlite3_bind_int(updateStmt, 5, contactID);
		
		
		if(SQLITE_DONE != sqlite3_step(updateStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(updateStmt);
		
		isDirty = NO;
	}
	
	//Reclaim all memory here.
	[contactName release];
	contactName = nil;
	[dob release];
	dob = nil;
	[height release];
	height = nil;
	[gender release];
	gender = nil;
	[contact_id release];
	contact_id = nil;
	
	isDetailViewHydrated = NO;
}

- (void)setContact_id:(NSString *)newValue {
	
	self.isDirty = YES;
	[contact_id release];
	contact_id = [newValue copy];
	//kc111009	NSLog(@"set contact_id: %@",contact_id);
}

- (void)setContactName:(NSString *)newValue {
	
	self.isDirty = YES;
	[contactName release];
	contactName = [newValue copy];
}




- (void)setDob:(NSString *)newAge {
	
	self.isDirty = YES;
	[dob release];
	dob = [newAge copy];
}

- (void)setHeight:(NSString *)theCalorie {
	
	self.isDirty = YES;
	[height release];
	height = [theCalorie retain];
}

- (void)setGender:(NSString *)theGender {
	
	self.isDirty = YES;
	[gender release];
	gender = [theGender retain];
}



- (void) dealloc {
	
	[height release];
	[dob release];
	[gender release];
	[contactName release];
	[contact_id release];
	[super dealloc];
}


@end
