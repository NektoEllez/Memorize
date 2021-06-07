//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Иван Марин on 28.05.2021.
//

import SwiftUI

@main
struct MemorizeApp: App
{
    private let game    =   EmojiMemoryGame()
    
    var body    :   some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
