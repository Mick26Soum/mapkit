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
	
	// Initialize gesture object and set the action
	self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action: @selector(longPressDetected:)];
	self.longPressRecognizer.minimumPressDuration = 1.0;
	
	[self.mapView addGestureRecognizer:self.longPressRecognizer];
	
	NSLog(@"%d",[CLLocationManager authorizationStatus]);
	
	// Init and configure Location Manager
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[self.locationManager requestWhenInUseAuthorization];
	[self.locationManager startUpdatingLocation];
  

	//add parse PFGeoPoint Object
	//Create a place PFObject and add the PFGeoPoint to this object
  
  // Retrieve parse user object
  // Determine the number of reminder objects assigned to this user
  // Create an NSMutable Array to hold annotation objects
  // Create an NSMutable Array to hold overlay objects
  // loop throught the reminder objects and add annotations
  //
  
  
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
	
//	CLLocation *location = locations.lastObject;
//	NSLog(@"lat: %f, long: %f, speed: %f", location.coordinate.latitude, location.coordinate.longitude, location.speed);
	
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
  // return the view
  return view;
}

@end








//- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance {
//  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//  [defaults setBool:1 forKey:@"Users"];
//  PFQuery *query = [PFQuery queryWithClassName:@"_User"];
//  // If no objects are loaded in memory, we look to the cache first to fill the table
//  // and then subsequently do a query against the network.
//  if (query.countObjects == 0) {
//    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//  }
//  
//  // Create a PFGeoPoint using the current location (to use in our query)
//  PFGeoPoint *userLocation =
//  [PFGeoPoint geoPointWithLatitude:[Global shared].LastLocation.latitude longitude:[Global shared].LastLocation.longitude];
//  
//  // Create a PFQuery asking for all wall posts 1km of the user
//  [query whereKey:@"CurrentCityCoordinates" nearGeoPoint:userLocation withinKilometers:10];
//  // Include the associated PFUser objects in the returned data
//  [query includeKey:@"objectId"];
//  //Run the query in background with completion block
//  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//    if (error) { // The query failed
//      NSLog(@"Error in geo query!");
//    } else { // The query is successful
//      defaultPeople = [[NSMutableArray alloc] init];
//      // 1. Find new posts (those that we did not already have)
//      // In this array we'll store the posts returned by the query
//      NSMutableArray *people = [[NSMutableArray alloc] initWithCapacity:100];
//      // Loop through all returned PFObjects
//      for (PFObject *object in objects) {
//        // Create an object of type Person with the PFObject
//        Person *p = [[Person alloc] init];
//        NSString *userID = object.objectId;
//        p.objectId = userID;
//        
//        NSString *first = [object objectForKey:@"FirstName"];
//        p.name = first;
//        
//        NSString *city = [object objectForKey:@"CurrentCity"];
//        p.location = city;
//        
//        NSString *age = [object objectForKey:@"Age"];
//        p.age = age;
//        
//        NSString *gender = [object objectForKey:@"Gender"];
//        p.gender = gender;
//        
//        NSString *tagline = [object objectForKey:@"Tagline"];
//        p.tagline = tagline;
//        
//        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[object objectForKey:@"PictureURL"]]]]];
//        p.image = img;
//        if (![p.objectId isEqualToString:myID] && ![p.gender isEqualToString:myGender] && ![people containsObject:p]) {
//          [people addObject:p];
//          NSLog(@"Person: %@",p);
//        }
//      }
//      [defaultPeople addObjectsFromArray:people];
//      [[Global shared] setDefaultPeople:defaultPeople];
//      NSLog(@"Default People: %@",[Global shared].defaultPeople);
//      NSLog(@"Success. Retrieved %lu objects.", (unsigned long)[Global shared].defaultPeople.count);
//      if (defaultPeople.count == 0) {
//        [defaults setBool:0 forKey:@"Users"];
//      } else {
//        [defaults setBool:1 forKey:@"Users"];
//      }
//    }
//  }];
//}

//
//annotationQuery.findObjectsInBackgroundWithBlock {
//  (posts, error) -> Void in
//  if error == nil {
//    // The find succeeded.
//    println("Successful query for annotations")
//    let myPosts = posts as [PFObject]
//    
//    for post in myPosts {
//      let point = post["Location"] as PFGeoPoint
//      let annotation = MKPointAnnotation()
//      annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
//      self.mapView.addAnnotation(annotation)
//    }
//  } else {
//    // Log details of the failure
//    println("Error: \(error)")
//  }
//    }


