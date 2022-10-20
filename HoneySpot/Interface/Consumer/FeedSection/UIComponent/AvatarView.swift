//
//  AvatarView.swift
//  HoneySpot
//
//  Created by Max on 2/13/19.
//  Copyright © 2019 HoneySpot. All rights reserved.
//

import UIKit
 

protocol AvatarViewDelegate {
    func didTapAvatarView(_ sender: AvatarView)
}

@IBDesignable
class AvatarView: UIView {
    
    var imageView: UIImageView = UIImageView()
    var containerView: UIView = UIView()
    var editLabel: UILabel = UILabel()
    var button: UIButton = UIButton()
    var delegate: AvatarViewDelegate?
    
    var userModel : UserModel? {
        didSet {
            DispatchQueue.main.async {
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.frame = self.containerView.bounds
            }
            self.imageView.kf.setImage(with: URL(string: self.userModel?.pictureUrl ?? ""), placeholder: UIImage(named: "AvatarPlaceHolder"), options: nil)
        }
    }
    
    var spotModel: SpotModel? {
        didSet {
            self.imageView.kf.setImage(with: URL(string: self.spotModel?.photoUrl ?? ""), placeholder: UIImage(named: "AvatarPlaceHolder"), options: nil)
            DispatchQueue.main.async {
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.frame = self.containerView.bounds
            }
        }
    }
    
    var editMode: Bool = false {
        didSet {
            editLabel.isHidden = !editMode
            self.button.isUserInteractionEnabled = editMode
        }
    }
    
    @IBInspectable
    override var borderColor: UIColor? {
        get {
            guard let color = containerView.layer.borderColor else {
                return UIColor.white
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                containerView.layer.borderColor = UIColor.white.cgColor
                return
            }
            containerView.layer.borderColor = color.cgColor
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }
    
    func sharedInit() {
        // Common logic goes here
        backgroundColor = UIColor.clear

        containerView.backgroundColor = .white
        containerView.layer.borderColor = self.borderColor?.cgColor ?? UIColor.white.cgColor
        containerView.layer.borderWidth = 3
        containerView.clipsToBounds = true
        addSubview(containerView)

        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
//        if user != nil {
//            imageView.image = UIImage(named: "AvatarPlaceHolder")
//        } else if spot != nil {
//            imageView.image = UIImage(named: "IconSmallPlace")
//        }
        containerView.addSubview(imageView)

        editLabel.backgroundColor = .white
        editLabel.textColor = .ORANGE_COLOR
        editLabel.textAlignment = .center
        editLabel.font = UIFont(name: "Montserrat-Bold", size: 11)
        editLabel.text = "Edit"
        containerView.addSubview(editLabel)
        
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        containerView.addSubview(button)

//        user = nil
//        spot = nil
        editMode = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        var w = bounds.size.width
        var h = bounds.size.height
        let s = min(w, h)
        containerView.frame = CGRect(x: CGFloat((w - s) / 2), y: CGFloat((h - s) / 2), width: CGFloat(s), height: CGFloat(s))
        containerView.layer.cornerRadius = CGFloat(s / 2)
        
        button.frame = containerView.bounds

        w = CGFloat(containerView.bounds.size.width)
        h = CGFloat(containerView.bounds.size.height)
        editLabel.frame = CGRect(x: 0, y: CGFloat(h * 0.75), width: CGFloat(s), height: CGFloat(h * 0.25))

//        if user != nil || spot != nil {
//            imageView.frame = containerView.bounds
//        } else {
//            imageView.frame = CGRect(x: CGFloat(w * 0.20), y: CGFloat(h * 0.20), width: CGFloat(w * 0.6), height: CGFloat(h * 0.6))
//        }
    }

    @IBAction func onButtonTap(sender: UIButton!) {
        guard let delegate = self.delegate else {
            return
        }
        if editMode {
            delegate.didTapAvatarView(self)
        }
    }
}
