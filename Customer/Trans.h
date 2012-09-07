//
//  Trans.h
//  Customer
//
//  Created by Kevin Collins on 9/3/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

/*kc
 CREATE TABLE trans (id integer primary key autoincrement, contact_id numeric, event_type_id numeric, event_description_id numeric,  automobiles_id numeric, date_of_event text, event_photo text, odometer text, cost_per_gallon text, gallons text, total_costs text, fuel_type text, gas_brand text, location text, payment_type text, miles text, miles_per_gallon text, start_odometer text, end_odometer, flight_number text, confirmation_number, arival_date text, departure_date text, sku text, notes text, text1 text, text2 text, text3 text, text4 text, text5 text, text6 text);
 kc*/

@interface Trans : NSObject {
	
	NSInteger transID;
	NSString *contact_id;    
    NSString *contactName;
	NSString *transaction_description;
	NSString *doe;
    NSString *text1;
    NSString *text2;
    NSString *text3;
    NSString *text4;
    NSString *text5;
    NSString *text6;
    
//Intrnal variables to keep track of the state of the object.
	BOOL isDirty;
	BOOL isDetailViewHydrated;
	
	
}

@property (nonatomic, readonly) NSInteger transID;
@property (nonatomic, copy) NSString *contact_id;
@property (nonatomic, copy) NSString *transaction_description;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *doe;
@property (nonatomic, copy) NSString *text1;
@property (nonatomic, copy) NSString *text2;
@property (nonatomic, copy) NSString *text3;
@property (nonatomic, copy) NSString *text4;
@property (nonatomic, copy) NSString *text5;
@property (nonatomic, copy) NSString *text6;





@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;


//Static methods.
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
- (void) deleteTrans;
- (void) addTrans;
- (void) hydrateDetailViewData;
- (void) saveAllData;

@end
