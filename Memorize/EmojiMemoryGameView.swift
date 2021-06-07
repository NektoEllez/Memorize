//
//  ContentView.swift
//  Memorize
//
//  Created by Иван Марин on 28.05.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View
{
    
    @ObservedObject var game        : EmojiMemoryGame
    
    var body: some View {
        VStack {
            AspectVGrid(items: game.cards, aspectRatio: 4 / 6) { card in
                if card.isMatched && !card.isFaceUp {
                    Rectangle().opacity(0)
                } else {
                    CardView(card: card).onTapGesture {
                        withAnimation(.linear(duration: 0.75)) {
                            game.choose(card)
                        }
                    }
                        .onTapGesture { game.choose(card) }
                        .foregroundColor(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
                        .padding(2)
                }
            }
            Button(action: {
                withAnimation(.easeInOut(duration: 0.75)) {
                    game.resetGame()
                }
            } , label: {
                Text("Shuffle")
                Image(systemName: "shuffle.circle.fill")
            } )
            .font(.largeTitle)
        }
    }
    
}

struct CardView: View {
    
    let card        :   EmojiMemoryGame.Card
    
    var body        : some View {
        GeometryReader { geometry in
            self.body(
                for : geometry.size
            )
        }
    }
    
    let draw        =   Cardify.DrawingConstants.self
    
    @State private var animatedBonusRemaining: Double   =   0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining      =   card.bonusRemaining
        withAnimation(
            .linear(
                duration            : card.bonusTimeRemaining
            )
        )
        {
            animatedBonusRemaining  =   0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize)    ->  some View {
        GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Group {
                        if card.isConsumingBonusTime {
                            Pie(
                                startAngle  : Angle.degrees(0-90),
                                endAngle    : Angle.degrees(-animatedBonusRemaining * 360-90)
                            )
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                        } else {
                            Pie(
                                startAngle  : Angle.degrees(0-90),
                                endAngle    : Angle.degrees(-card.bonusRemaining * 360-90)
                            )
                        }
                    }
                    .padding(draw.padding).opacity(draw.opacity)
                    .transition(.identity)
                    Text(card.content)
                        .font(font(in: geometry.size))
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .default)
                }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(AnyTransition.scale)
            }
        }
    }
    
    private func font(in size: CGSize) -> Font{
        Font.system(size: min(size.width, size.height) * draw.fontScale)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
