//
//  PokeAgendaViewController.swift
//  Pokemon-GO
//
//  Created by Eduardo on 23/03/19.
//  Copyright © 2019 Curso IOS. All rights reserved.
//

import UIKit

class PokeAgendaViewController: UIViewController {
    var capturedPokemons: [Pokemon] = []
    var uncapturedPokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreDataPokemon = CoreDataPokemon()
        self.capturedPokemons = coreDataPokemon.retrieveCapturedPokemons(captured: true)
        self.uncapturedPokemons = coreDataPokemon.retrieveCapturedPokemons(captured: false)
        
        print(String(self.uncapturedPokemons.count))
    }
    
    @IBAction func backMap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
