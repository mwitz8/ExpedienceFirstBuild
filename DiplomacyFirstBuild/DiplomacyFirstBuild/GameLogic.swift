//
//  GameLogic.swift
//  DiplomacyFirstBuild
//
//  Created by Tommy Roz on 3/20/20.
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

var moveData1: String
var moveData2: String
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

struct Nations{
    var adjacencyMatrix: Array<Int>
    var countryLocations: Int
    var name: String
    let seaTerritories: Bool
    let landTerritories: Bool
}
var England = Nations(adjacencyMatrix: [1,2], countryLocations: 1, name: "England", seaTerritories: true, landTerritories: true )
var theNorthSea = Nations(adjacencyMatrix: [1,2,3,4], countryLocations: 2, name: "The North Sea", seaTerritories: true, landTerritories: false)
var Norway = Nations(adjacencyMatrix: [2,3,4,5], countryLocations: 3, name: "Norway", seaTerritories: true, landTerritories: true)
var Kiel = Nations(adjacencyMatrix: [2,3,4], countryLocations: 4, name: "Kiel", seaTerritories: false, landTerritories: true)
var Sweden = Nations(adjacencyMatrix: [3,5], countryLocations: 5, name: "Sweden", seaTerritories: false, landTerritories: true)

struct troop{
    var loc: String
    var locPrev: String
    var strength: Int
    var element: Bool
    var alive: Bool
    var number: Int
    let player: Int
}
var troop1 = troop(loc: "Kiel", locPrev: "", strength: 0, element: false, alive: true, number: 1, player: 1)
var troop2 = troop(loc: "Norway", locPrev: "", strength: 0, element: false, alive: true, number: 2, player: 2)
var troop3 = troop(loc: "the North Sea", locPrev: "", strength: 0, element: true, alive: true, number: 3, player: 3)
var troop4: troop
var troop5: troop
var troop6: troop

var troops: Array<troop> = [troop1,troop2,troop3]
var currentTroopLocations: Array<String> = [troop1.loc, troop2.loc, troop3.loc]
var previousTroopLocations: Array<String> = [""]
var currentStore1 = "Kiel"
var currentStore2 = "Norway"
var currentStore3 = "the North Sea"
var troopstore:Array<String> = []

func resetPrev(troop: inout troop){
    troop.locPrev = troop.loc
}

func resetLocations(){
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
    if season == "Fall" {
        fallTerritoryChange()
    }
}
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
