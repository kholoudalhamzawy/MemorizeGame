//
//  ContentView.swift
//  memorize
//
//  Created by KH on 31/03/2022.
//

import SwiftUI

struct ContentView: View {
     
    @ObservedObject var viewModel :EmojiMemoryGame
    @Namespace private var dealingNamespace //argument for the matching geometry effect

   
    var body: some View {
        ZStack(alignment:.bottom){ //so we make the deckbody flixable we put the whole thing in a zstack so it uses all the space offered to it, it looks better like when we turn around the screen
            VStack{
                Text("Score: \(viewModel.model.score)").bold()
                gameBody
                Spacer()
                HStack{
                    shuffle
                    Spacer()
                    theme
                }.padding()
            }
            VStack{
            Text(EmojiMemoryGame.ThemeName)
                deckBody}
        }
        .padding()
        .font(.title2)
        .foregroundColor(CardConstants.FrontCardColor)
    }
    
    @State private var dealt = Set<Int>() //is private cause no one will deal with it except the view, and @state cause we will only deal with it once we dont need it that much so we wont put it in the model;
    //it's also a property wrapper
    
    private func deal(_ card: MemoryGame<String>.Card){
        dealt.insert(card.id)
    }
    
    private func isUndealt (_ card: MemoryGame<String>.Card)->Bool{
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: MemoryGame<String>.Card)->Animation{
        var delay = 0.0
        if let index = viewModel.model.cards.firstIndex(where: {$0.id == card.id} ) //{$0.id == card.id} is an inline function, it's a for loop returning the first index that matches the card id;
            // and we put if cause it returnes an optional
        {
            delay = Double(index) * (CardConstants.totalDealDuration / (Double(viewModel.model.cards.count))) /
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay) //the delay method takes a double argument; we put the deal duration for one as a default rhen add the delay calculated based on each each index
            
        
    }
    private func zIndex(of card: MemoryGame<String>.Card)->Double{
        -Double(viewModel.model.cards.firstIndex(where: {$0.id == card.id}) ?? 0) //the first index method returns an optional, so if it returns nul we set the defult to 0, this is not ternary if;
        // we put mince '-' cauze the view modifier zindex puts the smallest index back, and the the last index towards the user's screen, so we want to shift that;
        

    }
    
    var gameBody: some View{
        AspectVGrid(items:viewModel.model.cards, aspectRatio: 2/3 , content:
                {card in
                    if isUndealt(card) || (card.isMatched && !card.isFaceUp){
                        Color.clear  // = Rectangle().opacity(0)
                    } else{ cardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: dealingNamespace) //we need a namespce to cpicify wich id we are in, it's another name for cards, namespace here is just a token
                            .padding(4)
                        //transition carries the view into and out of the screen
                        //transitins unlike animation when applied to a container it apply to it as a whole, animation just destripute it separatly on each view in the container.
                        //asymatric makes the transistion of the insertion of the view differnrt from the removal of it in the screen.
                            .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                        //on animation of transition, they all come on screen together
                            .zIndex(zIndex(of: card)) // puts the cards in the vgrid in the direction we want in the z axis, aka into or outward the screen
                            .onTapGesture {
                                //explicit animation the default is easeinout
                                withAnimation(.easeInOut(duration: 0.5)){
                                    viewModel.choose(card)

                                }
                            }
                    }
                }
        )
//            .onAppear{ //this makes the view container come first, then make the statement to happen after it appears
//                withAnimation {
//                    for card in viewModel.model.cards{
//                        deal(card)
//                    }
//                }
//            }
            .padding()
            .foregroundColor(CardConstants.BackCardColor)
            .font(Font.body)
    }
    
    var deckBody: some View{
        ZStack{ //filter takes a function that returns a bool, we can say .filter { isUndealt($0) } //where ($0) is the first argument of for each;
                // or we can just say .filter (isUndealt)
            ForEach(viewModel.model.cards.filter(isUndealt)){  card in
                cardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace) //this is what binds the two cards together;
                // match geometry effect makes the cards fly from the square of deck
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal:.identity))
                //we want the geometry effect to take over (meaning we dont want the cards to scale or anything during their transition from the deck) but we still want the effect of the transition on the insertion of the deck and the removal of the cards, se we put .identity as the argument, it means do nothing.
                    .zIndex(zIndex(of: card)) //must be put in both the cards and the deck so they be connected, just like match geometry effect
                
            }
        }//.frame make the view at a fixed size no matter what happens to the screen;
        //zstack take all the space given to it so we wont specify any allignment
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.BackCardColor)
        .onTapGesture {
                for card in viewModel.model.cards{
                    withAnimation(dealAnimation(for: card)){
                        deal(card)
                    }
                }
        }
    }
    
    private struct CardConstants{
        static let BackCardColor = Color.blue
        static let FrontCardColor = Color.purple
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let aspectRatio: CGFloat = 2/3
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
    var shuffle: some View{
        Button("shuffle"){
            withAnimation{
                viewModel.shuffle()
            }
        }
    }
    
    
    var theme: some View{
        Button{
            withAnimation{
                dealt=[] //this undeal everything before it before we deal it again
                viewModel.changeTheme()
            }
        } label:{
            Image(systemName: "heart")
        }
    }
    
//    var Heart: some View{
//        VStack{
//            Button{
//                viewModel.changeTheme3()
//            } label:{
//                Image(systemName: "heart")
//            }
//            Text("Heart")
//        }
//
//    }
//    var People: some View{
//        VStack{
//
//            Button{
//                viewModel.changeTheme1()
//
//
//            } label:{
//                Image(systemName: "face.smiling")
//            }
//            Text("People")
//
//        }
//
//    }
//    var Flag: some View{
//        VStack{
//            Button{
//                viewModel.changeTheme2()
//            } label:{
//                Image(systemName: "flag")
//            }
//            Text("Flag")
//        }
//
//    }
    
//    var add: some View{
//        Button {
//            if emojicount<emojis1.count{
//                emojicount += 1 }
//
//            } label: {
//                Image(systemName: "goforward.plus")}
//        }
//    var remove: some View{
//        Button {
//            if emojicount>1{
//                emojicount -= 1 }
//            } label: {Image(systemName: "gobackward.minus")}
//    }
    
}



struct cardView: View{
    let card: MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                Group{//just a view container to group things togethter (here an if statement) to apply viwe modifiers to
                    //we use if statement to make the pie go on timer till it ends and show nothing
                    if card.isConsumingBonusTime {
                        pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                        // =    pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))

                    }
                }
                
                
                        .padding(3).opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) //implicit animation, we rarely use it, and we dont apply it to the whole container (e.g. here the zstack), it's independent from explicit animation, and explicit animation dont overwrite implicit animation,the iplicit rules.
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
            
    }
        

    //cgsize means can be fixed in width and height
    //scale effect knows how to animate, Font doesnt, and u put a calculated fixed value in it so it dont do weird stuff when u rotate
    private func scale(thatFits size: CGSize)->CGFloat{
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    private struct DrawingConstants{
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
        
    }
}














struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game=EmojiMemoryGame()

        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
.previewInterfaceOrientation(.portraitUpsideDown)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)

    }
}
