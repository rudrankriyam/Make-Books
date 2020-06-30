//  SharedFunctions.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Fuctions

// GetBooks()
// ----------
// Gets the list of all books.
// The directory is set in the preferences

func GetBooks() -> [MetaBooks] {
    /// The path of the books from UserDefault
    let base = UserDefaultsConfig.pathBooks
    /// Prepair the vars
    var meta = [String: String]()
    
    // Below not needed??
    //var books = [[String: String]]()
    /// Convert path to an url
    let directoryURL = URL(fileURLWithPath: base)
    
    // TODO: Why do I need [] here?
    var metaBooks = [MetaBooks]()
    
    /// Get a list of all files
    if let enumerator = FileManager.default.enumerator(atPath: directoryURL.path) {
        for case let path as String in enumerator {
            if path.hasSuffix("/make-book.md") || path.hasSuffix("/make-collection.md") {
                meta = GetMeta(base + "/" + path)
                var bookURL = URL(fileURLWithPath: (base + "/" + path))
                bookURL.deleteLastPathComponent()
                bookURL.appendPathComponent("cover-screen.jpg")
                meta["cover"] = bookURL.path
                bookURL.deleteLastPathComponent()
                bookURL.deleteLastPathComponent()
                meta["path"] = bookURL.path
                
                if path.hasSuffix("/make-book.md") {
                    meta["type"] = "Book"
                    meta["script"] = "make-book"
                }
                if path.hasSuffix("/make-collection.md") {
                    meta["type"] = "Collection"
                    meta["script"] = "make-collection"
                }
                //books.append(meta)
                metaBooks.append(MetaBooks(
                    title: meta["title"]!,
                    author: meta["author"]!,
                    cover: meta["cover"]!,
                    path: meta["path"]!,
                    type: meta["type"]!,
                    script: meta["script"]!
                ))
            }
        }
    }
    /// Sort by author name
    metaBooks.sort(by: { $0.author < $1.author })
    return metaBooks
}

struct MetaBooks: Hashable {
    var id = UUID()
    var title: String = ""
    var author: String = ""
    var cover: String = ""
    var path: String = ""
    var type: String = ""
    var script: String = ""
}

// GetMeta(path)
// -------------
// Gets the full path to the metadata file
// Read the metadata from the file
// Return an dictionary

func GetMeta(_ path: String) -> [String: String] {
    var meta = [String: String]()
    errno = 0
    if freopen((path), "r", stdin) == nil {
        perror((path))
    }
    while let line = readLine() {
        let result = line.range(of: "[a-z]", options:.regularExpression)
        if (result != nil) {
            let lineArr = line.components(separatedBy: ": ")
            meta[lineArr[0]] = lineArr[1]
        }
    }
    return meta
}

// GetCover(path)
// --------------
// Gets path to cover
// Returns the cover image
// Defaults to a cover in the Assets bundle

func GetCover(cover: String) -> NSImage {
    //let book = bookURL
    if FileManager.default.fileExists(atPath: cover) {
        let url = URL(fileURLWithPath: cover)
        let imageData = try! Data(contentsOf: url)
        return NSImage(data: imageData)!
    } else {
        return NSImage(named: "CoverArt")!
    }
}

// GetLastPath(path)
// -----------------
// Gets the full path to the folder
// Returns the last path

func GetLastPath(_ path: String) -> String {
    let lastPath = (URL(fileURLWithPath: path).lastPathComponent)
    return lastPath
}

// GetFolderIcon(path)
// -------------------
// Gets the full path to the folder
// Returns an image

func GetFolderIcon(_ path: String) -> NSImage {
    let fileIcon = NSWorkspace.shared.icon(forFile: path)
    return fileIcon
}

// GetArgs(path)
// -------------------
// Gets the full book object
// Returns a string with arguments

func GetArgs(_ books: Books) -> String {
    var makeArgs = ""
    makeArgs += "--paper " + books.optionsPaper[UserDefaultsConfig.paperSize].system + " "
    makeArgs += "--font " + books.optionsFont[UserDefaultsConfig.fontSize].system + " "
    makeArgs += "--books \"" + UserDefaultsConfig.pathBooks + "\" "
    makeArgs += "--export \"" + UserDefaultsConfig.pathExport + "\" "
    for option in books.optionsMake {
        if option.isSelected == true {
            makeArgs += " " + option.make + " "
        }
    }
    return (makeArgs)
}
