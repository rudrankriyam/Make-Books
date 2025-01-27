//  BooksView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

/// The list of all books
struct BooksView: View {
    /// Get the list of books
    @EnvironmentObject var books: Books
    @State var search: String = ""
    var body: some View {
        List(selection: $books.bookSelected) {
            ForEach(books.bookList.authors) { author in
                Section(header: Text(author.name)) {
                    ForEach(author.books.filter({search.isEmpty ? true : $0.search.localizedCaseInsensitiveContains(search)}), id: \.self) { book in
                        BookListRow(book: book)
                            .contextMenu {
                                BookButtons(book: book)
                            }
                    }
                }
            }
        }
        .searchable(text: $search, prompt: "Search for book or author")
    }
}

extension BooksView {

    /// A row in the book list
    struct BookListRow: View {
        let book: BookItem
        /// Get the list of books
        @EnvironmentObject var books: Books
        @State private var hovered = false
        /// The body of the View
        var body: some View {
            HStack {
                Group {
                    if let cover = book.cover {
                        Image(nsImage: getCover(cover: cover.path))
                            .resizable()
                    } else {
                        ZStack {
                            Image("CoverArt")
                                .resizable()
                            Text(book.title)
                                .font(.caption2)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .frame(width: 60.0, height: 90.0)
                .shadow(radius: 2, x: 2, y: 2)
                VStack(alignment: .leading) {
                    Text(book.title).fontWeight(.bold).lineLimit(2)
                    Text(book.author)
                    if !book.belongsToCollection.isEmpty {
                        Text("\(book.belongsToCollection) \(book.groupPositionRoman)")
                            .font(.caption)
                    }
                    Text("\(book.description) • " + book.date.prefix(4))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    if book.type == .collection {
                        /// List all the books in this collection
                        let filterbooks = books.bookList.authors.flatMap { $0.books }
                            .filter { $0.addToCollection.contains(where: { $0.name == book.collection })}
                        VStack(alignment: .leading) {
                            ForEach(filterbooks) { list in
                                Text(list.title)
                            }
                        }
                        .font(.caption2)
                    }
                }
            }
            .padding(.vertical, 2)
            .help(
                book.help
            )
        }
    }

    struct BookButtons: View {
        let book: BookItem
        /// Saved settings
        @AppStorage("pathExport") var pathExport: String = getDocumentsDirectory()
        var body: some View {
            Button {
                openInFinder(url: URL(fileURLWithPath: "\(pathExport)/\(book.author)/\(book.title)"))
            } label: {
                Text("Open export in Finder")
            }
            .disabled(!doesFileExists(url: URL(fileURLWithPath: "\(pathExport)/\(book.author)/\(book.title)")))
            Divider()
            Button {
                openInFinder(url: URL(fileURLWithPath: book.path))
            } label: {
                Text("Open source in Finder")
            }
            Button {
                openInTerminal(url: URL(fileURLWithPath: book.path))
            } label: {
                Text("Open source in Terminal")
            }
        }
    }
}
