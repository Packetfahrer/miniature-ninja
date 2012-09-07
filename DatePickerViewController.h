//
//  DatePickerViewController.h
//  Proof of Expense
//
//  Created by Kevin Collins on 2/28/12.
//  Copyright (c) 2012 Kevin Collins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatePickerViewController : UIViewController {
    IBOutlet UIDatePicker *datePicker;
}

@property (nonatomic, retain) UIDatePicker *datePicker;
//kc -(IBAction)buttonPressed:(id)sender;

@end
