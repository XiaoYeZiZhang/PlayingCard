//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by zhangye on 2020/4/6.
//  Copyright © 2020 zju. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible{
    var description: String {
        return "\(suit), \(rank)"
    }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        case spades = "♠️"
        case hearts = "❤️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        
        var description: String {
            switch self {
            case .spades:
                return "♠️"
            case .hearts:
                return "❤️"
            case .diamonds:
                return "♣️"
            case .clubs:
                return "♣️"
            }
        }
        static var all = [Suit.spades, .hearts, .clubs, .diamonds]
    }
    
   
    
    enum Rank: CustomStringConvertible {
        case ace
        case face(String)
        case numaric(Int)
        
        
        var description: String {
            switch self {
            case Rank.ace:
                return "A";
            case Rank.numaric(let pips):
                return String(pips)
            case Rank.face(let kind):
                return kind
            }
        }
            
        var order: Int {
            switch self {
            case .ace:
                return 1;
            case .numaric(let pips):
                return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default:
                return 0
            }
        }
        
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numaric(pips))
            }
            
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
    }
}
