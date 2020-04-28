//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by zhangye on 2020/4/25.
//  Copyright © 2020 zju. All rights reserved.
//

import Foundation

struct PlayingCardDeck {
    var cards = [PlayingCard]()
    
    init() {
        for rank in PlayingCard.Rank.all {
            for suit in PlayingCard.Suit.all {
                cards.append(PlayingCard(rank: rank, suit: suit))
            }
        }
    }
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        }else {
            return nil
        }
    }
}

extension Int {
    
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
