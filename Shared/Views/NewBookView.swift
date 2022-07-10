//
//  NewBookView.swift
//  README
//
//  Created by Shreya Prasad on 06/07/22.
//

import SwiftUI

struct NewBookView: View {
     @ObservedObject var book = Book(title: "", author: "")
    @State  var image  : Image? = nil
   @EnvironmentObject var library : Library
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
        VStack(spacing : 24){
            TextField("Title", text: $book.title)
            TextField("Author", text: $book.author)
            ReviewAndImageStack(book: book, image: $image)
        }
        .padding()
        .navigationTitle("Got a new book ?")
        .toolbar {
            ToolbarItem(placement: .status){
                Button("Add to library"){
                    library.addNewBook(book, image: image)
                    dismiss()
                    
                }
                .disabled([book.title, book.author]
                    .contains(where: \.isEmpty)
                )
            }
        }
    }
}
                        }
struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView().environmentObject(Library())
    }
}
