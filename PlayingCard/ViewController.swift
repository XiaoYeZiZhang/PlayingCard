//
//  ViewController.swift
//  PlayingCard
//
//  Created by zhangye on 2020/4/25.
//  Copyright © 2020 zju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cards = PlayingCardDeck()
    
    @IBOutlet weak var playingCardView: PlayingCardView!
     {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
            
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(playingCardView.adjustFaceCardScale(byHandlingGesturerecognizedBy:)))
            playingCardView.addGestureRecognizer(pinch)
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            playingCardView.isFaceUp = !playingCardView.isFaceUp
        default:
            break
        }
    }
    
    @objc func nextCard() {
        if let card = cards.draw() {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        for _ in 1...10 {
//            if let card = cards.draw() {
//                print("\(card)")
//            }
//        }
    }


}

