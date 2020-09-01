//
//  CustomSlider.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/9/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

@IBDesignable class CustomSlider: UISlider {
    /// custom slider track height
    @IBInspectable var trackHeight: CGFloat = 3
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Use properly calculated rect
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    var thumbTextLabel: UILabel = UILabel()

    private var thumbFrame: CGRect {
        let unadjustedThumbrect = super.thumbRect(forBounds: bounds, trackRect: self.bounds, value: value)
        let thumbOffsetToApplyOnEachSide:CGFloat = unadjustedThumbrect.size.width / 2
        let minOffsetToAdd = -thumbOffsetToApplyOnEachSide + 5
        let maxOffsetToAdd = thumbOffsetToApplyOnEachSide - 5
        let offsetForValue = minOffsetToAdd + (maxOffsetToAdd - minOffsetToAdd) * CGFloat(value / (self.maximumValue - self.minimumValue))
        var origin = unadjustedThumbrect.origin
        origin.x += offsetForValue
        origin.y = -30
        return CGRect(origin: origin, size: unadjustedThumbrect.size)
    }
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect
    {
        let unadjustedThumbrect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let thumbOffsetToApplyOnEachSide:CGFloat = unadjustedThumbrect.size.width / 2
        let minOffsetToAdd = -thumbOffsetToApplyOnEachSide + 3
        let maxOffsetToAdd = thumbOffsetToApplyOnEachSide - 5
        let offsetForValue = minOffsetToAdd + (maxOffsetToAdd - minOffsetToAdd) * CGFloat(value / (self.maximumValue - self.minimumValue))
        var origin = unadjustedThumbrect.origin
        origin.x += offsetForValue
        origin.y = -20
        return CGRect(origin: origin, size: unadjustedThumbrect.size)
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        thumbTextLabel.frame = thumbFrame
        thumbTextLabel.font = UIFont(name: "Poppins-Bold", size: 15)
        thumbTextLabel.adjustsFontSizeToFitWidth = true
        thumbTextLabel.minimumScaleFactor = 0.5
        thumbTextLabel.textColor = UIColor.white
        thumbTextLabel.text = Double(value).rounded(toPlaces: 1).description
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(thumbTextLabel)
        thumbTextLabel.textAlignment = .center
        thumbTextLabel.layer.zPosition = layer.zPosition + 1
    }
    //MARK:- Adding MasksToBounds
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    //MARK:- Adding Corner Radius to TextField
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
