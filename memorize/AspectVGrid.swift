//
//  AspectVGrid.swift
//  memorize
//
//  Created by KH on 09/05/2022.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
        var items: [Item]
        var aspectRatio: CGFloat
        var content: (Item) -> ItemView
    
    //closures are reference type like clases, @escaping is used in building views so the compiler don’t build a memory for it in the heap
    //we put @viewbuilder so we can tell the content view that we dont have to retuen a view from the function
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView){
        self.items=items
        self.aspectRatio=aspectRatio
        self.content=content
    }
    
    var body: some View {
        GeometryReader{
            geometry in
            
                VStack{
                    let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                    LazyVGrid(columns:[adaptiveGridItem(width: width)],spacing: 0){
                        ForEach(items){
                            item in content(item).aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                    Spacer(minLength: 0) //to make the vstack flexable
                }
            }
        }
        private func adaptiveGridItem(width: CGFloat) -> GridItem{
            var gridItem = GridItem(.adaptive(minimum: width))
            gridItem.spacing = 0
            return gridItem
        } //function to make the spacing between the cards 0 so it doesnt complicate the math used in dividing space to fit the card, the spacing between rows can be set to 0 in the lazy vgrid attributes, but between columns it has to be set seperatly
    
    
    //calculated function to have all cards on the screen
        private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat{
            var columnCount = 1
                   var rowCount = itemCount
                   repeat {
                       let itemWidth = size.width / CGFloat(columnCount)
                       let itemHeight = itemWidth / itemAspectRatio
                       if  CGFloat(rowCount) * itemHeight < size.height {
                           break
                       }
                       columnCount += 1
                       rowCount = (itemCount + (columnCount - 1)) / columnCount
                   } while columnCount < itemCount
                   if columnCount > itemCount {
                       columnCount = itemCount
                   }
                   return floor(size.width / CGFloat(columnCount))
               
            
        }
        
    }


//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
