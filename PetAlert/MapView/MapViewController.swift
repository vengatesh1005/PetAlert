//
//  MapViewController.swift
//  PetAlert
//
//  Created by vengatesh.c on 04/11/24.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces
class MapViewController: UIViewController {
    //MARK: ------  IBOutlet ------
    @IBOutlet var mapViewOutlet: GMSMapView!
    @IBOutlet var currentLocationView: UIView!
    @IBOutlet var currentLocationPin: UIImageView!
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet var getCurrentLocationButtonView: UIView!
    @IBOutlet var confirmAddressButtonView: UIView!
    @IBOutlet var confirmButtonOutlet: UIButton!
    
    //MARK: ------  Variables  ------
    var locationManager: CLLocationManager!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isMapRequestFromPetListPage {
            setupLocationService()
        }
        setupView()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.buttonSetupView()
        }
    }
    
    //MARK: ------  Page Setup  ------
    func setupView()
    {
        // For Loading Mapview from PetList Page.
        if isMapRequestFromPetListPage {
            getCurrentLocationButtonView.isHidden = true
            confirmAddressButtonView.isHidden = false
            confirmButtonOutlet.setTitle("OK", for: .normal)
            currentLocationLabel.text = "Pet Lost Location : \(currentPetListData["petlostaddress"] ?? "")"
            
            let latitude = Double(currentPetListData["petlostlocationlat"]!)
            let longitude = Double(currentPetListData["petlostlocationlong"]!)
            let location = CLLocation(latitude: latitude!, longitude: longitude!)
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16.0)
            self.mapViewOutlet.camera = camera
            isMapRequestFromPetListPage = false
        }
        currentLocationView.drawBorder()
        getCurrentLocationButtonView.drawBorder()
    }
    func buttonSetupView()
    {
        //Setup corner radius dynamically
        confirmButtonOutlet.roundCorners(.allCorners, radius: confirmButtonOutlet.frame.height / 2)
        //Button Configuration for (iOS 15.0,*)
        confirmButtonOutlet.buttonConfiguration()
    }
    
    //MARK: ------  Request Location Service  ------
    func setupLocationService()
    {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.mapViewOutlet?.isMyLocationEnabled = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: IBActions
    @IBAction func moveToCurrentLocationAction(_ sender: Any) {
        
        if userCurrentLocation != nil {
            self.mapViewOutlet.isMyLocationEnabled = true
            let camerazoom = mapViewOutlet.camera.zoom
            let camera = GMSCameraPosition.camera(withLatitude: (userCurrentLocation.coordinate.latitude), longitude: (userCurrentLocation.coordinate.longitude), zoom: camerazoom)
            mapViewOutlet.animate(to: camera)
        } else {
            setupLocationService()
        }
    }
    @IBAction func locationChangeButtonAction(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        
    }
    @IBAction func confirmButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - Extension
extension MapViewController : CLLocationManagerDelegate,GMSMapViewDelegate {
    
    //MARK: ------  Location Delegates  ------
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Location authorization is not determined.")
            manager.requestWhenInUseAuthorization()
            manager.requestAlwaysAuthorization()
        case .restricted:
            print("Location is restricted.")
            self.showAlert(title: "Location Services Disabled", message: "Please enable Location Services in Settings", okActionTitle: "OK")
        case .denied:
            print("Location permission denied.")
            self.showAlert(title: "Location Services Disabled", message: "Please enable Location Services in Settings", okActionTitle: "OK")
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapViewOutlet.clear()
        let userloc = locations[0] as CLLocation
        userCurrentLocation = userloc
        petLostLocation = userloc
        let camera = GMSCameraPosition.camera(withLatitude: userloc.coordinate.latitude, longitude: userloc.coordinate.longitude, zoom: 16.0)
        mapViewOutlet.camera = camera
        mapViewOutlet.delegate = self
        getAddressfrom(location: userloc) { address, error in
            if address != ""
            {
                self.currentLocationLabel.text = address
                userCurrentLocationAddress = address
                petLostLocationAddress = address
                self.confirmAddressButtonView.isHidden = false
            } else {
                self.currentLocationLabel.text = error
            }
        }
        manager.stopUpdatingLocation()
    }
    //MARK: ------  Google MapView Delegates  ------
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let latitude = position.target.latitude
        let longitude = position.target.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        petLostLocation = location
        getAddressfrom(location: location) { address, error in
            if address != ""
            {
                self.currentLocationLabel.text = address
                petLostLocationAddress = address
                self.confirmAddressButtonView.isHidden = false
            } else {
                self.currentLocationLabel.text = error
            }
        }
    }
}

// MARK: - Extension
extension MapViewController : GMSAutocompleteViewControllerDelegate {
    //MARK: ------  Google Places AutoComplete Delegates  ------
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        currentLocationLabel.text = place.name
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        petLostLocation = location
        getAddressfrom(location: location) { address, error in
            if address != ""
            {
                self.currentLocationLabel.text = address
                petLostLocationAddress = address
                self.confirmAddressButtonView.isHidden = false
            } else {
                self.currentLocationLabel.text = error
            }
        }
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
        self.mapViewOutlet.camera = camera
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
