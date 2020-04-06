//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by zhangye on 2020/4/6.
//  Copyright © 2020 zju. All rights reserved.
//

import Foundation

struct PlayingCardDeck {
    private(set) var cards = [PlayingCard]()
    
    init() {
        // all is an array of all elements in enum 
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    
    mutating func draw() ->PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.randomValue)
        }
        
        return nil
    }
}

extension Int {
    var randomValue: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0 {
            return -1 * Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
}


