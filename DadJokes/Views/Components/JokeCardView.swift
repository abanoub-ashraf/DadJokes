import SwiftUI
import CoreData

struct JokeCardView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    ///
    /// this is because we don't wanna show the punch line of each joke
    /// when the app launches
    ///
    @State private var showingPunchline = false
    
    @State private var randomNumber = Int.random(in: 1...4)
    ///
    /// we gonan use this variable to move the whole card on the y axis
    /// up to delete it
    ///
    @State private var dragAmount = CGSize.zero
    
    var joke: Joke
    
    var body: some View {
        VStack {
            ///
            /// A container view that defines its content as a function
            /// of its own size and coordinate space
            ///
            GeometryReader { geo in
                VStack {
                    ///
                    /// - this is because we have 4 images assets thier names are from Dad1 to Dad4
                    ///
                    /// - this will assign random image from the assets to each joke
                    ///
                    Image("Dad\(randomNumber)")
                        .resizable()
                        .frame(width: 300, height: 100)
                    
                    Text(self.joke.setup)
                        .font(.largeTitle)
                        .lineLimit(10)
                        .padding([.horizontal])
                    
                    ///
                    /// - we will show/hide this based on the value of the showingPunchline variable
                    ///
                    /// - if it's true, don't blur it and its opacity is 1
                    ///   if it's false, blur it and reduce the opacity that it's almost hidden
                    ///
                    /// - the blur and the opacity will happen with animation because of
                    ///   the withAnimation block that's inside the onTapGesture block down there
                    ///
                    Text(self.joke.punchline)
                        .font(.title)
                        .lineLimit(10)
                        .padding([.horizontal, .bottom])
                        .blur(radius: self.showingPunchline ? 0 : 6)
                        .opacity(self.showingPunchline ? 1 : 0.25)
                }
                ///
                /// apply this to the views inside the inner VStack
                /// to align the text of each Text inside the VStack
                ///
                .multilineTextAlignment(.center)
                ///
                /// to make this view like in a shape of a card
                ///
                .clipShape(
                    RoundedRectangle(cornerRadius: 25)
                )
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.init(.systemPink))
                        .shadow(color: .black, radius: 5, x: 0, y: 0)
                )
                ///
                /// - toggle the showingPunchline variable everytime we tap on the inner VStack
                ///
                /// - and based on the toggle we will show/hide the punchline with animation
                ///
                /// - with animation animate anything results to the toggling of that variable
                ///
                .onTapGesture {
                    withAnimation {
                        self.showingPunchline.toggle()
                    }
                }
                ///
                /// 3d rotation
                ///
                .rotation3DEffect(
                    .degrees(-Double(geo.frame(in: .global).minX) / 10),
                    axis: (x: 0, y: 1, z: 0)
                )
            }
            .aspectRatio(0.6, contentMode: .fit)
            
            EmojiView(for: joke.rating)
                .font(.system(size: 72))
        }
        ///
        /// the height of the outter VStack is flexible
        /// but its width is fixed
        ///
        .frame(minHeight: 0, maxHeight: .infinity)
        .frame(width: 300)
        ///
        /// lay the view on the y axis based on this variable's height value
        /// cause height is the y axis
        ///
        .offset(y: dragAmount.height)
        .gesture(
            ///
            /// - the gesture help us dragging the card
            ///   we wanna drag on the y axis only, that's why the offset of the card is dragAmount.height
            ///
            DragGesture()
                ///
                /// - when the dragging starts set the dragAmount variable to be the amount of dragging
                ///   we currently doing with our finger on the screen
                ///
                /// - value.translation is The total translation from the start of the drag gesture
                ///   to the current event of the drag gesture
                ///
                .onChanged { value in
                    self.dragAmount = value.translation
                }
                ///
                /// when the dragging ends check that amount of dragging we set
                /// if it's less then -200, delete the card view and the joke from the database
                /// else, set the variable back to zero to put the card back to its original place
                ///
                .onEnded { value in
                    if self.dragAmount.height < -200 {
                        ///
                        /// - first send the card view out of the screen
                        ///
                        /// - then delete the joke from the main thread
                        ///   both with animation
                        ///
                        withAnimation {
                            self.dragAmount = CGSize(width: 0, height: -1000)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.managedObjectContext.delete(self.joke)
                                
                                try? self.managedObjectContext.save()
                            }
                        }
                    } else {
                        self.dragAmount = .zero
                    }
                }
        )
        ///
        /// to add a smooth animation when we swipe the card on the y axis
        ///
        .animation(.spring())
    }
}
