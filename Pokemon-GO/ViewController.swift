//
//  ViewController.swift
//  Pokemon-GO
//
//  Created by Eduardo on 21/03/19.
//  Copyright © 2019 Curso IOS. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self //This class will manage the map
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Show pokemons
        //Runs code in a time interval
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            print("Show anotation")
            if let coordinate = self.locationManager.location?.coordinate{
                let annotation = MKPointAnnotation()
                
                let latRandom = (Double(arc4random_uniform(400)) - 200) / 100000.0
                let longRandom = (Double(arc4random_uniform(400)) - 200) / 100000.0
                
                annotation.coordinate = coordinate
                annotation.coordinate.latitude += latRandom
                annotation.coordinate.longitude += longRandom
                
                self.map.addAnnotation(annotation) //Add annotation on the map
            }
        }
    }
    
    //Retrieve user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if count < 3 {
            self.centralize()
            count += 1
        }else{
            //Stop update location
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if ((status != .authorizedWhenInUse) && (status != .notDetermined)){
            //Location Alert authorization
            let alertController = UIAlertController(title: "Permissão de localização", message: "Para que você possa caçar pokemons, precisamos da sua localização, por favor habilite.", preferredStyle: .alert)
            
            let actionSetting = UIAlertAction(title: "Abrir Configurações", style: .default) { (alertSettings) in
                if let settings = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(settings as URL)
                }
            }
            
            let actionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(actionSetting)
            alertController.addAction(actionCancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func centerPlayer(_ sender: Any) {
        self.centralize()
    }
    
    @IBAction func openPokedex(_ sender: Any) {
        
    }
    
    func centralize() {
        if let coordinates = locationManager.location?.coordinate {
            let distance: CLLocationDistance = 200
            //New method that replaces: MKCoordinateRegionMakeWithDistance()
            let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: distance, longitudinalMeters: distance)
            
            map.setRegion(region, animated: true)
        }
    }
}
