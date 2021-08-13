import SwiftUI

struct AddView: View {
    ///
    /// - get the context from the environment from inside the content view
    ///   and save it in this moc variable
    ///
    @Environment(\.managedObjectContext) var managedObjectContext
    ///
    /// prsentationMode is a binding to the current presentation mode of the view
    /// associated with this environment
    ///
    @Environment(\.presentationMode) var presentationMode
    ///
    /// - @State let us modify properties inside structs
    ///   normally that's not allowed
    ///
    /// - @State keeps the values in memory after SwiftUI destroy the struct
    ///
    @State private var setup = ""
    @State private var punchline = ""
    @State private var rating = "Silence"
    
    var ratings = ["Sob", "Sigh", "Silence", "Smirk"]
    
    var body: some View {
        NavigationView {
            ///
            /// Form has a better ui than List
            ///
            Form {
                Section {
                    ///
                    /// - the strings are the placeholders for those textfields
                    ///
                    /// - whatever is written in these will be saved in the state variables above
                    ///
                    TextField("Setup", text: $setup)
                    TextField("Punchline", text: $punchline)
                    
                    ///
                    /// - this picker will display the items of the ratings array
                    ///
                    /// - when the user select one of them it will be saved in the rating variable
                    ///
                    Picker("Rating", selection: $rating) {
                        ForEach(ratings, id: \.self) { rating in
                            Text(rating)
                        }
                    }
                }
                
                ///
                /// creates a new joke and save it in coredata
                ///
                Button("Add A New Joke") {
                    ///
                    /// don't add a new joke if any of these fields is empty
                    ///
                    if self.setup == "" || self.punchline == "" || self.rating == "" {
                        return
                    }
                    
                    let newJoke = Joke(context: self.managedObjectContext)
                    newJoke.setup     = self.setup
                    newJoke.punchline = self.punchline
                    newJoke.rating    = self.rating
                    
                    do {
                        try self.managedObjectContext.save()
                        ///
                        /// to dismiss this current presented view on the screen after we save the new joke
                        ///
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Whoops! \(error.localizedDescription)")
                    }
                }
            }
            .navigationBarTitle("Add New Joke")
        }
    }
}
