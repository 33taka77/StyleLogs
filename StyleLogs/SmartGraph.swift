//
//  SmartGraph.swift
//  CoreGraphicsTest
//
//  Created by 相澤 隆志 on 2015/04/24.
//  Copyright (c) 2015年 Aizawa Takashi. All rights reserved.
//

import UIKit

@IBDesignable
class SmartGraph: UIView {
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()

    var plotData1:[CGFloat] = [80,78,79,84,76,75,78]
    var plotData2:[CGFloat] = [83,79,81,85,79,74,77]
    var plotLabel:[String] = ["1","2","3","4","5","6","7"]
    
    var scale:graphScale = graphScale.week
    
    var targetWeight:CGFloat = 68
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let width:CGFloat = rect.width
        let height:CGFloat = rect.height
        
        var path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSizeMake(8.0, 8.0))
        path.addClip()
        
        let context = UIGraphicsGetCurrentContext()
        makeGradiation(context)
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let margin:CGFloat = 20.0

        self.drawAxis(margin, topBorder: topBorder, bottomBorder: bottomBorder, width: width, height: height)
        self.drawGraph(plotData1, margin: margin, topBorder: topBorder, bottomBorder: bottomBorder, width: width, height: height, color: UIColor.blackColor())
        self.drawGraph(plotData2, margin: margin, topBorder: topBorder, bottomBorder: bottomBorder, width: width, height: height, color: UIColor.whiteColor())
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
    
    private func drawAxis(margin:CGFloat, topBorder:CGFloat, bottomBorder:CGFloat, width:CGFloat, height:CGFloat) {
        //Draw horizontal graph lines on the top of everything
        var linePath = UIBezierPath()
        let graphHeight = height - topBorder - bottomBorder
        
        //top line
        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin,
            y:topBorder))
        let str = String(format: "%.1f", arguments: [maxValue()+10.0])
        drawText( 3,y: topBorder-5, string: str, fontSize: 8.0, textColor: UIColor.whiteColor())

        let range:CGFloat = maxValue()+10.0 - (self.targetWeight-10.0)
        let numOfLine:CGFloat = range / 10.0
        let delta:CGFloat = graphHeight / numOfLine
        
        for var i = 1; i < Int(numOfLine+1); i++ {
            linePath.moveToPoint(CGPoint(x:margin, y: delta*CGFloat(i) + topBorder))
            linePath.addLineToPoint(CGPoint(x:width - margin, y:delta*CGFloat(i) + topBorder))
            let str = String(format: "%.1f", arguments: [maxValue()+10.0-10.0*CGFloat(i)])
            drawText( 3,y: delta*CGFloat(i) + topBorder-5, string: str, fontSize: 8.0, textColor: UIColor.whiteColor())
        }
        //bottom line
        linePath.moveToPoint(CGPoint(x:margin,
            y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.7)
        color.setStroke()
        
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        

        var count:CGFloat
        switch self.scale {
        case .week:
            count = 7
        case .month:
            count = 6
        case .treeMonth:
            count = 12
        case .sixMonth:
            count = 12
        case .year:
            count = 12
        default:
            println("error")
        }
        let space = (width - margin*2)/count
        for var j:Int = 0; j < Int(count); j++ {
            drawText( space*(CGFloat(j)+1),y: height - bottomBorder, string: plotLabel[j], fontSize: 8.0, textColor: UIColor.whiteColor())
        }
        
        
        //drawText( 100,y: 100, string: "1", fontSize: 10.0, textColor: UIColor.whiteColor())
       
    }
    
    private func drawText( x:CGFloat, y:CGFloat, string:String, fontSize:CGFloat, textColor:UIColor ) {
        let label:UILabel = UILabel()
        label.font = UIFont.systemFontOfSize(fontSize)
        label.textColor = textColor
        label.text = string
        label.frame = CGRectMake(x, y, 100, 20)
        self.addSubview(label)
    }
    
    private func drawGraph(data:[CGFloat],margin:CGFloat, topBorder:CGFloat, bottomBorder:CGFloat, width:CGFloat, height:CGFloat, color:UIColor) {
        func xPoint(column:Int)->CGFloat {
            let xSpace:CGFloat = (width - margin*CGFloat(2))/(CGFloat(data.count-1))
            var point = xSpace*CGFloat(column)+margin
            return point
        }
        func yPoint(value:CGFloat)->CGFloat {
            let poinPerWeight:CGFloat = (height-topBorder-bottomBorder)/((maxValue()+10.0) - (self.targetWeight-10.0))
            let delta = maxValue()+10.0-value
            let point = poinPerWeight*delta+topBorder
            return point
        }
        color.setFill()
        color.setStroke()
        var graphPath = UIBezierPath()
        graphPath.moveToPoint(CGPoint(x:xPoint(0),
            y:yPoint(data[0])))
        
        for i in 1..<data.count {
            let val = data[i]
            if val == 0 {
                continue
            }
            let nextPoint = CGPoint(x:xPoint(i),
                y:yPoint(data[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        for i in 0..<data.count {
            let val = data[i]
            if val == 0 {
                continue
            }
            var point = CGPoint(x:xPoint(i), y:yPoint(data[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalInRect:
                CGRect(origin: point,
                    size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        //target line
        var linePath = UIBezierPath()
        linePath.moveToPoint(CGPoint(x:margin,
            y:yPoint(targetWeight)))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:yPoint(targetWeight)))
        let color = UIColor.redColor()
        color.setStroke()
        linePath.stroke()
        let targetStr = String(format: "%.2f", arguments: [self.targetWeight])
        drawText( margin-10,y: yPoint(targetWeight), string: targetStr, fontSize: 10.0, textColor: UIColor.redColor())

    }
    
    private func maxValue()->CGFloat {
        var maxValue:CGFloat = 0
        for value in plotData1 {
            if maxValue < value {
                maxValue = value
            }
        }
        for value in plotData2 {
            if maxValue < value {
                maxValue = value
            }
        }
        return maxValue
    }
    
    func setPlot1( plots:[CGFloat] ) {
        plotData1 = plots
        
    }
    func setPlot2( plots:[CGFloat] ) {
        plotData2 = plots
    }
    
    func setAxisLabel( scale:graphScale, labels:[String] ) {
        self.scale = scale
        plotLabel = labels
    }
    enum graphScale{
        case week
        case month
        case treeMonth
        case sixMonth
        case year
    }

}
