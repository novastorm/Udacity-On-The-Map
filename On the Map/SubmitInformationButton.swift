//
//  SubmitInformationButton.swift
//  On the Map
//
//  Created by Adland Lee on 4/11/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

// MARK: - SubmitInformationButton: UIButton

class SubmitInformationButton: UIButton {
    
    // MARK: Properties
    
    // constants for styling and configuration
    let darkerBlue = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
    let lighterBlue = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    let titleLabelFontSize: CGFloat = 17.0
    let borderedButtonHeight: CGFloat = 44.0
    let borderedButtonCornerRadius: CGFloat = 4.0
    let phoneBorderedButtonExtraPadding: CGFloat = 14.0
    
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
    
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        applyTheme()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyTheme()
    }
    
    fileprivate func applyTheme() {
        layer.masksToBounds = true
        layer.cornerRadius = borderedButtonCornerRadius
        highlightedBackingColor = darkerBlue
        backingColor = lighterBlue
        backgroundColor = lighterBlue
        setTitleColor(UIColor.white, for: UIControlState())
        titleLabel?.font = UIFont.systemFont(ofSize: titleLabelFontSize)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTracking(with event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let extraButtonPadding : CGFloat = phoneBorderedButtonExtraPadding
        var sizeThatFits = CGSize.zero
        sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
        sizeThatFits.height = borderedButtonHeight
        return sizeThatFits
    }
}
