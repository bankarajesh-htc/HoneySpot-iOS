//
//  ImageView.swift
//  HoneySpot
//
//  Created by htcuser on 25/01/22.
//  Copyright © 2022 HoneySpot. All rights reserved.
//

import UIKit

class ImageView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    static var instance = ImageView()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var honeySpotSave: UILabel!
    @IBOutlet var backBlackView: UIView!
    @IBOutlet var parentView: UIView!
    @IBOutlet var alertView: UIView!
    
    var actionCompletion:((AlertActionType)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("ImageView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(){
        alertView.clipsToBounds = true
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    func showAlert(imageString:String,actionButtonCompletion : ((AlertActionType)->())?) {
        //honeySpotSave.text = honeySpotString
        self.imageView.kf.setImage(with: URL(string: imageString))
        self.actionCompletion = actionButtonCompletion
        
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
    }
    
    @IBAction func actionTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.parentView.removeFromSuperview()
            self.actionCompletion!(AlertActionType.actionTapped)
        }
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.parentView.removeFromSuperview()
            self.actionCompletion!(.dismissTapped)
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.parentView.removeFromSuperview()
        }
    }

}
