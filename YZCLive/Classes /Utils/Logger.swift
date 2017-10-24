//
//  Logger.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/18.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import XCGLogger

public let log: XCGLogger = {
    let log = XCGLogger.default
    let currentdate = Date()
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "YYYY-MM-dd"
    let dateString = dateformatter.string(from: currentdate)
    let logPath: NSURL = cacheDirectory.appendingPathComponent("com.demo.live"+dateString+".log")! as NSURL
    
    #if DEBUG
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true)
        let fileDestination = FileDestination(writeToFile: logPath,
                                              identifier: "advancedLogger.fileDestination",
                                              shouldAppend: true,
                                              appendMarker: "-- Relauched App --")
        log.add(destination: fileDestination)
    #else
        log.setup(level: .severe, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        if let consoleLog = log.logDestination(XCGLogger.Constants.baseConsoleLogDestinationIdentifier) as? XCGConsoleLogDestination {
            consoleLog.logQueue = XCGLogger.logQueue
        }
    #endif
    
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " 🔹🔹🔹", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
    emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️‼️‼️", to: .error)
    emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " 💣💣💣", to: .severe)
    log.formatters = [emojiLogFormatter]
    return log
}()

public struct NetworkLog {
    static let ESCAPE = "\u{001b}["
    static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    static let RESET_BG = ESCAPE + "bg;" // Clear any background color
    static let RESET = ESCAPE + ";"   // Clear any foreground or background color
    
    typealias StatusCode = Int
    static func out(statusCode: StatusCode, target: (baseURL: NSURL, path: String, method: String, parameters: [String: AnyObject]?), json: AnyObject) {
        var codeColor = "fg255,0,0"
        if statusCode == 200 {
            codeColor = "fg0,255,0"
        }
        print("\(ESCAPE)\(codeColor);\(statusCode)\(RESET) \(ESCAPE)fg53,255,206;\(target.method)\(RESET) \(ESCAPE)fg69,69,69;\(target.baseURL)\(target.path) \(target.parameters ?? [:])\(RESET) \n\(ESCAPE)fg29,29,29;\(json)\(RESET)")
    }
}

private var documentsDirectory: NSURL {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.endIndex-1] as NSURL
}

private var cacheDirectory: NSURL {
    let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls[urls.endIndex-1] as NSURL
}
