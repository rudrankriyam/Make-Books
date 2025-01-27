//  OptionsView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

// MARK: - View: OptionsView

/// The types of book to make
struct OptionsView: View {
    /// Get the list of books
    @EnvironmentObject var books: Books
    /// Get the Make options
    @StateObject var makeOptions = MakeOptions()
    /// The export path
    @AppStorage("pathExport") var pathExport: String = getDocumentsDirectory()
    /// The body of the View
    var body: some View {
        VStack {
            /// In a ZStack because it has a background
            ZStack {
                Group {
                    if let selection = books.bookSelected, let cover = selection.cover {
                        Image(nsImage: getCover(cover: cover.path))
                            .resizable()
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Image("MainBackground")
                        /// Resizable needed or else it does not risize
                            .resizable()
                    }
                }
                .scaledToFit()
                .opacity(0.1)
                VStack {
                    Text("Make your book").font(.largeTitle)
                    /// Another VStack to align the content to the left
                    VStack(alignment: .leading) {
                        /// Start the ForEach at 1, because 0 is the "clean" option at the botom
                        ForEach(1 ..< makeOptions.options.count, id: \.self) { index in
                            Toggle(isOn: $makeOptions.options[index].isSelected) {
                                Text(makeOptions.options[index].label)
                                    .fontWeight(.bold)
                            }
                            Text(makeOptions.options[index].text)
                                .foregroundColor(.secondary)
                                .padding(.leading)
                        }
                    }.padding(.horizontal)
                }
                /// No more ZStack
            }
            /// And at last, the 'clean' option
            Toggle(isOn: $makeOptions.options[0].isSelected) {
                Text(makeOptions.options[0].label)
            }
            .help(makeOptions.options[0].text)
            /// Warn if you really want to clean
            Text(makeOptions.options[0].isSelected ? makeOptions.options[0].text : " ")
                .font(.caption)
                .foregroundColor(.secondary)
                .animation(.easeInOut)
                .padding(.bottom)
            /// END `options for Make`
            /// Add the buttons below this view
            MakeView(makeOptions: makeOptions)
        }
        .animation(.default, value: books.bookSelected)
    }
}
