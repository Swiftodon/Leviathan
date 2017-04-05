//
//  XStreamReader.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 19.05.16.
//  Copyright © 2016 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

open class XStreamReader: Sequence  {

    let encoding : UInt
    let chunkSize : Int

    var fileHandle : FileHandle!
    let buffer : NSMutableData!
    let delimData : Data!
    var atEof : Bool = false

    public init?(path: String, delimiter: String = "\n", encoding : String.Encoding = String.Encoding.utf8, chunkSize : Int = 4096) {
        self.chunkSize = chunkSize
        self.encoding = encoding.rawValue

        if let fileHandle = FileHandle(forReadingAtPath: path),
            let delimData = delimiter.data(using: encoding),
            let buffer = NSMutableData(capacity: chunkSize)
        {
            self.fileHandle = fileHandle
            self.delimData = delimData
            self.buffer = buffer
        } else {
            self.fileHandle = nil
            self.delimData = nil
            self.buffer = nil
            return nil
        }
    }

    deinit {
        self.close()
    }

    /// Return next line, or nil on EOF.
    open func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")

        if atEof {
            return nil
        }

        // Read data chunks from file until a line delimiter is found:
        var range = buffer.range(of: delimData, options: [], in: NSMakeRange(0, buffer.length))
        while range.location == NSNotFound {
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count == 0 {
                // EOF or read error.
                atEof = true
                if buffer.length > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = NSString(data: buffer as Data, encoding: encoding)

                    buffer.length = 0
                    return line as String?
                }
                // No more lines.
                return nil
            }
            buffer.append(tmpData)
            range = buffer.range(of: delimData, options: [], in: NSMakeRange(0, buffer.length))
        }

        // Convert complete line (excluding the delimiter) to a string:
        let line = NSString(data: buffer.subdata(with: NSMakeRange(0, range.location)),
                            encoding: encoding)?.replacingOccurrences(of: "\r", with: "")
        // Remove line (and the delimiter) from the buffer:
        buffer.replaceBytes(in: NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)

        return line as String?
    }

    /// Start reading from the beginning of file.
    open func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.length = 0
        atEof = false
    }

    /// Close the underlying file. No reading must be done after calling this method.
    open func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }

    open func makeIterator() -> AnyIterator<String> {
        return AnyIterator {
            return self.nextLine()
        }
    }
}
