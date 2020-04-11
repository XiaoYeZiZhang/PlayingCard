//
//  ViewController.swift
//  PlayingCard
//
//  Created by zhangye on 2020/4/6.
//  Copyright © 2020 zju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        for _ in 1...10 {
//            if let card = deck.draw() {
//                print("\(card)")
//            }
//        }
        
        var cards = [PlayingCard]();
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        
        for cardView in cardViews {
            cardView.isFaceUp = true
            let card = cards.remove(at: cards.count.randomValue)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
        }
        
    }


}

