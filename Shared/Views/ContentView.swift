//
//  ContentView.swift
//  Shared
//
//  Created by Shreya Prasad on 30/06/22.
//
import SwiftUI

struct ContentView: View {
  @State var addingNewBook = false
  @EnvironmentObject var library: Library
  
  var body: some View {
    NavigationView {
      List {
        Button {
          addingNewBook = true
        } label: {
          Spacer()
          VStack(spacing: 6) {
            Image(systemName: "book.circle")
              .font(.system(size: 60))
            Text("Add New Book")
              .font(.title2)
          }
          Spacer()
        }
        .buttonStyle(.borderless)
        .padding(.vertical, 8)
        .sheet(isPresented: $addingNewBook, content: NewBookView.init)
          ForEach(Section.allCases, id: \.self) {
              SectinView(section: $0)
          }
      }
        
      .toolbar(content:EditButton.init )
      .navigationTitle("My Library")
    }
  }
}

 private struct BookRow: View {
  @ObservedObject var book: Book
  @EnvironmentObject var library: Library
  
  var body: some View {
    NavigationLink(destination: DetailView(book: book)) {
      HStack {
        Book.Image(image: library.images[book], title: book.title, size: 80, cornerRadius: 12)
        VStack(alignment: .leading) {
          TitleAndAuthorStack(book: book, titleFont: .title2, authorFont: .title3)
          
          if !book.microReview.isEmpty {
            Spacer()
            Text(book.microReview)
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
        }
        .lineLimit(1)
      }
      .padding(.vertical, 8)
    }
  }
}
 private struct SectinView : View {
     let section : Section
     @EnvironmentObject var library : Library
     var title : String{
         switch section {
             
         case .readMe:
             return " Read me!"
         case .finished:
             return " Finished!"
         }
     }
    var body: some View{
        if let  books = library.sortedBooks[section]
        {
            SwiftUI.Section {
                ForEach(books){ book in
                    BookRow(book: book)
                        .swipeActions(edge: .leading ){
                           
                            Button {
                                withAnimation{
                                book.readMe.toggle()
                                library.sortBooks()
                                }
                            } label: {
                                book.readMe
                                ?
                                Label("Finished", systemImage: "bookmark.slash")
                                :
                                Label("ReadMe !", systemImage: "bookmark")
                            }
                            .tint(.accentColor)

                        }
                        .swipeActions(edge: .trailing ){
                            Button(role: .destructive){
                                guard let index =  books.firstIndex(where: { $0.id == book.id
                                    
                                })
                                else {
                                    return
                                }
                                withAnimation{
                                library.deleteNewBooks(atOffsets: .init(integer: index), section: section)
                                
                                
                            }
                                
                            } label: {
                                Label("Delete", systemImage:" trash")
                            }
                            
                        }
                    
                    
                }
                .onDelete { indexSet in
                    library.deleteNewBooks(atOffsets: indexSet, section: section)
                }
                .onMove { indexes, newOffset in
                    library.moveBooks(oldOffsets: indexes, newOffset: newOffset, section: section)
                }
                .labelStyle(.iconOnly)
            } header: {
                ZStack {
                    Image("Image")
                        .resizable()
                    .scaledToFit()
                    Text(title)
                        .font(.custom("Armenian Typewriter", size: 24))
                        .foregroundColor(.primary)
                    
                }
            
                    .listRowInsets(.init())
                   
            }

            
    }
}
 }
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(Library())
      .previewedInAllColorSchemes
  }
}