//
//  PokeAgendaViewController.swift
//  Pokemon-GO
//
//  Created by Eduardo on 23/03/19.
//  Copyright © 2019 Curso IOS. All rights reserved.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var capturedPokemons: [Pokemon] = []
    var uncapturedPokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreDataPokemon = CoreDataPokemon()
        self.capturedPokemons = coreDataPokemon.retrieveCapturedPokemons(captured: true)
        self.uncapturedPokemons = coreDataPokemon.retrieveCapturedPokemons(captured: false)
    }
    
    @IBAction func backMap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.capturedPokemons.count
        } else {
            return self.uncapturedPokemons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = capturedPokemons[indexPath.row]
        }else{
            pokemon = uncapturedPokemons[indexPath.row]
        }
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        //Configure cell
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.nameImage!)
        
        return cell
    }
    
    //Set the titles of the sections of the table
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        }else{
            return "Não Capturados"
        }
    }
}
