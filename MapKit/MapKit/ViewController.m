//
//  ViewController.m
//  MapKit
//
//  Created by MICK SOUMPHONPHAKDY on 8/31/15.
//  Copyright (c) 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "ViewController.h"
#import "AddReminderDetailViewController.h"


// put constant here if you only want it to be accesible to only this file
// do not use the extern keyword

@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

	@property (weak, nonatomic) IBOutlet MKMapView *mapView;
	@property (strong, nonatomic) CLLocationManager *locationManager;
	@property (strong, nonatomic) UILongPressGestureRecognizer *longPressRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.mapView.delegate = self;
	self.locationManager.delegate = self;
	self.mapView.showsUserLocation = true;
  
  // Listen for Notification Reminder
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderNotification:) name:kReminderNotification object:nil];

	
	// Initialize gesture object and set the action
	self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action: @selector(longPressDetected:)];
	self.longPressRecognizer.minimumPressDuration = 1.0;
	
	[self.mapView addGestureRecognizer:self.longPressRecognizer];
	
	NSLog(@"%d",[CLLocationManager authorizationStatus]);
	
	// Init and configure Core Location Manager
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[self.locationManager requestAlwaysAuthorization];
	[self.locationManager startUpdatingLocation];
  

	//add parse PFGeoPoint Object
	//Create a place PFObject and add the PFGeoPoint to this object
  
  // Retrieve parse user object
  // Determine the number of reminder objects assigned to this user
  // Create an NSMutable Array to hold annotation objects
  // Create an NSMutable Array to hold overlay objects
  // loop throught the reminder objects and add annotations
  //
  
  
  // parse through reminder object in parse
  // set the NSMutable Array annotations
  // set the NSMutable Array fo overlays
  // for each instance of the parsing add the annotation and overlays to the array
  // call add overlays and add annotations
  
  // Set Pin Up
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  annotation.coordinate	 = CLLocationCoordinate2DMake(47.634352,-122.278894);
  annotation.title = @"Test Existing Pin";
  annotation.subtitle = @"Already Pinned";
  [self.mapView addAnnotation:annotation];

  // MapView Overlay testing
  // add region
  MKCoordinateRegion region;
  region.center.latitude = 47.634352;
  region.center.longitude = -122.278894;
  region.span.latitudeDelta = .20f; //Make this constant
  region.span.longitudeDelta = .20f;
  [self.mapView setRegion:region animated:YES];
  // create circle
  MKCircle *circle = [MKCircle circleWithCenterCoordinate:region.center radius:500];
  [self.mapView addOverlay:circle];
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
//	[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(46.3508, -124.0536), 10, 10) animated:true];
	[self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)longPressDetected:(UILongPressGestureRecognizer*)gestureRecognizer{
	
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
		
		CGPoint longPressLocation = [gestureRecognizer locationInView:self.mapView];
		CLLocationCoordinate2D coordinate = [self.mapView convertPoint:longPressLocation toCoordinateFromView:self.mapView];
		// initiate an configure annotation
    // Retrieve existing pins from parse
		MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
		annotation.coordinate	 = coordinate;
		annotation.title = @"Setting Pin Reminder";
		annotation.subtitle = @"Confirm";
		[self.mapView addAnnotation:annotation];
	}
  
}

- (IBAction)longBeachButtonPressed:(id)sender {
	
	[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(46.3508, -124.0536), 100, 100) animated:true];
}

- (IBAction)capitolHillButtonPressed:(id)sender {
	
	[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(38.8897, -77.0111), 10, 10) animated:true];
  NSLog(@"test");
}

- (IBAction)newYorkButtonPressed:(id)sender {
	
	[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.7127, -74.0059), 10, 10) animated:true];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	
	if ([segue.identifier isEqualToString:@"showReminderDetail"]){
		AddReminderDetailViewController* destinationVC = segue.destinationViewController;
		MKAnnotationView *view = (MKAnnotationView*)sender; //cast sender as it's sent as id, so it can be anyType/AnyObject
		destinationVC.annotation = view.annotation;
	}
  
}

#pragma mark - ReminderNotification Method

-(void)reminderNotification:(NSNotification*)notification{
  // obtain data passed via userInfo dict
  NSDictionary *userInfo = notification.userInfo;
  // get longitude, latitude, and radius and convert it to point
  float latitude = [userInfo[@"latitude"] floatValue];
  float longitude = [userInfo[@"longitude"] floatValue];
  float radius = [userInfo[@"radius"] floatValue];
  NSLog(@"%f,%f", latitude, longitude);
  // get the title
  // set the corelocation
  // convert the data from NSNumber to CGPoint
  // create a map overlay
  // set Region monitoring
  if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(latitude, longitude) radius:radius identifier:userInfo[@"pinTitle"]];
    [self.locationManager startMonitoringForRegion:region];
    
    // create a map overlay here
    MKCoordinateRegion setRegion;
    setRegion.center.latitude = latitude;
    setRegion.center.longitude = longitude;
    setRegion.span.latitudeDelta = .20f; //Make this constant
    setRegion.span.longitudeDelta = .20f;
    [self.mapView setRegion:setRegion animated:YES];
    // create circle
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:setRegion.center radius:radius];
    [self.mapView addOverlay:circle];
    
  }
}

-(void)dealloc{
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
	
  switch (status) {
  case kCLAuthorizationStatusAuthorizedWhenInUse:
			[self.locationManager startUpdatingLocation];
			break;
  default:
			break;
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
	
  CLLocation *location = locations.lastObject;
//	NSLog(@"lat: %f, long: %f, speed: %f", location.coordinate.latitude, location.coordinate.longitude, location.speed);
	
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  NSLog(@"entered region!");
  
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  
  notification.alertTitle = @"Reminder Triggered!";
  notification.alertBody = @"You've entered your monitered region!";
  
  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
  NSLog(@"exited region!");

  UILocalNotification *notification = [[UILocalNotification alloc] init];
  
  notification.alertTitle = @"Reminder Triggered!";
  notification.alertBody = @"You've exited your monitered region!";
  
  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
  
}

#pragma mark - Annotation-PinViewDelegate

	// This method fires everytime a new annotation is added onto the map, sending the  annotation as a parameter
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

	// if annotation is of type user location, return no annotation and keep the blue dot user location
	if ([annotation isKindOfClass:[MKUserLocation class]]){
		return nil;
	}
	
	// if no annotation is of Type MKUserLocation exist, try to create a view of pin type while dequeing
	MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
	pinView.annotation = annotation;
		
	if (!pinView) {
			pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
	}
	
	pinView.animatesDrop = true;
	pinView.pinColor = MKPinAnnotationColorGreen;
	pinView.canShowCallout = true;
	UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointIcon32.png"]];  	// create an image
	pinView.leftCalloutAccessoryView = image;
	pinView.rightCalloutAccessoryView = [UIButton buttonWithType: UIButtonTypeInfoDark];
	
	return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
	// check to determine is annotation isKindOfClass:MKUserLocation class]]
	//	if (![view.annotation isKindOfClass:[MKUserLocation class]])
	//	return;
	
	// perform segue using the view = is the annotation as the sender
	[self performSegueWithIdentifier:@"showReminderDetail" sender:view];
}

#pragma mark - MKMapViewOverlay

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
  
  // create a circle
  MKCircleRenderer *view = [[MKCircleRenderer alloc]initWithOverlay:overlay];
  // set the view color
  view.fillColor = [UIColor colorWithRed:255.0f/255.0f
                                   green:0.0f/255.0f
                                    blue:128.0f/255.0f
                                   alpha:0.4f];
  // set the line stroke
  view.strokeColor = [UIColor colorWithRed:255.0f/255.0f
                                     green:0.0f/255.0f
                                      blue:128.0f/255.0f
                                     alpha:1.0f];
  // set the lineWidth
  view.lineWidth = 1;
  return view;
}

@end


