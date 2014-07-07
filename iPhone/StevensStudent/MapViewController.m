//
//  MapViewController.m
//  StevensStudent
//
//  Created by toby on 5/1/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MapPin.h"
#import "BuildingTableViewCell.h"
#import "BuildingDetailsViewController.h"

@interface MapViewController ()<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) MapPin *pin;


@end

@implementation MapViewController
{
    NSArray *pins;
    NSArray *locations;
    NSArray *longitude;
    NSArray *latitude;
    NSArray *searchResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setHidden:YES];
    [self fetchData];
    self.searchBar.showsCancelButton = YES;
    [self.searchBar setShowsCancelButton:YES animated:YES];
    CLLocationCoordinate2D coord = {.latitude =  40.744575, .longitude = -74.025868};
    MKCoordinateSpan span = {.latitudeDelta = 0.01, .longitudeDelta =  0.01};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    if (self.segueResult != nil) {
        self.pin = [[MapPin alloc] init];
        self.pin.title = self.segueResult;
        self.pin.longitude = self.segueLongitude;
        self.pin.latitude = self.segueLatitude;
        [self updateMapViewAnnotations];
    }
    
    
}

- (void) fetchData
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Map Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"building" ofType:@"json"];
        pins = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                  options:0
                                                    error:nil];
    });
}


#pragma -mark SearchBar Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tableView setHidden:NO];
    [self filterContentForSearchText:searchText];
}

-(void) filterContentForSearchText:searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"code beginswith[c] %@ OR name beginswith[c] %@", searchText, searchText];
    searchResults = [pins filteredArrayUsingPredicate:resultPredicate];
    [self.tableView reloadData];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.tableView setHidden:YES];
}

#pragma -mark MapView Methods

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapViewAnnotations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseId = @"PhotosByPhotographerMapViewController";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        view.canShowCallout = YES;
        UIButton *disclosureButton = [[UIButton alloc] init];
        [disclosureButton setBackgroundImage:[UIImage imageNamed:@"disclosure"] forState:UIControlStateNormal];
        [disclosureButton sizeToFit];
        view.rightCalloutAccessoryView = disclosureButton;
        
    }
    
    view.annotation = annotation;
    
    return view;
}

- (void)updateMapViewAnnotations
{
    if (self.pin) {
        //NSMutableArray *array = [[NSMutableArray alloc] init];
        //[array addObject:self.pin];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:self.pin];
        [self.mapView selectAnnotation:self.pin animated:YES];
        //[self.mapView showAnnotations:array animated:YES];
    }
}

#pragma -mark TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count] != 0 ? [searchResults count] : [pins count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MapCell";
    BuildingTableViewCell *cell = (BuildingTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BuildingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display details in the table cell
    if ([searchResults count] != 0) {
        cell.buildingCode.text = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"code"];
        cell.buildingName.text = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"name"];
    } else {
        cell.buildingCode.text = [[pins objectAtIndex:indexPath.row] valueForKey:@"code"];
        cell.buildingName.text = [[pins objectAtIndex:indexPath.row] valueForKey:@"name"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView setHidden:YES];
    [self.view endEditing:YES];
    self.pin = [[MapPin alloc] init];
    if ([searchResults count] != 0) {
        self.pin.title = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"name"];
        self.pin.longitude = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"longitude"];
        self.pin.latitude = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"latitude"];
    } else {
        self.pin.title = [[pins objectAtIndex:indexPath.row] valueForKey:@"name"];
        self.pin.longitude = [[pins objectAtIndex:indexPath.row] valueForKey:@"longitude"];
        self.pin.latitude = [[pins objectAtIndex:indexPath.row] valueForKey:@"latitude"];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self updateMapViewAnnotations];

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    BuildingDetailsViewController *bdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BuildingDetailsViewController"];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:bdvc animated:YES];
}

@end
