//
//  FileHandler.swift
//  city-search
//
//  Created by James Langdon on 10/31/18.
//  Copyright © 2018 corporatelangdon. All rights reserved.
//

import Foundation

class FileLoader {
    private struct DataFile {
        static var Cities = path(for: "cities", fileExtension: "json")
        
        static func path(for fileName: String, fileExtension: String) -> String {
            let bundle = Bundle.main
            return bundle.path(forResource: fileName, ofType: fileExtension)!
        }
    }
    
    public static func load() -> Data? {
        return read(from: DataFile.Cities)
    }
   
    private static func fileExists(at path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    
    private static func read(from path: String) -> Data? {
        let url = URL(fileURLWithPath: path)
        guard fileExists(at: path) else {
            print("File at \(path) does not exist")
            return nil
        }
        do {
            print("Read from file \(url.lastPathComponent)")
            return try Data(contentsOf: url)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return nil
        }
    }
    
}
