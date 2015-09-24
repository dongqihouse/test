//
//  ViewController.m
//  ui_地图3
//
//  Created by dq on 15/9/24.
//  Copyright (c) 2015年 dq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
    [self findLocation];
    [self findshanghu];
}
- (void) findLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:@"南京理工大学泰州科技学院" completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil) {
            CLPlacemark *location = placemarks[0];
            MKCoordinateRegion region = MKCoordinateRegionMake(location.location.coordinate, MKCoordinateSpanMake(0.03, 0.03));
            [self.mapView setRegion:region];
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            annotation.coordinate = location.location.coordinate;
            annotation.title = location.name;
            [self.mapView addAnnotation:annotation];
            [self.mapView selectAnnotation:annotation animated:YES];
           
        }
        else
        {
            NSLog(@"11");
        }
    }];
}
- (void) findshanghu
{
    // 本地商户查询
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(32.462856, 119.940759);
    MKCoordinateSpan span= MKCoordinateSpanMake(0.05, 0.05) ;
    
    //创建查询需求
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery = @"餐馆";
    request.region = MKCoordinateRegionMake(coordinate, span);
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for (MKMapItem *item in response.mapItems)
        {
            CLLocationDegrees la =item.placemark.location.coordinate.latitude;
            CLLocationDegrees lo =item.placemark.location.coordinate.longitude;
            if ((fabs(coordinate.latitude-la)<0.1)&&(fabs(lo-coordinate.longitude)<0.1)) {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.placemark.name;
                [self.mapView addAnnotation:annotation];
            }
        }
        [self performSelector:@selector(showRoute:) withObject:nil afterDelay:3];
    }];
}
- (void) showRoute:(NSValue *)coordinateValue
{
    MKPlacemark *placenark = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(32.462856, 119.940759) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"工商银行",@"Street",@"取款机",@"name" ,nil]];
    MKMapItem *item = [[MKMapItem alloc]initWithPlacemark:placenark
                       ];
    [MKMapItem openMapsWithItems:@[item] launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsDirectionsModeKey, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
