//
//  AddLocation.swift
//  On The Map
//
//  Created by Brittany Mason on 10/2/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import AddressBookUI

class addLocation: UIViewController, UITextFieldDelegate  {
    
    // Mark: - Outlets
    /***************************************************************/
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterLinkTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    /***************************************************************/
    
    var address = ""
    var mediaURL = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var locationResponse = fullLocationResponse.LocationResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterLocationTextField.delegate = self
        enterLinkTextField.delegate = self
        nextButton.isEnabled = false
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //    let text = enterLocationTextField
    
    @IBAction func findLocationPressed(_ sender: Any) {
        
        
        /* Check if Text Fields are Empty */
        if enterLocationTextField.text!.isEmpty{
            displayAlert(title: "Location Text Field Empty", message: "You must enter your Location")
        }else if enterLinkTextField.text!.isEmpty{
            displayAlert(title: "URL Text Field Empty", message: "You must enter a Website")
        }else{
            address = enterLocationTextField.text!
            
            parametersAll.StudentLocation.mapString = enterLocationTextField.text!
            parametersAll.StudentLocation.mediaURL = enterLinkTextField.text!
            forwardGeocoding(address)
            findOnTheMapButton.backgroundColor = UIColor.blue
            findOnTheMapButton.isEnabled = false
            nextButton.isEnabled = true
            presentSubmitLocationView()
        }
    }
    
    //MARK: Activity Indicatior
    
    
    
    // MARK: -- Geolocation Helper Methods
    /***************************************************************/
    func forwardGeocoding(_ address: String) {
        showActivityIndicatory(uiView: activityIndicator)
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        guard (error == nil) else {
            print("Unable to Forward Geocode Address (\(String(describing: error)))")
            displayAlert(title: "Geocode Error", message: "Unable to Forward Geocode Address")
            return
        }
        
        if let placemarks = placemarks, placemarks.count > 0 {
            let placemark = placemarks[0]
            if let location = placemark.location {
                let coordinate = location.coordinate
                print("*** coordinate ***")
                print(placemark)
                
                
                locationResponse.latitude = coordinate.latitude
                locationResponse.longitude = coordinate.longitude
                print(coordinate.latitude)
                print(coordinate.longitude)
                
                
                if (placemark.locality != nil && placemark.administrativeArea != nil){
                    fullLocationResponse.LocationResponse.mapStrings = ("\(placemark.locality!),\(placemark.administrativeArea!)")
                }
                getUserName()
                //                var name = userNames.Users()
                //                name.firstName = parametersAll.StudentLocation.publicfirstName
                //                print(name.firstName)
                //                presentSubmitLocationView()
            } else {
                print("error")
                displayAlert(title: "User Data", message: "No Matching Location Found")
            }
            
        }
        self.printName()
    }
    
    
    
    func getUserName()   {
        taskgetPublicUserData {(success, errorString) in
            
            guard (errorString == nil) else{
                
                performUIUpdatesOnMain {
                    self.displayAlert(title: "User Data", message: errorString)
                }
                return
                
            }
            //            self.printName()
        }
    }
    
    
    
    func printName() {
        var name = userNames.Users()
        name.firstName = parametersAll.StudentLocation.publicfirstName
        name.lastName = parametersAll.StudentLocation.publiclastName
        print(name.firstName)
        print(name.lastName)
//        presentSubmitLocationView()
    }
    
    @IBAction func printNames(_ sender: Any) {
        var name = userNames.Users()
        name.firstName = parametersAll.StudentLocation.publicfirstName
        name.lastName = parametersAll.StudentLocation.publiclastName
        print(name.firstName)
        print(name.lastName)
        presentSubmitLocationView()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submitNewLocation" {
            if let addLinkVC = segue.destination as? addLink {
                addLinkVC.latitude = locationResponse.latitude
                addLinkVC.longitude = locationResponse.longitude
            }
        }
    }
    
    
    private func presentSubmitLocationView(){
        self.hideActivityIndicator(self.activityIndicator)
        performSegue(withIdentifier: "submitNewLocation", sender: self)
        
    }
    //
    // MARK: -- TextField Helper
    //        /***************************************************************/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    
    
}






