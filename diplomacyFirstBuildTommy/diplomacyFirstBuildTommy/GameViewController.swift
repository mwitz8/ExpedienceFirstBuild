//
//  GameViewController.swift
//  diplomacyFirstBuildTommy
//
//  Created by Tommy Roz on 3/25/20.
//  Copyright © 2020 Tommy Roz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var first: UILabel!
    
    @IBOutlet weak var second: UILabel!
    
    @IBOutlet weak var third: UILabel!
    
    @IBAction func changeText(_ sender: Any) {
        print(troop1.loc)
        self.first.text = "Tommy's fleet is in \(troop1.loc)."
        self.second.text = "Jake's fleet is in \(troop2.loc)"
        self.third.text = "Matt's troop is in \(troop3.loc)"
    }
    @IBAction func england(_ sender: Any) {
        if choice == 1{
        }
        if choice == 1 {
            firstMoveLoc = England
            choice += 1
        }else if choice == 2{
            secondMoveLoc = England
            choice = 1
            currentStore1 = Move(whoIsMoving: firstMoveLoc, whereTo: secondMoveLoc, team: &troop1, troopStore: &currentStore1)
            resetLocations()
            //print(currentStore2)
            troop1.currentResult = currentStore1
            print("Troop 1 locprev " + troop1.locPrev)
            troopstore["troop1"] = currentStore1
            debug()
        }
    }
    @IBAction func TheNorthSea(_ sender: Any) {
        if choice == 1{
            firstMoveLoc = theNorthSea
            choice += 1
        }else if choice == 2{
            secondMoveLoc = theNorthSea
            choice = 1
            print("Data prior to move func: " + firstMoveLoc.name)
            print(secondMoveLoc)
            print(currentStore1)
            currentStore1 = Move(whoIsMoving: firstMoveLoc, whereTo: secondMoveLoc, team: &troop1, troopStore: &currentStore1)
            resetLocations()
            //print(currentStore2)
            troop1.currentResult = currentStore1
            print("Troop 1 locprev " + troop1.locPrev)
            print("Current result" + troop1.currentResult)
            troopstore["troop1"] = currentStore1
            debug()
        }
    }
    @IBAction func Norway(_ sender: Any) {
        if choice == 1{
            firstMoveLoc = norway
            choice += 1
        }else if choice == 2{
            secondMoveLoc = norway
            choice = 1
            currentStore1 = Move(whoIsMoving: firstMoveLoc, whereTo: secondMoveLoc, team: &troop1, troopStore: &currentStore1)
            resetLocations()
            print(currentStore1)
            troop1.currentResult = currentStore1
            troopstore["troop1"] = currentStore1
            debug()
        }
    }
    @IBAction func Sweden(_ sender: Any) {
        if choice == 1{
            firstMoveLoc = sweden
            choice += 1
        }else if choice == 2{
            secondMoveLoc = sweden
            choice = 1
            currentStore2 = Move(whoIsMoving: firstMoveLoc, whereTo: secondMoveLoc, team: &troop1, troopStore: &currentStore1)
            resetLocations()
            //print(currentStore2)
            troop1.currentResult = currentStore1
            troopstore["troop1"] = currentStore1
        }
    }
    @IBAction func Kiel(_ sender: Any) {
        if choice == 1{
            firstMoveLoc = kiel
            choice += 1
        }else if choice == 2{
            secondMoveLoc = kiel
            choice = 1
            currentStore1 = Move(whoIsMoving: firstMoveLoc, whereTo: secondMoveLoc, team: &troop1, troopStore: &currentStore1)
            resetLocations()
            //print(currentStore2)
            troop1.currentResult = currentStore1
            troopstore["troop1"] = currentStore1
        }
    }
    @IBAction func InputMove(_ sender: Any) {
        sendMyLoc(completion: {() -> () in })
//        let dataSend = DataSend(loc: troopstore)
//        guard let uploadData = try? JSONEncoder().encode(dataSend) else {
//            return
//        }
//        let url = URL(string: "https://oq20qcckri.execute-api.us-east-1.amazonaws.com/live3/main")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
//            if let error = error {
//                print ("error: \(error)")
//                return
//            }
//            guard let response = response as? HTTPURLResponse,
//                (200...299).contains(response.statusCode) else {
//                    print("Server error")
//                    return
//            }
//            if let mimeType = response.mimeType,
//                mimeType == "application/json",
//                let data = data,
//                let dataString = String(data: data, encoding: .utf8) {
//                print("got data: \(dataString)")
//            }
//        }
//        task.resume()
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
        
        func load(delay: UInt32, completion: () -> Void) {
            sleep(delay)
            completion()
        }
        
        let group = DispatchGroup()
        //let queue = DispatchQueue(label: "Queue")
        group.enter()
        load(delay: 1) {
            getData(completion: { () -> () in
                print("GETDATA COMPETION RAN")
                var counter = 1
                var completionCounter = 1
                var resolveStore: (one:String,two:String)
                struct ResolveData{
                    var move: String
                    var whichTroop: troop?
                    //var move2: String
                    //var whichTroop2: troop
                }
                var firstTroop = ResolveData(move: "", whichTroop: nil)
                var secondTroop = ResolveData(move: "", whichTroop: nil)
                for places in nations{
                    print("place: " + places.name)
                    for troop in troops{
                        print("Troop in troops: " + troop.troopID + ",\(troop.loc)")
                        print("CompCount = " + String(completionCounter))
                        if places.name == troop.loc && completionCounter > 0{
                            completionCounter += 1
                            if counter == 1{
                                firstTroop.move = troop.currentResult
                                firstTroop.whichTroop = troop
                                print("The first troop is: " + firstTroop.whichTroop!.troopID)
                                counter += 1
                                //                            debug()
                            }else if counter == 2{
                                print(troop2.currentResult)
                                secondTroop.move = troop2.currentResult
                                secondTroop.whichTroop = troop
                                counter = 1
                                //                            print(troop1.currentResult)
                                //                            print(firstTroop.move)
                                //                            debug()
                                //                            print(troop1.loc)
                                print("Input data: " + firstTroop.move + firstTroop.whichTroop!.troopID + secondTroop.move + secondTroop.whichTroop!.troopID)
                                print(troop1.loc + troop1.locPrev)
                                print(troop2.loc + troop2.locPrev)
                                resolveStore = resolve(move1: firstTroop.move, whichTroop1: firstTroop.whichTroop!, move2: secondTroop.move, whichTroop2: secondTroop.whichTroop!)
                                print(resolveStore)
                                troopstore["troop1"] = troop1.loc
                                //                            print(troop1.loc)
                                print(currentStore1 + troop1.loc + currentStore2 + troop2.loc)
                                
                            }
                        }else if completionCounter < 2{
                            counter = 1
                        }
                    }
                    completionCounter = 1
                }
                /*sendLocation(completion: { () -> () in*/
                debug()
                print(troop1.loc)
                
                //                if currentStore1 != "Fleets can only travel on water."{
                //England = troop1.loc.replacingOccurrences(of: '"', with: "", options: [])
                //                    self.first.text = "Tommy's fleet is in \(troop1.loc)."
                //                }else{
                //                    self.first.text = currentStore1
                //                }
                //                self.second.text = "Jake's fleet is in \(troop2.loc)"
                //                self.third.text = "Matt's troop is in \(troop3.loc)"
                //})
                
            })
                group.leave()
            }
    group.enter()
        load(delay: 2){
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
                    do{
                        let users = try JSONDecoder().decode([Users].self, from: data)
                        print(users)
                        for user in users {
                            currentStore1 = user.troops["troop1"]!
                            currentStore2 = user.troops["troop2"]!
                            currentStore3 = user.troops["troop3"]!
                            troop2.locPrev = troop2.loc
                            troop1.loc = user.troops["troop1"]!
                            troop2.loc = user.troops["troop2"]!
                            troop3.loc = user.troops["troop3"]!
                            troop1.currentResult = troop1.loc
                            troop2.currentResult = troop2.loc
                            troop3.currentResult = troop3.loc
                            print("troop1.loc = " + troop1.loc + "locPrev = " + troop1.locPrev)
                            print("Troop2.loc = " + troop2.loc + "locPrev = " + troop2.locPrev)
                            print("GET DATA RANNNNNNNN!!!!!!")
                        }
                        resetLocations()
                    }catch{
                        print("There was an error")
                    }
                    print("SEND MY LOC RANNNNNN!!!!!")
                }
            }
            task.resume()
//                sendMyLoc(completion: {() -> () in
//                    print("sendMyLoc completion ran")
//                })
            group.leave()
            }
//    group.enter()
//        load(delay: 3){
//                    getData()
//            group.leave()
//        }
        group.notify(queue: .main){
            print("QUEUE DONE")
        }
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
fileprivate func getData(completion: () -> Void = {}){
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
                troop2.locPrev = troop2.loc
                troop1.loc = user.troops["troop1"]!
                troop2.loc = user.troops["troop2"]!
                troop3.loc = user.troops["troop3"]!
                troop1.currentResult = troop1.loc
                troop2.currentResult = troop2.loc
                troop3.currentResult = troop3.loc
                print("troop1.loc = " + troop1.loc + "locPrev = " + troop1.locPrev)
                print("Troop2.loc = " + troop2.loc + "locPrev = " + troop2.locPrev)
                print("GET DATA RANNNNNNNN!!!!!!")
            }
            resetLocations()
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
fileprivate func sendLocation(completion: (() -> Void)){
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
    completion()
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
func debug(){
    resetLocations()
    for troop in currentTroopLocations{
        print(troop)
    }
    print("CS1 = " + currentStore1 + ", CS2 = " + currentStore2 + ", CS3 = " + currentStore3)
}
func sendMyLoc(completion: (() -> Void)){
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
            print("SEND MY LOC RANNNNNN!!!!!")
        }
    }
    task.resume()
    completion()
}
var countryControlers: Dictionary<String,String> = ["the North Sea":"","Norway":"","Kiel":""]
var troopstore:Dictionary<String,String> = [:]
var choice: Int = 1
var firstMoveLoc: Nations = England
var secondMoveLoc: Nations = England
let currentUser: String = "Tommy"
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
