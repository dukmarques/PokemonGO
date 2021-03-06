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
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self //This class will manage the map
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Recover Pokemons
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recoverAllPokemons()
        
        //Show pokemons
        //Runs code in a time interval
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
            if let coordinate = self.locationManager.location?.coordinate{
                let totalPokemons = UInt32(self.pokemons.count)
                let indexRandomPokemon = arc4random_uniform(totalPokemons)
                
                let pokemon = self.pokemons[Int(indexRandomPokemon)]
                
                let annotation = PokemonAnnotation(coordinates: coordinate, pokemon: pokemon)
                
                let latRandom = (Double(arc4random_uniform(400)) - 200) / 100000.0
                let longRandom = (Double(arc4random_uniform(400)) - 200) / 100000.0
                
                annotation.coordinate.latitude += latRandom
                annotation.coordinate.longitude += longRandom
                
                self.map.addAnnotation(annotation) //Add annotation on the map
            }
        }
    }

    //ViewFor annotation - Show annotations with image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        //Checks whether the bookmark is the user's or annotations
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "Image")
        }else{
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            
            annotationView.image = UIImage(named: pokemon.nameImage!)
        }
        
        //Sets the size of the image in the annotation
        var frame = annotationView.frame
        frame.size.height = 40
        frame.size.width = 40
        annotationView.frame = frame
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        let pokemon = (annotation as! PokemonAnnotation).pokemon
        
        mapView.deselectAnnotation(annotation, animated: true) //Unmark annotation
        
        if annotation is MKUserLocation {
            return
        }
        
        //Center the selected pokemon on the map
        if let coordAnnotation = annotation?.coordinate {
            let distance: CLLocationDistance = 200
            //New method that replaces: MKCoordinateRegionMakeWithDistance()
            let region = MKCoordinateRegion.init(center: coordAnnotation, latitudinalMeters: distance, longitudinalMeters: distance)
            
            map.setRegion(region, animated: true)
        }
        
        // Wait 1 second and do the capture scan
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.locationManager.location?.coordinate {
                if self.map.visibleMapRect.contains(MKMapPoint.init(coord)) {
                    self.coreDataPokemon.savePokemon(pokemon: pokemon)
                    self.map.removeAnnotation(annotation!) //Remove annotation
                    
                    //Alert for when the pokemon is captured
                    let alertController = UIAlertController(title: "Parabéns!", message: "Você capturou um \(pokemon.name!)", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Atenção!", message: "Você precisa se aproximar mais para capturar o \(pokemon.name!)", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
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
