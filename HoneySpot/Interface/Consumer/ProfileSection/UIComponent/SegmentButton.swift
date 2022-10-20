//
//  SegmentButton.swift
//  HoneySpot
//
//  Created by Max on 2/18/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit

protocol SegmentButtonDelegate {
    func didPressButton(_ sender: SegmentButton)
}

class SegmentButton: UIView {

    // UIComponents
    @IBOutlet weak var btnSegment: UIButton!
    @IBOutlet var vwContainer: UIView!
    
    // Variables
    var delegate: SegmentButtonDelegate!
    static let nibName:String = "SegmentButton"
    
    // Set segment buttons status
    // Set true to active or false to deactive
    var active: Bool = false {
        didSet {
            btnSegment?.tintColor = active ? .WHITE_COLOR : .ORANGE_COLOR
            btnSegment?.backgroundColor = active ? .ORANGE_COLOR : .LIGHTGRAY_COLOR
        }
    }
    var image: UIImage? = UIImage(named: "IconProfileGrid")! {
        didSet {
            guard let image = image else {
                return
            }
            btnSegment.setImage(image, for: .normal)
        }
    }
    
    @IBAction func onSegmentButtonTap(_ sender: Any) {
        delegate.didPressButton(self)
    }
    
    // Initialize via code
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit();
    }
    
    // Initialize via IB
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit();
    }
    
    // Initialize frame of the custom view to match its parent
    private func sharedInit() {
        Bundle.main.loadNibNamed(SegmentButton.nibName, owner: self, options: nil)
        addSubview(vwContainer)
        vwContainer.frame = self.bounds
        vwContainer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        vwContainer.translatesAutoresizingMaskIntoConstraints = true
        active = false
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
