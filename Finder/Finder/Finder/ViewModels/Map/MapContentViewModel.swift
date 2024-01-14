//
//  MapContentViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/01/2024.
//

import Foundation
import MapKit
import SwiftUI
import CoreLocation

class MapContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var mapService: MapService = MapService()
    @Published var region: MKCoordinateRegion
    private var items: [BarWithUsers]
    private var zoom: Double

    private var locationManager: CLLocationManager?
    @Published var userLocation: CLLocationCoordinate2D?
    
    var distanceToUser: String? = nil
    var distanceLabel: String? = nil
    var item: BarWithUsers? = nil
    
    init(items: [BarWithUsers], zoom: Double) {
        self.items = items
        self.zoom = zoom
        self.region = mapService.calculateRegion(for: items)
        
        super.init()
                
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    func centerMapOnLocation(location: BarWithUsers) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude - 0.002, longitude: location.longitude)
        let newRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 1.0)) {
                self.region = newRegion
            }
        }
    }

    var mapAnnotations: [BarWithUsers] {
        return items
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
//            print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            userLocation = location.coordinate
            if let currentItem = item {
                distanceToUser = calculateDistanceToSelectedItem(selectedItem: currentItem).distance
                distanceLabel = calculateDistanceToSelectedItem(selectedItem: currentItem).unit
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error)")
    }
    
    func centerOnUserLocation() {
        guard let location = userLocation else { return }
        let newRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        withAnimation(.easeInOut(duration: 1.0)) {
            region = newRegion
        }
    }
    
    func centerOnBarsLocation() {
        withAnimation(.easeInOut(duration: 1.0)) {
            region = mapService.calculateRegion(for: items)
        }
    }
    
    func calculateDistanceToSelectedItem(selectedItem: BarWithUsers?) -> (distance: String, unit: String) {
        guard let userLocation = userLocation,
              let selectedItem = selectedItem else {
            return ("0.00", "m")
        }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let selectedItemCLLocation = CLLocation(latitude: selectedItem.latitude, longitude: selectedItem.longitude)
        let distanceInMeters = userCLLocation.distance(from: selectedItemCLLocation)
        
        let distance: String
        let unit: String
        
        if distanceInMeters < 1000 {
            // Distance is less than 1000 meters, format in meters with 2 decimal places
            distance = String(format: "%.2f", distanceInMeters)
            unit = "m"
        } else {
            // Distance is 1000 meters or more, convert to kilometers and format with 4 decimal places
            let distanceInKilometers = distanceInMeters / 1000
            distance = String(format: "%.4f", distanceInKilometers)
            unit = "km"
        }
        
        return (distance, unit)
    }

    func setBarWithUsers(item: BarWithUsers){
        self.item = item
    }
}
