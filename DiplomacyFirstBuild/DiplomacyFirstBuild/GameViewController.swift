//
//  GameViewController.swift
//  DiplomacyFirstBuild
//
//  Created by Tommy Roz on 3/20/20.
//  Copyright © 2020 Tommy Roz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var first: UILabel!
    
    @IBOutlet weak var second: UILabel!
    
    @IBOutlet weak var third: UILabel!
    
    @IBAction func england(_ sender: Any) {
        if choice == 1{
        }
        if choice == 1 {
            firstMoveLoc = "England"
            choice += 1
        }else if choice == 2{
            secondMoveLoc = "England"
            choice = 1
            currentStore1 = Move(whoIsMoving: firstMoveLoc, whereTo: secondMoveLoc, team: &troop2, troopStore: &currentStore2)
            troopstore["troop2"] = currentStore1
        }
    }
    @IBAction func TheNorthSea(_ sender: Any) {
        if choice == 1{
            firstMoveLoc = "the North Sea"
            choice += 1
        }else if choice == 2{
            secondMoveLoc = "the North Sea"
            choice = 1
            currentStore1 = Move(whoIsMoving: firstMoveLoc, whereTo: secondMoveLoc, team: &troop2, troopStore: &currentStore2)
            troopstore["troop2"] = currentStore1
        }
    }
    @IBAction func Norway(_ sender: Any) {
        if choice == 1{
            firstMoveLoc = "Norway"
            choice += 1
        }else if choice == 2{
            secondMoveLoc = "Norway"
            choice = 1
            currentStore1 = Move(whoIsMoving: firstMoveLoc, whereTo: secondMoveLoc, team: &troop2, troopStore: &currentStore2)
            troopstore["troop2"] = currentStore1
        }
    }
    @IBAction func Sweden(_ sender: Any) {
        if choice == 1{
            firstMoveLoc = "Sweden"
            choice += 1
        }else if choice == 2{
            secondMoveLoc = "Sweden"
            choice = 1
            currentStore1 = Move(whoIsMoving: firstMoveLoc, whereTo: secondMoveLoc, team: &troop2, troopStore: &currentStore2)
            troopstore["troop2"] = currentStore1
        }
    }
    @IBAction func Kiel(_ sender: Any) {
        if choice == 1{
            firstMoveLoc = "Kiel"
            choice += 1
        }else if choice == 2{
            secondMoveLoc = "Kiel"
            choice = 1
            currentStore1 = Move(whoIsMoving: firstMoveLoc, whereTo: secondMoveLoc, team: &troop2, troopStore: &currentStore2)
            troopstore["troop2"] = currentStore1
        }
    }
    @IBAction func InputMove(_ sender: Any) {
        let dataSend = DataSend(loc: troopstore)
        guard let uploadData = try? JSONEncoder().encode(dataSend) else {
            return
        }
        let url = URL(string: "https://oq20qcckri.execute-api.us-east-1.amazonaws.com/live3/main")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print("Server error")
                    return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print("got data: \(dataString)")
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postName()
        getDataFirst()
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    @IBAction func go(_ sender: Any) {
        getData(completion: { () -> () in
            if currentStore1 != "Fleets can only travel on water."{
                self.first.text = "Tommy's fleet is in \(troop1.loc)."
            }else{
                self.first.text = currentStore1
            }
            print("Went")
            self.second.text = "Jake's fleet is in \(troop2.loc)"
            self.third.text = "Matt's troop is in \(troop3.loc)"
        })
    }
    fileprivate func getDataFirst(){
        let url = URL(string: "https://oq20qcckri.execute-api.us-east-1.amazonaws.com/live3/data")!
        
        URLSession.shared.dataTask(with: url) {(data, response, error)
            in
            do{
                let users = try JSONDecoder().decode([Users].self, from: data!)
                print(users)
                for user in users {
                    if user.theNorthSea == currentUser{
                        startingCountry = "the North Sea"
                        troopstore = ["troop1":currentStore1]
                    }else if user.Kiel == currentUser{
                        startingCountry = "Kiel"
                        troopstore = ["troop3":currentStore3]
                    }else if user.Norway == currentUser{
                        startingCountry = "Norway"
                        troopstore = ["troop2":currentStore2]
                    }
                    initLoc1 = user.troops["troop1"]!
                    initLoc2 = user.troops["troop2"]!
                    initLoc3 = user.troops["troop3"]!
                    print("The North Sea: \(user.theNorthSea), Kiel: \(user.Kiel), Norway: \(user.Norway). You occupy: \(startingCountry), \(user.troops["troop2"]!)")
                }
                print("Troop 1 is in \(troop2.loc), troop 2 is in \(troop1.loc), troop 3 is in \(troop3.loc).")
                
            }catch{
                print("There was an error")
            }
            //initTroopLocs()
        }.resume()
        
    }
}
fileprivate func getData(completion: () -> Void){
    let url = URL(string: "https://oq20qcckri.execute-api.us-east-1.amazonaws.com/live3/data")!
    
    URLSession.shared.dataTask(with: url) {(data, response, error)
        in
        do{
            let users = try JSONDecoder().decode([Users].self, from: data!)
            print(users)
            for user in users {
                currentStore1 = user.troops["troop1"]!
                currentStore2 = user.troops["troop2"]!
                currentStore3 = user.troops["troop3"]!
            }
        }catch{
            print("There was an error")
        }
        //initTroopLocs()
    }.resume()
    completion()
}
fileprivate func postName(){
    let dataSend = name(name: currentUser)
    guard let uploadData = try? JSONEncoder().encode(dataSend) else {
        return
    }
    let url = URL(string: "https://oq20qcckri.execute-api.us-east-1.amazonaws.com/live3/name")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode) else {
                print("Server error")
                return
        }
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print("got data: \(dataString)")
            if dataString.components(separatedBy: ",").count == 3{
                var own = dataString.components(separatedBy: ",")
                own[0] = own[0].replacingOccurrences(of: "\"", with: "", options:[])
                own[0] = own[0].replacingOccurrences(of: "\\", with: "", options:[])
                own[1] = own[1].replacingOccurrences(of: "\"", with: "", options:[])
                own[1] = own[1].replacingOccurrences(of: "\\", with: "", options:[])
                own[2] = own[2].replacingOccurrences(of: "\"", with: "", options:[])
                own[2] = own[2].replacingOccurrences(of: "\\", with: "", options:[])
                for (i,v) in own.enumerated(){
                    switch i{
                    case 0:
                        countryControlers["the North Sea"] = v
                    case 1:
                        countryControlers["Norway"] = v
                    case 2:
                        countryControlers["Kiel"] = v
                    default:
                        return
                    }
                }
                print(countryControlers)
            }
        }
    }
    task.resume()
}
fileprivate func initTroopLocs(){
    if startingCountry == "the North Sea"{
        troopstore["troop1"] = "the North Sea"
    }else if startingCountry == "Norway"{
        troopstore["troop2"] = "Norway"
    }else if startingCountry == "Kiel"{
        troopstore["troop3"] = "Kiel"
    }
    print(troopstore)
}
var countryControlers: Dictionary<String,String> = ["the North Sea":"","Norway":"","Kiel":""]
var troopstore:Dictionary<String,String> = [:]
var choice: Int = 1
var firstMoveLoc: String = ""
var secondMoveLoc: String = ""
let currentUser: String = "Jake"
public var startingCountry: String = ""
struct Users: Decodable{
    let theNorthSea: String
    let Norway: String
    let Kiel: String
    let troops: Dictionary<String,String>
}
struct DataSend: Codable {
    let loc: Dictionary<String,String>
}
struct name: Codable {
    let name: String
}
