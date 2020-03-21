//
//  GameLogic.swift
//  DiplomacyFirstBuild
//
//  Created by Tommy Roz on 3/20/20.
//  Copyright © 2020 Tommy Roz. All rights reserved.
//

import Foundation

var adjacencyMatrix: Dictionary<String, Array<Int>> = ["England": [1,2],"the North Sea": [1,2,3,4],"Norway": [2,3,4,5],"Kiel": [2,3,4],"Sweden": [3,5],"X": []]
var countryLocations: Dictionary<Int, String> = [1: "England", 2: "the North Sea", 3: "Norway", 4: "Kiel", 5: "Sweden"]
var countryValues: Dictionary<String, Int> = ["England": 1, "the North Sea": 2, "Norway": 3, "Kiel": 4, "Sweden": 5]
var seaTerritories: Set<String> = ["England","the North Sea","Norway"]
let landTerritories: Set<String> = ["England","Norway","Kiel","Sweden"]
var gameStat: Bool = false

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

public struct troop{
    var loc: String
    var locPrev: String
    var strength: Int
    var element: Bool
    var alive: Bool
    var number: Int
    let player: Int
}

//var troops: Array<troop> = [troop1,troop2,troop3]
//var currentTroopLocations: Array<String> = [troop1.loc, troop2.loc, troop3.loc]
var previousTroopLocations: Array<String> = [""]
var currentStore1 = "the North Sea"
var currentStore2 = "Norway"
var currentStore3 = "Kiel"
public var initLoc1: String = ""
public var initLoc2: String = ""
public var initLoc3: String = ""
public var troop1 = troop(loc: initLoc1, locPrev: "", strength: 0, element: true, alive: true, number: 1, player: 1)
public var troop2 = troop(loc: initLoc2, locPrev: "", strength: 0, element: true, alive: true, number: 2, player: 2)
public var troop3 = troop(loc: initLoc3, locPrev: "", strength: 0, element: false, alive: true, number: 3, player: 3)

public func Move(whoIsMoving: String, whereTo: String, team: inout troop, troopStore: inout String) -> String{
    if team.alive == false{
        return "X"
    }else if (seaTerritories.contains(whoIsMoving) && seaTerritories.contains(whereTo)) && team.element == true{
        if ((adjacencyMatrix[whoIsMoving]!.contains(countryValues[whereTo]!)) && (whoIsMoving == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving
            team.loc = whereTo
            return team.loc
        }else if (((adjacencyMatrix[whoIsMoving]!.contains(countryValues[whereTo]!)) == false) && (whoIsMoving == team.loc)) && team.alive == true {
            team.locPrev = whoIsMoving
            return "Bounced"
        }
    }else if ((seaTerritories.contains(whoIsMoving) && seaTerritories.contains(whereTo)) == false) && team.element == true{
        if ((adjacencyMatrix[whoIsMoving]!.contains(countryValues[whereTo]!)) == false){
            team.locPrev = whoIsMoving
            return "Bounced"
        }else if ((adjacencyMatrix[whoIsMoving]!.contains(countryValues[whereTo]!)) && (whoIsMoving == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving
            return "Fleets can only travel on water."
        }
    }else if (((seaTerritories.contains(whoIsMoving) && seaTerritories.contains(whereTo))) && ((landTerritories.contains(whoIsMoving) && landTerritories.contains(whereTo) == false))) && team.element == false{
        if ((adjacencyMatrix[whoIsMoving]!.contains(countryValues[whereTo]!)) && (whoIsMoving == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving
            //resetLocations()
            return "Troops can only travel on land."
        }else if (((adjacencyMatrix[whoIsMoving]!.contains(countryValues[whereTo]!)) == false) && (whoIsMoving == team.loc)) && team.alive == true {
            team.locPrev = whoIsMoving
            //resetLocations()
            return "Bounced"
        }
    }else if ((seaTerritories.contains(whoIsMoving) && seaTerritories.contains(whereTo)) == false) && team.element == false{
        if ((adjacencyMatrix[whoIsMoving]!.contains(countryValues[whereTo]!)) && (whoIsMoving == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving
            team.loc = whereTo
            troopStore = team.loc
            return team.loc
        }else if (((adjacencyMatrix[whoIsMoving]!.contains(countryValues[whereTo]!)) == false) && (whoIsMoving == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving
            return "Bounced"
        }
    }else if ((seaTerritories.contains(whoIsMoving) && seaTerritories.contains(whereTo)) && (landTerritories.contains(whoIsMoving) && landTerritories.contains(whereTo))) && team.element == false{
        if ((adjacencyMatrix[whoIsMoving]!.contains(countryValues[whereTo]!)) && (whoIsMoving == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving
            team.loc = whereTo
            return team.loc
        }else if (((adjacencyMatrix[whoIsMoving]!.contains(countryValues[whereTo]!)) == false) && (whoIsMoving == team.loc)) && team.alive == true{
            team.locPrev = whoIsMoving
            return "Bounced"
        }
    }
    return "error"
}
