//
//  AddReminderDetailViewController.m
//  MapKit
//
//  Created by MICK SOUMPHONPHAKDY on 9/3/15.
//  Copyright (c) 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import "AddReminderDetailViewController.h"
#import "Constants.h"

@interface AddReminderDetailViewController ()

@end

@implementation AddReminderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	NSLog(@"%f", self.annotation.coordinate.latitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)setReminder:(id)sender {
  
  // initialize your parse object
  PFObject *reminder = [PFObject objectWithClassName:@"Reminder"];
  reminder[@"pinTitle"] = self.pinNameLabel.text;
  reminder[@"pinDescription"] = self.pinNameLabel.text;
  reminder[@"radius"] = [NSNumber numberWithFloat:self.radiusSlider.value];
  // create PFGeoPoint based on the annotation passed in
  PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.annotation.coordinate.latitude longitude:self.annotation.coordinate.longitude];
  reminder[@"location"] = point;
  reminder[@"user"] = @"Mick"; // this should be PFUserObject [PFUser currentUser];
  
  // Save Reminder Object
  [reminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
    if (error) {
      NSLog(@"Error in Saving Reminder");
    }else{
      [self.navigationController popToRootViewControllerAnimated:YES];
      //remember to convert the NSNumber for longitude latitude as GFFloat coordinate
      NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithDouble:self.annotation.coordinate.latitude], @"latitude",
                                [NSNumber numberWithDouble:self.annotation.coordinate.longitude], @"longitude",
                                self.pinNameLabel.text, @"pinTitle", [NSNumber numberWithFloat:self.radiusSlider.value], @"radius",
                                nil];
      [[NSNotificationCenter defaultCenter] postNotificationName:kReminderNotification object:self userInfo:userInfo];
    }
  }];
}

- (IBAction)sliderAction:(id)sender {
  // get the slider value and convert to 1000s
  float sliderValue = self.radiusSlider.value;
  // convert it to string
  NSString *slideString = [NSString stringWithFormat:@"%.f", sliderValue];
  // assign the value to the radius label text
  self.radiusLabelText.text = slideString;
}
@end
