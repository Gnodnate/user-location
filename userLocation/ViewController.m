//
//  ViewController.m
//  userLocation
//
//  Created by Daniel Tan on 2017/3/9.
//  Copyright © 2017年 Gnodnate. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@property (strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *course;

@end

@implementation ViewController

@synthesize locationManager = _locationManger;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkGPS:(id)sender {
    NSString *msg = @"";
    if (!([CLLocationManager locationServicesEnabled])) {
        msg = @"GPS is off";
    } else {
        if (nil == _locationManger) {
            _locationManger = [[CLLocationManager alloc] init];
            _locationManger.delegate = self;
            _locationManger.desiredAccuracy = kCLLocationAccuracyKilometer;
            _locationManger.distanceFilter = 1;
            _locationManger.headingFilter = 1;
        }
    
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                [_locationManger requestWhenInUseAuthorization];
                break;
                
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            case kCLAuthorizationStatusAuthorizedAlways:
//            case kCLAuthorizationStatusAuthorized:
                [_locationManger stopUpdatingHeading];
                [_locationManger startUpdatingHeading];
                [_locationManger stopUpdatingLocation];
                [_locationManger startUpdatingLocation];
                break;
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:
                msg = @"Location server isn't usable";
                break;
        }
    
    }
    if (msg.length > 0) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:nil
                                    message:msg
                                    preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * _Nonnull action) {
                                            
                                        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }


}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            [_locationManger requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            //            case kCLAuthorizationStatusAuthorized:
            [_locationManger startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
            NSString *msg = @"Location server isn't usable";
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:nil
                                        message:msg
                                        preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *defaultAction = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                
                                            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message: error.localizedDescription
                                preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * _Nonnull action) {
                                        
                                    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        self.latitude.text = [NSString stringWithFormat:@"%.2f%@", location.coordinate.latitude, location.coordinate.latitude > 0 ? @"N" : @"S"];
        self.longitude.text = [NSString stringWithFormat:@"%.2f%@", location.coordinate.longitude, location.coordinate.longitude > 0 ? @"E" : @"W"];
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    self.course.text = [NSString stringWithFormat:@"%.1f", newHeading.trueHeading];
}
@end
