//
//  GameLogic.swift
//  diplomacyFirstBuildTommy
//
//  Created by Tommy Roz on 3/25/20.
//  Copyright © 2020 Tommy Roz. All rights reserved.
//

import Foundation

let supplyCenters1: Array<String> = ["Kiel"]
let supplyCenters2: Array<String> = ["Norway"]
let supplyCenters3: Array<String> = ["the North Sea"]

var player1Owned: Array<String> = ["Kiel"]
var player2Owned: Array<String> = ["Norway"]
var player3Owned: Array<String> = ["the North Sea"]
var unclaimed: Array<String> = ["England","Sweden"]

//var moveData1: String
//var moveData2: String
var troopStrengthStore = 0
var supportHappened: Bool = false

var year: Int = 1900
var season: String = "Fall"

var player1DP: Bool = false
var player2DP: Bool = false
var player3DP: Bool = false

var player1BP: Bool = false
var player2BP: Bool = false
var player3BP: Bool = false

public struct Nations{
    var adjacencyMatrix: Array<Int>
    var countryLocations: Int
    var name: String
    let seaTerritories: Bool
    let landTerritories: Bool
}
public var England = Nations(adjacencyMatrix: [1,2], countryLocations: 1, name: "England", seaTerritories: true, landTerritories: true )
public var theNorthSea = Nations(adjacencyMatrix: [1,2,3,4], countryLocations: 2, name: "The North Sea", seaTerritories: true, landTerritories: false)
public var norway: Nations = Nations(adjacencyMatrix: [2,3,4,5], countryLocations: 3, name: "Norway", seaTerritories: true, landTerritories: true)
public var kiel = Nations(adjacencyMatrix: [2,3,4], countryLocations: 4, name: "Kiel", seaTerritories: false, landTerritories: true)
public var sweden = Nations(adjacencyMatrix: [3,5], countryLocations: 5, name: "Sweden", seaTerritories: false, landTerritories: true)

public let nations = [England, theNorthSea, norway, kiel, sweden]

public class troop{
    var loc: String
    var locPrev: String
    var strength: Int
    var element: Bool
    var alive: Bool
    var number: Int
    let player: Int
    var currentResult: String
    let troopID: String
    init(loc: String, locPrev: String, strength: Int, element: Bool, alive: Bool, number: Int, player: Int, currentResult: String, troopID: String) {
        self.loc = loc
        self.locPrev = locPrev
        self.strength = strength
        self.element = element
        self.alive = alive
        self.number = number
        self.player = player
        self.currentResult = currentResult
        self.troopID = troopID
    }
}

var troops: Array<troop> = [troop1,troop2,troop3]
var currentTroopLocations: Array<String> = [troop1.loc, troop2.loc, troop3.loc]
var previousTroopLocations: Array<String> = [""]
var currentStore1 = "the North Sea"
var currentStore2 = "Norway"
var currentStore3 = "Kiel"

public var initLoc1: String = ""
public var initLoc2: String = ""
public var initLoc3: String = ""
public var troop1 = troop(loc: initLoc1, locPrev: initLoc1, strength: 0, element: true, alive: true, number: 1, player: 1, currentResult: initLoc1, troopID: "Troop 1")
public var troop2 = troop(loc: initLoc2, locPrev: initLoc2, strength: 0, element: true, alive: true, number: 2, player: 2, currentResult: initLoc2, troopID: "Troop 2")
public var troop3 = troop(loc: initLoc3, locPrev: initLoc3, strength: 0, element: false, alive: true, number: 3, player: 3, currentResult: initLoc3, troopID: "Troop 3")
//Basic move function takes parameters whoIsMoving is the country, whereTo is the country its moving to, team right now is troop1, troop2 or troop3, troopStore is where in currentTroopLocations the move output should go
func Move(whoIsMoving: Nations, whereTo: Nations, team: inout troop, troopStore: inout String) -> String{
    if team.alive == false{
        return "X"
    }else if (whoIsMoving.seaTerritories && whereTo.seaTerritories) && team.element == true{
        if ((whoIsMoving.adjacencyMatrix.contains(whereTo.countryLocations)) && (whoIsMoving.name == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving.name
            team.loc = whereTo.name
            return team.loc
        }else if (((whoIsMoving.adjacencyMatrix.contains(whereTo.countryLocations)) == false) && (whoIsMoving.name == team.loc)) && team.alive == true {
            team.locPrev = whoIsMoving.name
            return "Bounced"
        }
    }else if ((whoIsMoving.seaTerritories && whereTo.seaTerritories) == false) && team.element == true{
        if ((whoIsMoving.adjacencyMatrix.contains(whereTo.countryLocations)) == false){
                team.locPrev = whoIsMoving.name
                return "Bounced"
        }else if ((whoIsMoving.adjacencyMatrix.contains(whereTo.countryLocations)) && (whoIsMoving.name == team.loc)) && team.alive == true{
                team.locPrev = whoIsMoving.name
                return "Fleets can only travel on water."
            }
    }else if ((whoIsMoving.seaTerritories && whereTo.seaTerritories)) && ((whoIsMoving.landTerritories) && whereTo.landTerritories) == false && team.element == false{
        if (whoIsMoving.adjacencyMatrix.contains(whereTo.countryLocations) && (whoIsMoving.name == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving.name
            //resetLocations()
            return "Troops can only travel on land."
        }else if ((whoIsMoving.adjacencyMatrix.contains(whereTo.countryLocations) == false) && (whoIsMoving.name == team.loc)) && team.alive == true {
            team.locPrev = whoIsMoving.name
            //resetLocations()
            return "Bounced"
        }
    }else if (whoIsMoving.seaTerritories && whereTo.seaTerritories) == false && team.element == false{
        if (whoIsMoving.adjacencyMatrix.contains(whereTo.countryLocations) && (whoIsMoving.name == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving.name
            team.loc = whereTo.name
            troopStore = team.loc
            return team.loc
        }else if ((whoIsMoving.adjacencyMatrix.contains(whereTo.countryLocations) == false) && (whoIsMoving.name == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving.name
            return "Bounced"
        }
    }else if ((whoIsMoving.seaTerritories && whereTo.seaTerritories) && (whoIsMoving.landTerritories && whereTo.landTerritories)) && team.element == false{
        if ((whoIsMoving.adjacencyMatrix.contains(whereTo.countryLocations)) && (whoIsMoving.name == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving.name
            team.loc = whereTo.name
            return team.loc
        }else if (((whoIsMoving.adjacencyMatrix.contains(whereTo.countryLocations)) == false) && (whoIsMoving.name == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving.name
            return "Bounced"
        }
    }
    return "error"
}
public func resetLocations(){
    previousTroopLocations = currentTroopLocations
    if currentStore1 != "error"{
        currentTroopLocations[0] = currentStore1
    }
    if currentStore2 != "error"{
        currentTroopLocations[1] = currentStore2
    }
    if currentStore3 != "error"{
        currentTroopLocations[2] = currentStore3
    }
    /*if season == "Fall" {
        fallTerritoryChange()
    }*/
}
public func resolve(move1: String, whichTroop1: troop, move2: String, whichTroop2: troop) -> (one: String,two: String){
    var r1: String
    var r2: String
    //var output1: String
    //var output2: String
    
        for i in 0..<currentTroopLocations.count{
            if (currentTroopLocations[0] == currentTroopLocations[i]) && i != 0 && troops[i].alive == true{
                        switch i {
                        case 1:
                        if troop1.strength > troop2.strength{
                            troop2.alive = false
                            currentStore2 = "X"
                            troop2.loc = "X"
                            troop1.strength = 0
                            resetLocations()
                            r1 = "Troop 1 moved from \(troop1.locPrev) to \(troop1.loc)"
                            r2 = "Troop 2 destroyed"
                        }else{
                            currentStore1 = troop1.locPrev
                            currentStore2 = troop2.locPrev
                            resetLocations()
                            r1 = "Bounced"
                            r2 = "Bounced"
                        }
                        case 2:
                            if troop1.strength > troop3.strength{
                                troop3.alive = false
                                currentStore3 = "X"
                                troop3.loc = "X"
                                troop1.strength = 0
                                resetLocations()
                                r1 = "Troop 1 moved from \(troop1.locPrev) to \(troop1.loc)"
                                r2 = "Troop 3 destroyed"
                            }else{
                                currentStore1 = troop1.locPrev
                                currentStore3 = troop3.locPrev
                                resetLocations()
                                r1 = "Bounced"
                                r2 = "Bounced"
                            }
                        default:
                            r1 = "Bounced"
                            r2 = "Bounced"
                        }
                return (r1,r2)
            }else if (currentTroopLocations[1] == currentTroopLocations[i]) && i != 1 && troops[i].alive == true{
                print("2 ran")
                    switch i {
                    case 0:
                        if troop2.strength > troop1.strength{
                            print("case 1 if ran")
                            troop1.alive = false
                            currentStore1 = "X"
                            troop1.loc = "X"
                            troop2.strength = 0
                            resetLocations()
                            r1 = "Troop 2 moved from \(troop2.locPrev) to \(troop2.loc)"
                            r2 = "Troop 1 destroyed"
                        }else{
                            print("CurrentStore2 , troop2.locprev = " + currentStore2 + troop2.locPrev)
                            if (currentStore2 != troop2.locPrev) && (currentStore1 != troop1.locPrev){
                                currentStore2 = troop2.locPrev
                                currentStore1 = troop1.locPrev
                                troop1.loc = currentStore1
                                troop2.loc = currentStore2
                                resetLocations()
                                print("case 1 else ran")
                                r1 = "Bounced"
                                r2 = "Bounced"
                            }else if (currentStore2 == troop2.locPrev) && (currentStore1 != troop1.locPrev){
                                currentStore1 = troop1.locPrev
                                troop1.loc = currentStore1
                                resetLocations()
                                r1 = "Bounced"
                                r2 = "Troop 2 moved from \(troop2.locPrev) to \(troop2.loc)"
                            }else if (currentStore1 == troop1.locPrev) && (currentStore2 != troop2.locPrev){
                                currentStore2 = troop2.locPrev
                                troop2.loc = currentStore2
                                resetLocations()
                                r1 = "Troop 1 moved from \(troop1.locPrev) to \(troop1.loc)"
                                r2 = "Bounced"
                            }else{
                                currentStore2 = troop2.locPrev
                                currentStore1 = troop1.locPrev
                                troop1.loc = currentStore1
                                troop2.loc = currentStore2
                                resetLocations()
                                r1 = "Bounced"
                                r2 = "Bounced"
                            }
                        }
                    case 2:
                        print("Case 2 ran")
                        if troop2.strength > troop3.strength{
                            troop3.alive = false
                            currentStore3 = "X"
                            troop3.loc = "X"
                            troop2.strength = 0
                            resetLocations()
                            r1 = "Troop 2 moved from \(troop2.locPrev) to \(troop2.loc)"
                            r2 = "Troop 3 destroyed"
                        }else{
                            currentStore2 = troop2.locPrev
                            currentStore3 = troop3.locPrev
                            resetLocations()
                            r1 = "Bounced"
                            r2 = "Bounced"
                        }
                    default:
                        r1 = "Bounced"
                        r2 = "Bounced"
                        }
                return (r1,r2)
            }else if (currentTroopLocations[2] == currentTroopLocations[i]) && i != 2 && troops[i].alive == true{
                    switch i{
                    case 0:
                        if troop3.strength > troop1.strength{
                            troop1.alive = false
                            currentStore1 = "X"
                            troop1.loc = "X"
                            troop3.strength = 0
                            resetLocations()
                            r1 = "Troop 3 moved from \(troop3.locPrev) to \(troop3.loc)"
                            r2 = "Troop 1 destroyed"
                        }else{
                            currentStore3 = troop3.locPrev
                            currentStore1 = troop1.locPrev
                            resetLocations()
                            r1 = "Bounced"
                            r2 = "Bounced"
                        }
                    case 1:
                        if troop3.strength > troop2.strength{
                            troop2.alive = false
                            currentStore2 = "X"
                            troop2.loc = "X"
                            troop3.strength = 0
                            resetLocations()
                            r1 = "Troop 3 moved from \(troop3.locPrev) to \(troop3.loc)"
                            r2 = "Troop 2 destroyed"
                        }else{
                            currentStore3 = troop3.locPrev
                            currentStore2 = troop2.locPrev
                            resetLocations()
                            r1 = "Bounced"
                            r2 = "Bounced"
                        }
                    default:
                        r1 = "Bounced"
                        r2 = "Bounced"
                        }
                //buildDestroyCheck()
                return (r1,r2)
                    }
        }
    
        if move1 == "Bounced" && move2 == "Bounced"{
            r1 = "Bounced"
            r2 = "Bounced"
        }else if move1 == "Bounced" && move2 == "Fleets can only travel on water."{
            r1 = "Bounced"
            r2 = "Fleets can only travel on water."
        }else if move1 == "Bounced" && move2 == "Troops can only travel on land."{
            r1 = "Bounced"
            r2 = "Troops can only travel on land."
        }else if move1 == "Bounced" && move2 != "Bounced" && move2 != "Fleets can only travel on water." && move2 != "Troops can only travel on land." && move2 != "error"{
            r1 = "Bounced"
            r2 = "Troop 2 moved from \(whichTroop2.locPrev) to \(whichTroop2.loc)"
        }else if move1 == "Fleets can only travel on water." && move2 == "Bounced"{
            r1 = "Fleets can only travel on water."
            r2 = "Bounced"
        }else if move1 == "Fleets can only travel on water." && move2 == "Fleets can only travel on water."{
            r1 = "Fleets can only travel on water."
            r2 = "Fleets can only travel on water."
        }else if move1 == "Fleets can only travel on water." && move2 == "Troops can only travel on land."{
            r1 = "Fleets can only travel on water."
            r2 = "Troops can only travel on land."
        }else if move1 == "Fleets can only travel on water." && move2 != "Bounced" && move2 != "Fleets can only travel on water." && move2 != "Troops can only travel on land." && move2 != "error"{
            r1 = "Fleets can only travel on water."
            r2 = "Troop 2 moved from \(whichTroop2.locPrev) to \(whichTroop2.loc)"
        }else if move1 == "Troops can only travel on land." && move2 == "Bounced"{
            r1 = "Troops can only travel on land."
            r2 = "Bounced"
        }else if move1 == "Troops can only travel on land." && move2 == "Fleets can only travel on water."{
            r1 = "Troops can only travel on land."
            r2 = "Fleets can only travel on water."
        }else if move1 == "Troops can only travel on land." && move2 == "Troops can only travel on land."{
            r1 = "Troops can only travel on land."
            r2 = "Troops can only travel on land."
        }else if move1 == "Troops can only travel on land." && move2 != "Bounced" && move2 != "Fleets can only travel on water." && move2 != "Troops can only travel on land." && move2 != "error"{
            r1 = "Troops can only travel on land."
            r2 = "Troop 2 moved from \(whichTroop2.locPrev) to \(whichTroop2.loc)"
        }else if move1 != "Bounced" && move1 != "Fleets can only travel on water." && move1 != "Troops can only travel on land." && move1 != "error" && move2 == "Bounced"{
            r1 = "Troop 1 moved from \(whichTroop1.locPrev) to \(whichTroop1.loc)"
            r2 = "Bounced"
        }else if move1 != "Bounced" && move1 != "Fleets can only travel on water." && move1 != "Troops can only travel on land." && move1 != "error" && move2 == "Fleets can only travel on water."{
            r1 = "Troop 1 moved from \(whichTroop1.locPrev) to \(whichTroop1.loc)"
            r2 = "Fleets can only travel on water."
        }else if move1 != "Bounced" && move1 != "Fleets can only travel on water." && move1 != "Troops can only travel on land." && move1 != "error" && move2 == "Troops can only travel on land."{
            r1 = "Troop 1 moved from \(whichTroop1.locPrev) to \(whichTroop1.loc)"
            r2 = "Troops can only travel on land."
        }else if move1 != "Bounced" && move1 != "Fleets can only travel on water." && move1 != "Troops can only travel on land." && move1 != "error" && move2 != "Bounced" && move2 != "Fleets can only travel on water." && move2 != "Troops can only travel on land." && move2 != "error" && move1 != move2{
            r1 = "\(whichTroop1.troopID) moved from \(whichTroop1.locPrev) to \(whichTroop1.loc)"
            r2 = "\(whichTroop2.troopID) moved from \(whichTroop2.locPrev) to \(whichTroop2.loc)"
        }else if move1 == "error" && move2 != "Bounced" && move2 != "Fleets can only travel on water." && move2 != "Troops can only travel on land." && move2 != "error" {
            r1 = "error"
            r2 = "Troop moved from \(whichTroop2.locPrev) to \(whichTroop2.loc)"
        }else if move1 == "error" && move2 == "Bounced"{
            r1 = "error"
            r2 = "Bounced"
        }else if move1 == "error" && move2 == "Troops can only travel on land."{
            r1 = "error"
            r2 = "Troops can only travel on land."
        }else if move1 == "error" && move2 == "Fleets can only travel on water."{
            r1 = "error"
            r2 = "Fleets can only travel on water."
        }else if move1 == "error" && move2 == "error"{
            r1 = "error"
            r2 = "error"
        }else if move1 != "Bounced" && move1 != "Fleets can only travel on water." && move1 != "Troops can only travel on land." && move1 != "error" && move2 == "error"{
            r1 = "\(whichTroop1.troopID) moved from \(whichTroop1.locPrev) to \(whichTroop1.loc)"
            r2 = "error"
        }else if move1 != "Bounced" && move1 != "Fleets can only travel on water." && move1 != "Troops can only travel on land." && move1 != "error" && move2 == "Bounced"{
            r1 = "Troop moved from \(whichTroop1.locPrev) to \(whichTroop1.loc)"
            r2 = "Bounced"
        }else if move1 == "Bounced" && move2 == "error"{
            r1 = "Bounced"
            r2 = "error"
        }else if move1 == "Troops can only travel on land." && move2 == "error"{
            r1 = "Troops can only travel on land."
            r2 = "error"
        }else if move1 == "Fleets can only travel on water." && move2 == "error"{
            r1 = "Fleets can only travel on water."
            r2 = "error"
        }else{
            r1 = "error"
            r2 = "error"
        }
    //buildDestroyCheck()
    return (r1,r2)
}

