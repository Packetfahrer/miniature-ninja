//
//  Trans.m
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import "Trans.h"
static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *detailStmt = nil;
static sqlite3_stmt *updateStmt = nil;

@implementation Trans

@synthesize transID,contact_id, contactName, transaction_description, doe, isDirty, isDetailViewHydrated;

@synthesize text1, text2, text3, text4, text5, text6;


+ (void) getInitialDataToDisplay:(NSString *)dbPath {
	
	CustomerAppDelegate *appDelegate = (CustomerAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
    
		const char *sql = "select a.ID, a.contact_id, case when b.name ISNULL then ' ' else b.name end Name, case when transaction_description ISNULL then ' ' else transaction_description end transaction_description, trans_date, case when a.text1 ISNULL then ' ' else a.text1 end text1, case when a.text2 ISNULL then ' ' else a.text2 end text2, case when a.text3 ISNULL then ' ' else a.text3 end text3, case when a.text4 ISNULL then ' ' else a.text4 end text4, case when a.text5 ISNULL then ' ' else a.text5 end text5, case when a.text6 ISNULL then ' ' else a.text6 end text6  from trans a, contact b where a.contact_id = b.id  order by trans_date desc;";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {

            
            
            //kc            NSLog(@"i1:%d",i1);
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
				NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				Trans *transObj = [[Trans alloc] initWithPrimaryKey:primaryKey];
				int i = sqlite3_column_int(selectstmt, 1);
				transObj.contact_id = [NSString stringWithFormat:@"%d", i];
				transObj.contactName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
				transObj.transaction_description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
				transObj.doe = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
				transObj.text1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
				transObj.text2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 6)];
				transObj.text3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 7)];
				transObj.text4 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 8)];
				transObj.text5 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 9)];
				transObj.text6 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 10)];
                
 				transObj.isDirty = NO;
                
				[appDelegate.transArray addObject:transObj];
				[transObj release];
                
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
	transID = pk;
    
	isDetailViewHydrated = NO;
	
	return self;
}

- (void) deleteTrans {
	
	if(deleteStmt == nil) {
		const char *sql = "delete from trans where ID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	//When binding parameters, index starts from 1 and not zero.
	sqlite3_bind_int(deleteStmt, 1, transID);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
}

- (void) addTrans {
	
	if(addStmt == nil) {
		const char *sql = "insert into trans(contact_id, transaction_description, trans_date, text1, text2, text3, text4, text5, text6) Values(?, ?, ?, ?, ?, ?, ?,?, ?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
	int i =[contact_id intValue];  
	sqlite3_bind_int(addStmt, 1, i);      

	sqlite3_bind_text(addStmt, 2, [transaction_description UTF8String], -1, SQLITE_TRANSIENT);
    
	sqlite3_bind_text(addStmt, 3, [doe UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 4, [text1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 5, [text2 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 6, [text3 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 7, [text4 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 8, [text5 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 9, [text6 UTF8String], -1, SQLITE_TRANSIENT);
    
    
    
    
	
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		transID = sqlite3_last_insert_rowid(database);
    
    
	//Reset the add statement.
	sqlite3_reset(addStmt);
}

- (void) hydrateDetailViewData {
	
	//If the detail view is hydrated then do not get it from the database.
	if(isDetailViewHydrated) return;
	
	if(detailStmt == nil) {
		const char *sql = "select a.ID, a.contact_id, case when b.name ISNULL then ' ' else b.name end Name, case when transaction_description ISNULL then ' ' else transaction_description end transaction_description, trans_date, case when a.text1 ISNULL then ' ' else a.text1 end text1, case when a.text2 ISNULL then ' ' else a.text2 end text2, case when a.text3 ISNULL then ' ' else a.text3 end text3, case when a.text4 ISNULL then ' ' else a.text4 end text4, case when a.text5 ISNULL then ' ' else a.text5 end text5, case when a.text6 ISNULL then ' ' else a.text6 end text6  from trans a, contact b where a.id = ? and a.contact_id = b.id  order by trans_date desc;";
		if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
	}
	
	//kc110609	sqlite3_bind_int(detailStmt, 1, contactID);
	sqlite3_bind_int(detailStmt, 1, transID);
	
	if(SQLITE_DONE != sqlite3_step(detailStmt)) {
		;
	}
	else
		NSAssert1(0, @"Error while getting the event. '%s'", sqlite3_errmsg(database));
	
	//Reset the detail statement.
	sqlite3_reset(detailStmt);
	
	//Set isDetailViewHydrated as YES, so we do not get it again from the database.
	isDetailViewHydrated = YES;
}

- (void) saveAllData {
	
	if(isDirty) {
		
		if(updateStmt == nil) {
			const char *sql = "update trans Set doe = ?, transaction_description = ?, text1 = ? Where ID = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) 
				NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_text(updateStmt, 1, [doe UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStmt, 2, [transaction_description UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStmt, 3, [text1 UTF8String], -1, SQLITE_TRANSIENT);
		
		sqlite3_bind_int(updateStmt, 4, transID);
		
		
		if(SQLITE_DONE != sqlite3_step(updateStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(updateStmt);
		
		isDirty = NO;
	}
	
	//Reclaim all memory here.
	[doe release];
	doe = nil;
	
	isDetailViewHydrated = NO;
}

- (void)setContact_id:(NSString *)newValue {	
	self.isDirty = YES;
	[contact_id release];
	contact_id = [newValue copy];
	//kc111009	NSLog(@"set contact_id: %@",contact_id);
}
- (void)setTransaction_description:(NSString *)newValue {
  	self.isDirty = YES;
	[transaction_description release];
	transaction_description = [newValue copy];  
}
- (void)setContactName:(NSString *)newValue {
  	self.isDirty = YES;
	[contactName release];
	contactName = [newValue copy];  
}
- (void)setDoe:(NSString *)newAge {
	
	self.isDirty = YES;
	[doe release];
	doe = [newAge copy];
}
- (void)setText1:(NSString *)newValue {
  	self.isDirty = YES;
	[text1 release];
	text1 = [newValue copy];
}
- (void)setText2:(NSString *)newValue {
  	self.isDirty = YES;
	[text2 release];
	text2 = [newValue copy];
}- (void)setText3:(NSString *)newValue {
  	self.isDirty = YES;
	[text3 release];
	text3 = [newValue copy];
}- (void)setText4:(NSString *)newValue {
  	self.isDirty = YES;
	[text4 release];
	text4 = [newValue copy];
}- (void)setText5:(NSString *)newValue {
  	self.isDirty = YES;
	[text5 release];
	text5 = [newValue copy];
}- (void)setText6:(NSString *)newValue {
  	self.isDirty = YES;
	[text6 release];
	text6 = [newValue copy];
}
- (void) dealloc {
	
	[doe release];
	[contactName release];
	[contact_id release];
    [transaction_description release];
    [doe release];
    [text1 release];
    [text2 release];
    [text3 release];
    [text4 release];
    [text5 release];
    [text6 release];
	[super dealloc];
}


@end

