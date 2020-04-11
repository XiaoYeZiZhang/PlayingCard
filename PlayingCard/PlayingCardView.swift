//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by zhangye on 2020/4/6.
//  Copyright © 2020 zju. All rights reserved.
//

import UIKit
@IBDesignable
class PlayingCardView: UIView {
    @IBInspectable
    var rank: Int = 11 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    @IBInspectable
    var suit: String = "❤️" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    @IBInspectable
    var isFaceUp: Bool = true {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var faceCardImageRaio: CGFloat = Ratio.faceCardImageSizeToBoundsSize {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat)->NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        let paragraphstyle = NSMutableParagraphStyle()
        paragraphstyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphstyle, .font: font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
    }
    
    
    lazy private var upperLeftUILabel: UILabel = createUILabel()
    lazy private var bottomRightUILabel: UILabel = createUILabel()
    
    private func createUILabel()->UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureUILabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
        return
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUILabel(upperLeftUILabel)
        upperLeftUILabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        
        configureUILabel(bottomRightUILabel)
        bottomRightUILabel.transform = CGAffineTransform.identity
            .translatedBy(x: bottomRightUILabel.frame.size.width, y: bottomRightUILabel.frame.size.height)
            .rotated(by: CGFloat.pi)
    
        bottomRightUILabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
        .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -bottomRightUILabel.frame.size.width, dy: -bottomRightUILabel.frame.size.height)
    }
    
    
    private func drawPips()
    {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
         //Drawing code
//        if let context = UIGraphicsGetCurrentContext() {
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.red.setFill()
//            UIColor.green.setStroke()
//            context.strokePath()
//            context.fillPath()
//        }
        
        
//        let path = UIBezierPath();
//        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//
//        path.lineWidth = 5.0
//        UIColor.red.setFill()
//        UIColor.green.setStroke()
//        path.fill();
//        path.stroke()
        
        let roundCornerPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundCornerPath.addClip()
        UIColor.white.setFill()
        roundCornerPath.fill()
        
        if isFaceUp {
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardImageRaio))
            }else {
                drawPips()
            }
        }else {
            if let backImage = UIImage(named: "cardback") {
                backImage.draw(in: bounds)
            }
        }
    }
}


extension PlayingCardView {
    private struct Ratio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * Ratio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * Ratio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * Ratio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
    
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    
    var rightHalf: CGRect {
        return CGRect(x: midX, y: midY, width: width/2, height: height)
    }
    
    func inset(by size: CGSize)->CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize)->CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    func zoom(by scale: CGFloat)->CGRect {
        let newWidth = width*scale
        let newHeight = height*scale
        return insetBy(dx: (width-newWidth)/2, dy: (height-newHeight)/2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy:CGFloat)->CGPoint{
        return CGPoint(x: x+dx, y: y+dy)
    }
}
