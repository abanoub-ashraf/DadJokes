import SwiftUI
import CoreData

struct ContentView: View {
    ///
    /// get the context from the environment inside the SceneDelegate
    /// and save it in this moc variable
    ///
    @Environment(\.managedObjectContext) var managedObjectContext
    ///
    /// keep the value of this variable in memory when the struct is destroyed and recreated by SwiftUI
    ///
    @State private var showingAddJoke = false
    ///
    /// - query the coredata database and fetch stuff from any entity you have
    ///
    /// - sort the fetched data assending, based on one of the entity atributes
    ///
    @FetchRequest(entity: Joke.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Joke.setup, ascending: true)
    ])
    
    ///
    /// this is the results that will be fetched from the fetch request above
    ///
    var jokes: FetchedResults<Joke>
    
    ///
    /// this is the olde content of the body inside this content view file
    ///
//    var body: some View {
//        NavigationView {
//            ///
//            /// this list is like table view in UIKit
//            ///
//            List {
//                ///
//                /// - either use id as a key path like this to use a unique identifier
//                ///   for each joke inside the jokes array
//                ///
//                /// - or let the JokeModel comform to the Identefiable Protocol
//                ///   and add a var id = UUID() inside the JokeModel struct
//                ///
//                ForEach(jokes, id: \.setup) { joke in
//                    ///
//                    /// - the go to a text that has the punchline
//                    ///   of the joke when a joke is tapped
//                    ///
//                    /// - EmojiView and Text are what is tappable in each row
//                    ///
//                    NavigationLink(destination: Text(joke.punchline)) {
//                        ///
//                        /// SwiftUI assummed these two must be in an HStack on its own
//                        ///
//                        EmojiView(for: joke.rating)
//                        Text(joke.setup)
//                    }
//                }
//                ///
//                /// - this modifier wil give us a swipe to the left to delete functionality
//                ///   for each row in the ForEach of the List
//                ///
//                /// - this modifer works only on ForEach, that's why we need Foreach inside the List
//                ///   and not just the Liat directly
//                ///
//                .onDelete(perform: removeJokes)
//            }
//            ///
//            /// a title for the navigation bar of this view
//            ///
//            .navigationBarTitle("All Groan Up")
//            ///
//            /// - add an add button on the right side of the navigation bar
//            ///   for adding a new joke to the list
//            ///
//            /// - that add button will change the value of the showingAddJoke variable
//            ///
//            /// - add another button to the left side of the navigation bar
//            ///   for toggeling the Edit Mode
//            ///
//            .navigationBarItems(leading: EditButton(), trailing: Button("Add") {
//                self.showingAddJoke.toggle()
//            })
//            ///
//            /// - when the showingAddJoke is true the sheet will show up
//            ///
//            /// - when the sheet is dismissed it will set showingAddJoke to false
//            ///   cause it's 2 way binding
//            ///
//            .sheet(isPresented: $showingAddJoke) {
//                ///
//                /// - this view will be shown when the variable above is true
//                ///
//                /// - pass the coredata context to its environment
//                ///
//                /// - if we pass the context to a navigation view or a parent view
//                ///   then all the sub views will have it, but in this case
//                ///   we displaying a new screen on the screen that's not related to
//                ///   any navigation view stack or a sub view to any parent
//                ///   that's why we need to pass the context manually like this
//                ///
//                AddView().environment(\.managedObjectContext, self.managedObjectContext)
//            }
//        }
//    }
   
    var body: some View {
        ///
        /// - alignment to align the content of the stack to the top
        ///
        /// - this let us layer views on top of each others
        ///    from the bottom to top
        ///
        /// - the LinearGradient is gonna be at the back of the other views (the background)
        ///
        ZStack(alignment: .top) {
            LinearGradient(
                ///
                /// those colors names are coming from the assets
                ///
                gradient: Gradient(colors: [Color("Start"), Color("Middle"), Color("End")]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            ///
            /// put the jokes we get from the database in a HStack of cards
            ///
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(jokes, id: \.setup) { joke in
                        JokeCardView(joke: joke)
                    }
                }
                .padding(.horizontal)
            }
            
            ///
            /// this button will toggle the showingAddJoke variable
            /// so the sheet displays the AddView on the screen
            ///
            Button("Add Joke") {
                self.showingAddJoke.toggle()
            }
            ///
            /// - the order of the modifiers matters
            ///
            /// - clipShape to give it a backround shape
            ///
            /// - offest to push the button down a little bit away from the notch
            ///
            .padding()
            .background(Color.black.opacity(0.5))
            .clipShape(Capsule())
            .foregroundColor(.white)
            .offset(y: 60)
        }
        ///
        /// to tell the ZStack to fill the entire screen and ignore the safe area
        ///
        .edgesIgnoringSafeArea(.all)
        ///
        /// - when the showingAddJoke is true the sheet will show up
        ///
        /// - when the sheet is dismissed it will set showingAddJoke to false
        ///   cause it's 2 way binding
        ///
        .sheet(isPresented: $showingAddJoke) {
            ///
            /// - this view will be shown when the variable above is true
            ///
            /// - pass the coredata context to its environment
            ///
            /// - if we pass the context to a navigation view or a parent view
            ///   then all the sub views will have it, but in this case
            ///   we displaying a new screen on the screen that's not related to
            ///   any navigation view stack or a sub view to any parent
            ///   that's why we need to pass the context manually like this
            ///
            AddView().environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
    
    ///
    /// - remove a joke at a specific index
    ///
    /// - IndexSet is a collection of unique integer values that represent
    ///   the indexes of elements in another collection
    ///
    func removeJokes(at offsets: IndexSet) {
        for index in offsets {
            let joke = jokes[index]
            managedObjectContext.delete(joke)
        }
        
        try? managedObjectContext.save()
    }
}
