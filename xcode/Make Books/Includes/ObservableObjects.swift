//  ObservableOjects.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

// MARK: ObservableObject: Books

/// A list of all the books
/// Observable because of the optional selected book
class Books: ObservableObject {
    @Published var bookList = GetBooksList()
    @Published var bookSelected: BookItem?
}

// MARK: ObservableObject: MakeOptions

/// The options for Make
/// Observable because of the state of checkboxes
class MakeOptions: ObservableObject {
    @Published var options: [Make]
    init() {
        self.options = getMakeOptions()
    }
}

// MARK: ObservableObject: Scripts

/// State of scripts and application
class Scripts: ObservableObject {
    /// State of zsh scripts
    @Published var isRunning = false
    /// Log from zsh scripts
    @Published var log = [Log]()
    /// Show sheet with log or dropper
    @Published var showSheet = false
    @Published var activeSheet: ActiveSheet = .log
    /// The type of sheet we can show
    enum ActiveSheet {
        case log, dropper
    }
}
