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
    var pokemon: Pokemon
    
    init(coordinates: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinates
        self.pokemon = pokemon
    }
}
