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
    
    @IBOutlet weak var PlayingCardView: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            PlayingCardView.addGestureRecognizer(swipe)
            
            
            let pinch = UIPinchGestureRecognizer(target: PlayingCardView, action: #selector(PlayingCardView.changeFaceCardImageRatio(ByHandlingGestureRecognizedBy:)))
            PlayingCardView.addGestureRecognizer(pinch)
        }
    }
    
    @objc func nextCard() {
        if let card = deck.draw() {
            PlayingCardView.rank = card.rank.order
            PlayingCardView.suit = card.suit.rawValue
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            PlayingCardView.isFaceUp = !PlayingCardView.isFaceUp
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        for _ in 1...10 {
//            if let card = deck.draw() {
//                print("\(card)")
//            }
//        }
        
    }


}

