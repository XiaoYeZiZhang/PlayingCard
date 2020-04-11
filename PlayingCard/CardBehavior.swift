//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by zhangye on 2020/4/11.
//  Copyright © 2020 zju. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
       lazy var collisionBehavior: UICollisionBehavior = {
           let behavior = UICollisionBehavior()
           behavior.translatesReferenceBoundsIntoBoundary = true
           return behavior
       }()
       
       lazy var itemBehavior: UIDynamicItemBehavior = {
           let behavior = UIDynamicItemBehavior()
           behavior.allowsRotation = false
           behavior.elasticity = 1.0
           behavior.resistance = 0
           return behavior
       }()
    
    private func pushBehavior(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x < center.x && y < center.y:
                push.angle = (CGFloat.pi/2).randomValue
            case let (x, y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi-(CGFloat.pi/2).randomValue
            case let (x, y) where x < center.x && y > center.y:
                push.angle = (-CGFloat.pi/2).randomValue
            case let (x, y) where x > center.x && y > center.y:
                push.angle = CGFloat.pi+(CGFloat.pi/2).randomValue
            default:
                push.angle = (CGFloat.pi*2).randomValue
            }
        }
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).randomValue
        // push之后将自己移除, action只执行一次
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        pushBehavior(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
        
}
