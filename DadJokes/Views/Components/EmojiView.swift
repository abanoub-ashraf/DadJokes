import SwiftUI

///
/// - this view only ocntains the rating of each joke inside a Text
///
/// - the Text will be displayed based on the given rating in the initializer of this view
///
struct EmojiView: View {
    
    var rating: String
    
    init(for rating: String) {
        self.rating = rating
    }
    
    var body: some View {
        switch rating {
            case "Sob":
                return Text("😭")
            case "Sigh":
                return Text("😔")
            case "Smirk":
                return Text("😏")
            default:
                return Text("😐")
        }
    }
}

