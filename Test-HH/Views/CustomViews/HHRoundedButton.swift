//
//  HHRoundedButton.swift
//  Test-HH
//
//  Created by Alexander Batalov on 2/25/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

@IBDesignable class HHRoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            refreshCorners(cornerRadius)
        }
    }
    
    @IBInspectable var backgroundImageColor: UIColor = UIColor.init(red: 0, green: 122/255.0, blue: 255/255.0, alpha: 1) {
        didSet {
            refreshColor(backgroundImageColor)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    private func sharedInit() {
        refreshCorners(cornerRadius)
        refreshColor(backgroundImageColor)
    }
    
    private func refreshCorners(_ value: CGFloat) {
        layer.cornerRadius = value
    }
    
    private func refreshColor(_ color: UIColor) {
        let image = createImage(fromColor: color)
        setBackgroundImage(image, for: .normal)
        clipsToBounds = true
    }
    
    private func createImage(fromColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
}
