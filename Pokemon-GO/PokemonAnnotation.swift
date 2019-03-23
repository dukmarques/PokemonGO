//
//  PokemonAnnotation.swift
//  Pokemon-GO
//
//  Created by Eduardo on 23/03/19.
//  Copyright © 2019 Curso IOS. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinates: CLLocationCoordinate2D) {
        self.coordinate = coordinates
    }
}
