//
//  MapViewController.swift
//  On The Map
//
//  Created by Brittany Mason on 10/1/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

//

import UIKit
import MapKit

class viewController: UIViewController, MKMapViewDelegate {
    
    
    
    // **** OUTLETs ****
    @IBOutlet weak var mapView: MKMapView!
    // ---------------- //
    
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        getUserInfo()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getUserInfo()
    }
    
    
    func getUserInfo() {
        
        taskGetStudentLocations { (studentInfo, error) in
            if let studentInfo = studentInfo {
                parametersAll.StudentLocation.studentsLocDict = studentInfo
                performUIUpdatesOnMain {
                    self.populateMapView()
                }
            } else {
                performUIUpdatesOnMain {
                    self.displayAlert(title: "Error", message: "Unable to get student locations.")
                }
                print(error as Any)
            }
        }
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        /* Logout the User */
        logout { (success, errorString) in
            if success {
                performUIUpdatesOnMain {
//                    let vc = addLocation()
//                    vc.dismiss(animated:true,completion:nil)
                    self.dismiss(animated:true,completion:nil)
                }
            } else {
                print(errorString as Any)
                
                self.displayAlert(title: "Error", message: "Logout was unsuccessful")
            }
        }
        
    }
    
    
    
    //MARK: Helper functions
    func populateMapView(){
        var annotations = [MKPointAnnotation]()
        for student in parametersAll.StudentLocation.studentsLocDict{
            //needs to stay student.xxx for pins to show
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            /* The lat and long are used to create a CLLocationCoordinates2D instance */
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            /* Create the annotation and set its coordiate, title, and subtitle properties */
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = "\(student.mediaURLs)"
            /* Place the annotation in an array of annotations */
            annotations.append(annotation)
            
        }
        /* When the array is complete, we add the annotations to the Map View */
        self.mapView.addAnnotations(annotations)
        print("Annotations are now added to the Map View.")
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            let app = UIApplication.shared
            if let annotation = view.annotation, let urlString = annotation.subtitle {
                if let url = URL(string: urlString!) {
                    if app.canOpenURL(url) {
                        app.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    } else {
                        //                            displayAlert(title: "Invalid URL", message: "Selected URL unable to be opened.")
                    }
                } else {
                    //                        displayAlert(title: "Invalid URL", message: "Not a valid URL.")
                }
            }
        }
    }
}



fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}





