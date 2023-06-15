#!/usr/bin/env swift

import Cocoa

func copyToClipboard(_ path: String) -> Bool {
    var image: NSImage?
    if path == "-" {
        let input = FileHandle.standardInput
        image = NSImage(data: input.readDataToEndOfFile())
    } else {
        image = NSImage(contentsOfFile: path)
    }
    var copied = false
    if image != nil {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        let copiedObjects = [image!]
        copied = pasteboard.writeObjects(copiedObjects)
    }
    return copied
}

let args = CommandLine.arguments
if args.count < 2 {
    let usageDesc = """
    Usage:

    Copy file to clipboard:
        img_copy path/to/file

    Copy stdin to clipboard:
        cat /path/to/file | ./img_copy -
    """
    print(usageDesc)
    exit(EXIT_FAILURE)
}

let path = args[1]
let success = copyToClipboard(path)

exit(success ? EXIT_SUCCESS : EXIT_FAILURE)
