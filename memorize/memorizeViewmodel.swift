//
//  memorizeViewmodel.swift
//  memorize
//
//  Created by KH on 20/04/2022.
//

import SwiftUI //viewmodel is part of the UI


class EmojiMemoryGame: ObservableObject{
    

    enum emojis: CaseIterable{
        case signs
        case people
        case flags
        case hearts
    }
    //getter is public, but the setter is private
    private(set) static var ThemeName: String = ""
    private static var currentTheme: [String] = [""]

    
    private static func createMemoryGame(theme: emojis) -> MemoryGame<String> {
        switch theme {
        case .signs:
            ThemeName = "signs"
            currentTheme = ["♌️","☯️","♒️","♊️","⚛️","☸️","🕉","♎️"]
        case .people:
            ThemeName = "people"
            currentTheme = ["🤧","🤡","🙀","👻","💩","👺","👽","😮‍💨","😵‍💫","👾"]
        case .flags:
            ThemeName = "flags"
            currentTheme = ["🏳️","🏴","🏴‍☠️","🏁","🚩","🏳️‍🌈","🇧🇪","🇬🇵","🇯🇲"]
        case .hearts:
            ThemeName = "heart"
            currentTheme = ["💙","💜","💚","💛","🧡"]
        }
        currentTheme.shuffle()
       return MemoryGame<String>(numOfCards: currentTheme.count) {pairOfIndex in currentTheme[pairOfIndex]
        }

    }
    
    //models must be private
    
    @Published private(set) var model: MemoryGame<String> = createMemoryGame(theme: emojis.allCases.randomElement()!) //initilizing
//    private(set) var model1: MemoryGame<String>
//    private(set) var model2: MemoryGame<String>
//    private(set) var model3: MemoryGame<String>
//
    
    
    //we always use explicit animation when dealing with intents
    //intents so the view knows the model changed (it's just a mark to make it easier to read in the map)
    //MARK: - Intent(s)

    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card)
    }
    
    func changeTheme(){
        model = EmojiMemoryGame.createMemoryGame(theme:  EmojiMemoryGame.emojis.allCases.randomElement()! )
    }
    
    func shuffle(){
        model.shuffle()
    }
    
//    func changeTheme1(){
//        model = EmojiMemoryGame.createMemoryGame(theme: EmojiMemoryGame.emojis1.shuffled())
//    }
//    func changeTheme2(){
//        model = EmojiMemoryGame.createMemoryGame(theme: EmojiMemoryGame.emojis2.shuffled())
//    }
//    func changeTheme3(){
//        model = EmojiMemoryGame.createMemoryGame(theme: EmojiMemoryGame.emojis3.shuffled())
//    }
    
   
    //read only function to access cards; instead of using private(set)
//    var cards: Array<MemoryGame<String>.Card>{
//        return model.cards
//    }
   


    
}
