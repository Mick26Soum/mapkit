//
//  AddReminderDetailViewController.h
//  MapKit
//
//  Created by MICK SOUMPHONPHAKDY on 9/3/15.
//  Copyright (c) 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface AddReminderDetailViewController : UIViewController

// data is passed in via segue
@property(strong, nonatomic) MKPointAnnotation *annotation;
@property (weak, nonatomic) IBOutlet UITextField *pinNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *pinDescText;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabelText;

- (IBAction)setReminder:(id)sender;
- (IBAction)sliderAction:(id)sender;


@end
