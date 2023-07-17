//
//  viewModefier.swift
//  memorize
//
//  Created by KH on 10/05/2022.
//

import SwiftUI

struct Cardify: AnimatableModifier{
    
    
    //we are animating it based on rotation, when it gets past 90 the cards change during the rotaion, and while it turns from 0 to 180 as we choose the card, the animatable modifier animates the change.
    init(isFaceUp: Bool){
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double{
        get { rotation }
        set { rotation = newValue }
    }
    var rotation: Double //in degree
    
    func body(content: Content) -> some View{
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRasdius)
            if rotation < 90{
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
               shape.fill(Color(hue: 0.739, saturation: 0.296, brightness: 0.871))
           }
            else{
                shape.fill()
            }
            content.opacity(rotation < 90 ? 1 : 0)
            //we put the content outside the zstack so we make sure it's allways appearing on the view so when we animate it it do animate, we just hide it from the user
        }
        //angle.degrees is a static functions
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
        private struct DrawingConstants{
            static let cornerRasdius: CGFloat = 10
            static let lineWidth: CGFloat = 3
            
        }
    
    
}

extension View {
    func cardify(isFaceUp: Bool) -> some View{
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
//Return type of instance method 'Cardify(isFaceUp:)' requires that 'some View' conform to 'ViewModifier' //error
//was fixed by not naming the function Cardify with capital 'C', instead was just with small, unlike the viewmodifier name

