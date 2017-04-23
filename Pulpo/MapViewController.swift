//
//  MapViewController.swift
//  Pulpo
//
//  Created by David Vazquez on 4/19/17.
//  Copyright © 2017 davidfresh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import UserNotifications
import Social

class MapViewController: UIViewController{
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var locationTarget = CLLocation()
    var  circle200 = PlaceCirle()
   var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let notificationContent = UNMutableNotificationContent()
    @IBOutlet weak var distanceToTargetLabel: UILabel!
    @IBOutlet weak var btn_restarTarget: UIButton!
    @IBOutlet weak var btn_confirmTarget: UIButton!
    @IBOutlet weak var mapCenterPin: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var heightMapView: NSLayoutConstraint!
    @IBOutlet weak var confirmTarget: UIView!
    @IBOutlet weak var nameTargetLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        placeTextField.delegate = self
        locationManager.delegate = self
        UNUserNotificationCenter.current().delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .fitness
        locationManager.requestWhenInUseAuthorization()
        configurationInitial()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
  //MARK: Method to post tweet
  func postTweet(){
    if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
      let socialController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
      socialController?.setInitialText("El objetivo tiene latitud \(locationTarget.coordinate.latitude)  y longitud\(locationTarget.coordinate.longitude)")
      socialController?.add(captureScreen())
      self.present(socialController!, animated: true, completion: nil)
    }
  }
  
  func captureScreen() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  //MARK: Method to tracking target
  func selectTarget(){
    locationTarget = CLLocation(latitude: SessionAdmin.getLatitudTarget(), longitude: SessionAdmin.getLongitudTarget())
    circle200 = PlaceCirle(potition: locationTarget.coordinate, radio: 200, color: UIColor.Pulpo200())
    let circle100 = PlaceCirle(potition: locationTarget.coordinate, radio: 100, color: UIColor.Pulpo100())
    let circle50 = PlaceCirle(potition: locationTarget.coordinate, radio: 50, color: UIColor.Pulpo50())
    let circle10 = PlaceCirle(potition: locationTarget.coordinate, radio: 10, color: UIColor.Pulpo10())
    let marker = GMSMarker(position: locationTarget.coordinate)
    circle200.map = mapView
    circle100.map = mapView
    circle50.map = mapView
    circle10.map = mapView
    marker.map = mapView
    mapView.camera = GMSCameraPosition(target: locationTarget.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
    hideSerchElements()
    SessionAdmin.setIsTraking(attempts: true)
    locationManager.startUpdatingLocation()
    locationManager.allowsBackgroundLocationUpdates = true
  }
  
  // MARK: Methods help to show/hide elemts UI
  func configurationInitial(){
    btn_restarTarget.fadeOut(duration: 0.25)
    btn_confirmTarget.layer.cornerRadius = 5
    btn_restarTarget.layer.cornerRadius = 5
    mapCenterPin.center =  CGPoint(x: mapView.frame.size.width / 2, y: mapView.frame.size.height / 2)
    distanceToTargetLabel.fadeOut(duration: 0.25)
    if SessionAdmin.getIsTraking() == true {
      selectTarget()
    }
  }
  
  func hideSerchElements(){
    mapCenterPin.fadeOut(duration: 0.25)
    placeTextField.fadeOut(duration: 0.25)
    btn_confirmTarget.fadeOut(duration: 0.25)
    btn_restarTarget.fadeIn(duration: 0.25)
    distanceToTargetLabel.fadeIn(duration: 0.25)
  }
  func showElementsUI(){
    mapCenterPin.fadeIn(duration: 0.25)
    placeTextField.fadeIn(duration: 0.25)
    confirmTarget.fadeIn(duration: 0.25)
    btn_restarTarget.fadeOut(duration: 0.25)
    btn_confirmTarget.fadeIn(duration: 0.25)
    distanceToTargetLabel.fadeOut(duration: 0.25)
  }
  
  //MARK: @IBActions
  @IBAction func startGoTarget(_ sender: Any) {
    selectTarget()
  }
  
  @IBAction func btn_RestarTarget(_ sender: Any) {
    SessionAdmin.removeUserDesaults()
    mapView.clear()
    showElementsUI()
  }
  
  //MARK:Method configuration of notifications
  func configurationNOtifications(mensaje: String){
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
        switch notificationSettings.authorizationStatus {
        case .notDetermined:
          requestAuthorization(completionHandler: { (success) in
            guard success else { return }
          })
        case .authorized:
          mapLocalNotification(mensaje)
        case .denied:
          print("Application Not Allowed to Display Notifications")
        }
      }
    } else {
      // Fallback on earlier versions
    }
    
    func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
      // Request Authorization
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
          if let error = error {
            print("Request Authorization Failed (\(error), \(error.localizedDescription))")
          }
          
          completionHandler(success)
        }
      } else {
        // Fallback on earlier versions
      }
    }
    
    //MARK: Configure Notification Content
    func mapLocalNotification(_ Msj:String) {
      notificationContent.title = "Pulpo"
      notificationContent.body = Msj
      let notificationRequest = UNNotificationRequest(identifier: "pulpo_local_notification", content: notificationContent, trigger: nil)
      UNUserNotificationCenter.current().add(notificationRequest) { (error) in
        if let error = error {
          print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
        }
      }
    }
    
  }
  
}

//MARK: Method UITextFieldDelegate
extension MapViewController: UITextFieldDelegate{
  func textFieldDidBeginEditing(_ textField: UITextField) {
    let autocompleteController = GMSAutocompleteViewController()
    autocompleteController.delegate = self
    present(autocompleteController, animated: true, completion: nil)
  }
}

//MARK: Method UNUserNotificationCenterDelegate
extension MapViewController: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert])
  }
  
}


// MARK: - Location Manager Delegate
extension MapViewController: CLLocationManagerDelegate{
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if SessionAdmin.getIsTraking() == true {
      let currentLocation = locations.first
      let distanceInMeters = currentLocation?.distance(from: locationTarget)
      print("la distancia en metros \(distanceInMeters!)")
      distanceToTarget(distance: distanceInMeters!)
    } else {
      if let location = locations.first {
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
      }
    }
    
  }
  
  func distanceToTarget(distance: CLLocationDistance){
    let distan = Int(distance)
    if distance > 200.0{
      nameTargetLabel.text = "Estás muy lejos del punto objetivo"
      distanceToTargetLabel.text = "La distancia al punto objetivo es \(distan)m."
      let state = UIApplication.shared.applicationState
      if state == .background {
        print("App in Background")
        if SessionAdmin.getNotificationActive() != 1 {
          configurationNOtifications(mensaje: "Estás muy lejos del punto objetivo")
          SessionAdmin.setNotificationActive(attempts: 1)
        }else {
          
        }
      }
      
    }
    
    if distance > 100.0 && distance <= 200.0{
      nameTargetLabel.text = "Estás lejos del punto objetivo"
      distanceToTargetLabel.text = "La distancia al punto objetivo es \(distan)m."
      if SessionAdmin.getNotificationActive() != 2 {
        let state = UIApplication.shared.applicationState
        if state == .background {
          print("App in Background")
          configurationNOtifications(mensaje: "Estás lejos del punto objetivo")
          SessionAdmin.setNotificationActive(attempts: 2)
        }
      }else {
        
      }
      
    }
    
    if distance > 50.0 && distance <= 100.0{
      nameTargetLabel.text = "Estás próximo al punto objetivo"
      distanceToTargetLabel.text = "La distancia al punto objetivo es \(distan)m."
      if SessionAdmin.getNotificationActive() != 3 {
        let state = UIApplication.shared.applicationState
        if state == .background {
          print("App in Background")
          configurationNOtifications(mensaje: "Estás próximo al punto objetivo")
          SessionAdmin.setNotificationActive(attempts: 3)
        }
      }else {
        
      }
    }
    
    if distance > 10.0 && distance <= 50.0 {
      nameTargetLabel.text  = "Estás muy próximo al punto objetivo"
      distanceToTargetLabel.text = "La distancia al punto objetivo es \(distan)m."
      if SessionAdmin.getNotificationActive() != 4 {
        let state = UIApplication.shared.applicationState
        if state == .background {
          print("App in Background")
          configurationNOtifications(mensaje: "Estás muy próximo al punto objetivo")
          SessionAdmin.setNotificationActive(attempts: 4)
        }
      }else {
        
      }
    }
    
    if distance < 10.0 {
      nameTargetLabel.text = "Estás en el punto objetivo"
      distanceToTargetLabel.text = "La distancia al punto objetivo es \(distan)m."
      if SessionAdmin.getNotificationActive() != 5 {
        postTweet()
        SessionAdmin.setNotificationActive(attempts: 5)
        let state = UIApplication.shared.applicationState
        if state == .background {
          print("App in Background")
          configurationNOtifications(mensaje: "Estás en el punto objetivo")
          
        }
      }else {
        
      }
    }
    
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse || status == .authorizedAlways{
      locationManager.startUpdatingLocation()
      mapView?.isMyLocationEnabled = true
      mapView?.settings.compassButton = true
      mapView?.settings.myLocationButton = true
    }
  }
  
  
}

//MARK: Method delegate GMSAutocomplete.
extension MapViewController: GMSAutocompleteViewControllerDelegate {
  
  //Handling user selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    dismiss(animated: true, completion: nil)
    mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 18, bearing: 0, viewingAngle: 0)
    mapCenterPin.fadeIn(duration: 0.5)
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }
  
  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
}

//MARK: Method GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate{
  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    if SessionAdmin.getIsTraking() == true{
      hideSerchElements()
    }else {
      if(gesture){
        mapCenterPin.fadeIn(duration: (0.25))
        mapView.selectedMarker = nil
      }
    }
    
  }
  
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    if SessionAdmin.getIsTraking() == true {
      
    }else {
      locationTarget = CLLocation()
      let location  = CLLocation(coordinate: position.target, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: Date())
      geocodinToCordinateToName(location: location)
      SessionAdmin.setLongitudTarget(attempts: location.coordinate.longitude)
      SessionAdmin.setLatititudTarget(attempts: location.coordinate.latitude)
    }
  }
  //MARK: Method geocoder coordinates to address
  func geocodinToCordinateToName(location: CLLocation){
    if SessionAdmin.getIsTraking() == true{
      
    }else {
      geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        // Place details
        var placeMark: CLPlacemark!
        placeMark = placemarks?[0]
        // Location name
        if let locationName = placeMark.addressDictionary!["Name"] as? String {
          print(locationName, terminator: "")
          let string = "Confirma tu punto objetivo en  \(locationName)" as NSString
          let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName: UIFont(name:"Helvetica",size: 15.0)!])
          let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)]
          let color  = [NSForegroundColorAttributeName : UIColor.PulpoAzul2()]
         
          attributedString.addAttributes(boldFontAttribute, range: string.range(of: locationName ))
          attributedString.addAttributes(color, range: string.range(of: locationName ))
          
          self.nameTargetLabel.attributedText = attributedString
          
          
        }
        
      })
    }
    
  }
  
  
}

