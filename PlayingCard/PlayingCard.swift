//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by zhangye on 2020/4/25.
//  Copyright © 2020 zju. All rights reserved.
//

import Foundation

struct PlayingCard {
    var rank: Rank
    var suit: Suit
    
    enum Suit: String{
        case spades = "♠️"
        case hearts = "❤️"
        case diamonds = "♦️"
        case clubs = "♣️"
        
        static var all: [Suit] {
            return [Suit.spades, .hearts, .diamonds, .clubs]
        }
    }
    
    enum Rank {
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace:
                return 1
            case .face(let str) where str == "J": return 11
            case .face(let str) where str == "Q": return 12
            case .face(let str) where str == "K": return 13
            case .numeric(let num):
                return num
            default:
                return 0
            }
        }
        
        
        static var all: [Rank] {
            var allRank = [Rank.ace]
            for num in 2...10 {
                allRank.append(Rank.numeric(num))
            }
            
            allRank.append(Rank.face("J"))
            allRank.append(Rank.face("Q"))
            allRank.append(Rank.face("K"))
            return allRank
        }
    }
}
