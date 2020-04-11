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
    
    
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter{$0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
            && $0.alpha == 1
        }
    }
    
    private var faceUpCardMatches: Bool {
        return
            faceUpCardViews.count == 2 &&
                faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
                faceUpCardViews[0].suit == faceUpCardViews[1].suit
        
    }
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    var lastFlipCardView: PlayingCardView?
    
    @objc func FlipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            
            if let choosenCardView = recognizer.view as? PlayingCardView, self.faceUpCardViews.count < 2 {
                lastFlipCardView = choosenCardView
                // 点击的纸牌需要让他停止移动
                cardBehavior.removeItem(choosenCardView)
                // 对点击的纸牌进行反转动画
                UIView.transition(with: choosenCardView,
                                  duration: 3.0,
                                  options: [.transitionFlipFromLeft],
                                  animations: {choosenCardView.isFaceUp = !choosenCardView.isFaceUp},
                                  completion: {finished in
                                    let cardToAnimated = self.faceUpCardViews
                                    // 反转结束后如果是匹配的图像, 进行后续操作
                                    if self.faceUpCardMatches {
                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                            withDuration: 0.6,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                                cardToAnimated.forEach {
                                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                }
                                        },
                                            completion: {
                                                position in
                                                UIViewPropertyAnimator.runningPropertyAnimator(
                                                    withDuration: 0.8,
                                                    delay: 0,
                                                    options: [],
                                                    animations: {
                                                        cardToAnimated.forEach {
                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                            $0.alpha = 0
                                                        }
                                                },
                                                    completion: {
                                                        position in
                                                        cardToAnimated.forEach {
                                                            $0.isHidden = true
                                                            $0.transform = .identity
                                                            $0.alpha = 1
                                                        }
                                                })
                                        } )
                                    }
                                        // 如果目前的两张朝上的纸牌不匹配进行的动画(重新开始移动和碰撞)
                                        // origin card and second card both want to do flip down
                                    else if cardToAnimated.count == 2 {
                                        if self.lastFlipCardView == choosenCardView {
                                            cardToAnimated.forEach{
                                                cardview in
                                                UIView.transition(
                                                    with: cardview,
                                                    duration: 3.0,
                                                    options: [.transitionFlipFromLeft],
                                                    animations: {cardview.isFaceUp = false},
                                                    completion: {
                                                        finish in
                                                        self.cardBehavior.addItem(cardview)
                                                })}
                                        }
                                        
                                    }else {
                                        // 如果是单张牌朝上然后朝下, 也重新开始移动和碰撞
                                        if !choosenCardView.isFaceUp {
                                            self.cardBehavior.addItem(choosenCardView)
                                        }
                                    }
                                    
                }
                )
                
            }
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var cards = [PlayingCard]();
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card, card]
        }
        
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.randomValue)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FlipCard(_:))))
            cardBehavior.addItem(cardView)
        }
    }
}

extension CGFloat {
    var randomValue: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
