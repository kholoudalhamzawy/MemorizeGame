//
//  memorizeModel.swift
//  memorize
//
//  Created by KH on 20/04/2022.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    private(set) var score: Int
    
    init(numOfCards: Int, createCardContent: (Int) -> CardContent){
        cards = Array<Card>()
        score = 0
        //add numOfCards *2 to cards
        for pairIndex in 0..<numOfCards{
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
        
        
    }
    
    struct Card: Identifiable{
        var isPreviewed = false
        var isFaceUp = false { //this that makes the cards continue the timer from where it started
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        let id: Int
        
        //copied
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    
//
    }
    private var faceUPCardIndex: Int?{
        get{ cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly }
        set{
            cards.indices.forEach /*(*/ {cards[$0].isFaceUp = ($0 == newValue)} /*)*/ //paranthases are removed cause last argument //normal for loop used as a method on instances
        }
        // index in cards[index] --> just cards[$0] //closures //inline functions
        
    }
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card){
        if let chosenInedx = cards.firstIndex(where: {$0.id==card.id}),
           !cards[chosenInedx].isFaceUp,
           !cards[chosenInedx].isMatched
        {  if let potentialMatchIndex = faceUPCardIndex{
                if cards[chosenInedx].content == cards[potentialMatchIndex].content{
                    cards[chosenInedx].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score+=2
                }
            else{ if cards[chosenInedx].isPreviewed{
                score-=1
            }
             if cards[potentialMatchIndex].isPreviewed{
                score-=1
             }}
            cards[potentialMatchIndex].isPreviewed = true
            cards[chosenInedx].isPreviewed = true
            cards[chosenInedx].isFaceUp = true


            }else{ //choosing a new card after the two
            
            faceUPCardIndex = chosenInedx
            }

        }
        
        
    }
    
    func index(of card: Card) -> Int{
        for index in 0..<cards.count{
            if cards[index].id == card.id{
                return index
            }
        }
        return 0
    }
    
    
    
}
extension Array{
    var oneAndOnly: Element?{
        if count == 1{ //self.count
            return first //self.first
        }else{
            return nil
        }
    }
}
