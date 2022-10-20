//
//  CustomMarkerView.swift
//  HoneySpot
//
//  Created by htcuser on 22/09/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import Foundation
import Charts

class CustomMarkerView: MarkerView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var markerBoard: UIView!
    @IBOutlet weak var markerStick: UIView!
    @IBOutlet weak var xValue: UILabel!
    @IBOutlet weak var yValue: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    private func initUI() {
            Bundle.main.loadNibNamed("CustomMarkerView", owner: self, options: nil)
            addSubview(contentView)
            self.frame = CGRect(x: 0, y: 0, width: 88, height: 69)
            self.offset = CGPoint(x: -(self.frame.width/2), y: -self.frame.height)
        }
    
    
}
