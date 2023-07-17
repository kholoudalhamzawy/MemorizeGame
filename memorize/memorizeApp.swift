//
//  memorizeApp.swift
//  memorize
//
//  Created by KH on 31/03/2022.
//

import SwiftUI

@main
struct memorizeApp: App {
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
