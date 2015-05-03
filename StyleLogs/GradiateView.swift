//
//  GradiateView.swift
//  StyleLog
//
//  Created by 相澤 隆志 on 2015/04/26.
//  Copyright (c) 2015年 相澤 隆志. All rights reserved.
//

import UIKit


@IBDesignable
class GradiateView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        var path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSizeMake(8.0, 8.0))
        path.addClip()
        let context = UIGraphicsGetCurrentContext()
        makeGradiation(context)

    }

    private func makeGradiation( context:CGContextRef ) {
        let colors = [startColor.CGColor!, endColor.CGColor!]
        let colorSpace = CGColorSpaceCreateDeviceRGB()!
        
        let colorLocations = [0.0, 1.0] as [CGFloat]
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        var startPoint = CGPoint.zeroPoint
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            0)
    }

}
