//
//  Cardify.swift
//  Memorize
//
//  Created by Иван Марин on 02.06.2021.
//

import SwiftUI

struct Cardify                      :   AnimatableModifier {
    var rotation                    :   Double
    
    init(isFaceUp                   :   Bool) {
        rotation                    =   isFaceUp    ?   0    :   180
    }
    
    var isFaceUp                    :   Bool    {
        rotation                    <   90
    }
    
    var animatableData              :   Double  {
        get { return                    rotation    }
        set { rotation              =   newValue    }
    }
    
    func body(content               :   Content) -> some View   {
        ZStack {
            let draw                =   DrawingConstants.self
            let shape               =   RoundedRectangle(
                cornerRadius        :   draw.cornelRadius)
            Group {
                shape.fill().foregroundColor(.white) // белый фон карт
                shape.strokeBorder(
                    lineWidth       :   draw.lineWidth)
                content
            }
                .opacity(isFaceUp   ?   1   :   0)
            shape.fill()
                .opacity(isFaceUp   ?   0   :   1)
        }
        .rotation3DEffect(
            Angle.degrees(rotation),
            axis                    :   (0, 1 , 0)
        )
    }
    
    struct DrawingConstants {
        static let cornelRadius     :   CGFloat = 10
        static let lineWidth        :   CGFloat = 3
        static let fontScale        :   CGFloat = 0.7
        static let padding          :   CGFloat = 5
        static let opacity          :   Double  = 0.4
    }
}

extension View {
    func cardify(isFaceUp           :   Bool) -> some View {
        self.modifier(
            Cardify(isFaceUp        : isFaceUp)
        )
    }
}
