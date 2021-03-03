//  ContentView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

//  MARK: - Views: Content View

/// The content of the whole application.
/// - Left is the book list
/// - Middle is the options and buttons view
/// - Right is the "Drop file" view

struct ContentView: View {
    /// Get the books with all options
    @EnvironmentObject var books: Books
    /// Observe script related stuff
    @EnvironmentObject var scripts: Scripts
    /// Saved settings
    @AppStorage("pathBooks") var pathBooks: String = GetDocumentsDirectory()
    @AppStorage("pathExport") var pathExport: String = GetDocumentsDirectory()
    /// The view
    var body: some View {
        NavigationView  {
            BooksView()
                .toolbar {
                    ToolbarItem() {
                        Button(action: {
                            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                        } ) {
                            Image(systemName: "sidebar.left").foregroundColor(.secondary)
                        }
                        .help("Hide or show the sidebar")
                    }
                }
            OptionsView()
                .toolbar {
                    HStack {
                        Button(action: {
                            SelectBooksFolder(books)
                        } ) {
                            Image(systemName: "square.and.arrow.up.on.square").foregroundColor(.secondary)
                        }
                        .help("The folder with your books: " + GetLastPath(pathBooks))
                        Button(action: {
                            SelectExportFolder()
                        } ) {
                            Image(systemName: "square.and.arrow.down.on.square").foregroundColor(.secondary)
                        }
                        .help("The export folder: " + GetLastPath(pathExport))
                        Divider()
                        Button(action: {
                            scripts.activeSheet = .dropper
                            scripts.showSheet = true
                        } ) {
                            Image(systemName: "square.and.pencil").foregroundColor(.secondary)
                        }
                        .help("Show Markdown dropper")
                    }
                }
        }
        .navigationSubtitle("Write a beautiful book")
        /// Open the sheet if showSheet = true
        .sheet(isPresented: $scripts.showSheet, content: sheetContent)
    }
}

extension ContentView {
    @ViewBuilder func sheetContent() -> some View {
        switch scripts.activeSheet {
        case .log:
            LogSheet()
        case .dropper:
            DropView()
        }
    }
}

