import Foundation

// MARK: - Component Protocol

protocol File {
    var name: String { get set }
    func open()
}


// MARK: - Leaf Classes

final class eBook: File {
    var name: String
    var author: String
    
    init(name: String, author: String) {
        self.name = name
        self.author = author
    }
    
    func open() {
        print("Opening \(name) by \(author) in iBooks...\n")
    }
}

final class Music: File {
    var name: String
    var artist: String
    
    init(name: String, artist: String) {
        self.name = name
        self.artist = artist
    }
    
    func open() {
        print("Playing \(name) from \(artist) in iTunes...\n")
    }
}


// MARK: - Composite Class

final class Folder: File {
    var name: String
    lazy var files: [File] = []
    
    init(name: String) {
        self.name = name
    }
    
    func addFile(file: File) {
        self.files.append(file)
    }
    
    func open() {
        print("Displaying the following files in \(name)...")
        for file in files {
            print(file.name)
        }
        print("\n")
    }
}


// MARK: - Example

let psychoKiller = Music(name: "Psycho Killer",
                         artist: "The Talking Heads")

let rebelRebel = Music(name: "Rebel Rebel",
                       artist: "David Bowie")

let blisterInTheSun = Music(name: "Blister in the Sun",
                            artist: "Violent Femmes")

let justKids = eBook(name: "Just Kids",
                     author: "Patti Smith")

let documents = Folder(name: "Documents")
let musicFolder = Folder(name: "Great 70s Music")

documents.addFile(file: musicFolder)
documents.addFile(file: justKids)

musicFolder.addFile(file: psychoKiller)
musicFolder.addFile(file: rebelRebel)

blisterInTheSun.open()
justKids.open()

documents.open()
musicFolder.open()

