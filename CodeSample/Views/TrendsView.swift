//
//  TrendsView.swift
//  Heart Kinetics
//
//  Created by Alexandre Laurin on 12/6/17.
//  Copyright © 2017 Heart Kinetics. All rights reserved.
//

import UIKit

class TrendsView: UIView {

    var graphPath = UIBezierPath()
    var markerPaths:[UIBezierPath] = []
    
    var graphXData:[Double] = [2,10,10,8,5,2]
    var graphYData:[Double] = [2,2,10,12,11,10]
    var graphColor:UIColor = Background1
    
    var markerColor:UIColor = Background1
    var markerRadius:CGFloat = 2
    var markerLineWidth:CGFloat = 1
    var lineWidth:CGFloat = 1
    
    var setXmin:Double?
    var setYmin:Double?
    var setXmax:Double?
    var setYmax:Double?
    var setHeight:CGFloat?
    var setWidth:CGFloat?
    
    var leftMargin:CGFloat = 35
    var rightMargin:CGFloat = 70
    var topBorder:CGFloat = 40
    var bottomBorder:CGFloat = 55
    
    var maxXValue:Double?
    var minXValue:Double?
    var maxYValue:Double?
    var minYValue:Double?
    var graphWidth:CGFloat?
    var graphHeight:CGFloat?
    
    
    var rounded:Bool = false
    
    //properties for the background gradient
    @IBInspectable var startColor: UIColor = Grey2
    @IBInspectable var endColor: UIColor = Grey2
    
    func setupGraph() {
        // setup looks at preset values to place the graph intelligently in the fram
        
        let width = self.bounds.width
        
        let height = self.bounds.height
        
        // if user did not specify height, default to borders
        if self.setHeight == nil {
            graphHeight = height - topBorder - bottomBorder
        } else {
            graphHeight = self.setHeight! - topBorder - bottomBorder
        }
        
        // if user did not specify width, default to borders
        if self.setWidth == nil {
            graphWidth = width - topBorder - bottomBorder
        } else {
            graphWidth = self.setWidth! - leftMargin - rightMargin
        }
        
        // user can specify max and min values in the graph, to make them land on nice round numbers, for example
        if self.setYmax == nil {
            if let max = graphYData.max() {
                maxYValue = max
            } else {
                maxYValue = 1
            }
        } else {
            maxYValue = self.setYmax!
        }
        
        if self.setYmin == nil {
            if let min = graphYData.min(){
                minYValue = min
            } else {
                minYValue = -1
            }
        } else {
            minYValue = self.setYmin!
        }
        
        if self.setXmax == nil {
            if let max = graphXData.max() {
                maxXValue = max
            } else {
                maxXValue = 1
            }
        } else {
            maxXValue = self.setXmax!
        }
        
        if self.setXmin == nil {
            if let min = graphXData.min(){
                minXValue = min
            } else {
                minXValue = -1
            }
        } else {
            minXValue = self.setXmin!
        }
        
    }
    
    
    func addSegment(x: [Double], y:[Double]) {
        // call this function to add segments in the graph after it was setup and loaded, this is useful to obtain animations
        if x.count > 0 && x.count == y.count {
            if graphPath.isEmpty {
                graphPath.move(to: CGPoint(x:columnXPoint(graphPoint: x[0]), y:columnYPoint(graphPoint: y[0])))
                markerPaths.append(drawCircle(around: CGPoint(x:columnXPoint(graphPoint: x[0]), y:columnYPoint(graphPoint: y[0]))))
                
                for i in 1..<x.count {
                    let nextPoint = CGPoint(x:columnXPoint(graphPoint: x[i]),
                                            y:columnYPoint(graphPoint: y[i]))
                    graphPath.addLine(to: nextPoint)
                    markerPaths.append(drawCircle(around: CGPoint(x:columnXPoint(graphPoint: x[i]), y:columnYPoint(graphPoint: y[i]))))
                }
            } else {
                
                for i in 0..<x.count {
                    let nextPoint = CGPoint(x:columnXPoint(graphPoint: x[i]),
                                            y:columnYPoint(graphPoint: y[i]))
                    graphPath.addLine(to: nextPoint)
                    markerPaths.append(drawCircle(around: CGPoint(x:columnXPoint(graphPoint: x[i]), y:columnYPoint(graphPoint: y[i]))))
                }
            }
            graphPath.lineWidth = lineWidth
            //
        } else {
            print("Empty graph.")
        }
    }
    
    func drawCircle(around: CGPoint) -> UIBezierPath {
        let newPath = UIBezierPath()
        newPath.move(to: CGPoint(x:around.x + markerRadius, y:around.y))
        newPath.addArc(withCenter: around, radius: markerRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        newPath.lineWidth = markerLineWidth
        return newPath
    }
    
    override func draw(_ rect: CGRect) {
        setupGraph()
        
        //1 - set up background clipping area
        if rounded {
            self.layer.cornerRadius = 8.0
            self.clipsToBounds = true
        }
        
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)
        
        //6 - draw the gradient
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        context!.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: CGGradientDrawingOptions(rawValue: 0))
        
        
        //        //Create the clipping path for the graph gradient
        //
        //        //1 - save the state of the context (commented out for now)
        //        //CGContextSaveGState(context)
        //
        //        //2 - make a copy of the path
        //        let clippingPath = graphPath.copy() as! UIBezierPath
        //
        //        //3 - add lines to the copied path to complete the clip area
        //        clippingPath.addLine(to: CGPoint(
        //            x: columnXPoint(graphPoint: maxXValue!),
        //            y:height))
        //        clippingPath.addLine(to: CGPoint(
        //            x:columnXPoint(graphPoint: minXValue!),
        //            y:height))
        //        clippingPath.close()
        //
        //        //4 - add the clipping path to the context
        //        clippingPath.addClip()
        //
        //        //5 - check clipping path - temporary code
        //        let highestYPoint = columnYPoint(graphPoint: maxYValue!)
        //        let gradStartPoint = CGPoint(x:xMargin, y: highestYPoint)
        //        let gradEndPoint = CGPoint(x:xMargin, y:self.bounds.height)
        //
        //        context!.drawLinearGradient(gradient!,
        //                                            start: gradStartPoint,
        //                                            end: gradEndPoint,
        //                                            options: CGGradientDrawingOptions(rawValue: 0))
        
        graphColor.setFill()
        graphColor.setStroke()
        graphPath.stroke()
        
        for markerPath in markerPaths {
            startColor.setFill()
            markerColor.setStroke()
            markerPath.fill()
            markerPath.stroke()
        }
    }
    
    func columnXPoint(graphPoint:Double) -> CGFloat {
        var x:CGFloat = CGFloat(graphPoint - minXValue!) /
            CGFloat(maxXValue! - minXValue!) * graphWidth!
        x = x + self.leftMargin
        return x
    }
    
    func columnYPoint(graphPoint:Double) -> CGFloat {
        var y:CGFloat = CGFloat(graphPoint - minYValue!) /
            CGFloat(maxYValue! - minYValue!) * graphHeight!
        y = graphHeight! + self.topBorder - y // Flip the graph
        return y
    }
    

}
