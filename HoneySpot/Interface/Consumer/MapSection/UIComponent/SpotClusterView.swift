//
//  SpotClusterView.swift
//  HoneySpot
//
//  Created by Kaan Baris BAYRAK on 11.05.2019.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
import MapKit

class SpotClusterView: MKAnnotationView {
    
    static let SPOT_CLUSTER_VIEW_REUSE_IDENTIFICATION = "SpotClusterView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            let totalSpots = cluster.memberAnnotations.count

            image = drawClusterView(count: totalSpots)
            
            if totalSpots > 0 {
                displayPriority = .defaultLow
            } else {
                displayPriority = .defaultHigh
            }
        }
    }
    
    private func drawClusterView(count : Int) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
        return renderer.image { _ in
            // Fill full circle with wholeColor
//            let view = UIView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
//            view.backgroundColor = UIColor.ORANGE_COLOR
//            view.layer.cornerRadius = view.frame.size.width / 2
//            view.layer.borderWidth = 1
//            view.layer.borderColor = UIColor.white.cgColor
            
            // Fill inner circle with white color

            layer.cornerRadius = 15
            layer.borderWidth = 1
            layer.borderColor = UIColor.white.cgColor
            
            UIColor.ORANGE_COLOR.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 30, height: 30)).fill()
            
            let text = "\(count)"
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 15 - (size.width / 2), y: 15 - (size.height / 2), width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
            
            
        }
    }

}
