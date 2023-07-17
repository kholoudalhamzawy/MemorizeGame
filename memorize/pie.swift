//
//  pie.swift
//  memorize
//
//  Created by KH on 10/05/2022.
//

import SwiftUI

struct pie: Shape{
    var startAngle: Angle
    var endAngle: Angle
    var clockWise: Bool = false
    //the (0,0) point in the grid is at the top left of the card, and the line it begins from is 90 degrees from the compus wise, so we have to flip the clock movement 
//      90
// 270       0
//      360
    
    //in order to make the pie shape animatable we have to add up this protocole, animatable var, and the pair of generics must be vector arithmatic
    var animatableData: AnimatablePair<Double, Double>{ //the animatable data here are just the start angle and the endangle
        get{
            AnimatablePair(startAngle.radians,endAngle.radians) //just a rename (aliase) for the two angles
        }
        set{
            startAngle = Angle.radians(newValue.first) // new value is the name set in language for the new value given by the user
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width,rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        //some instruction to draw the shape of the pie, built in methods of the struct Path
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: !clockWise
                 )
        p.addLine(to: center)
        return p
    }
    
    
}
