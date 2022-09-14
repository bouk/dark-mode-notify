// The program will have the DARKMODE env flag set to 1 or 0
// Compile with:
// swift build
// And run the binary directly
// Most credit goes to https://github.com/mnewt/dotemacs/blob/master/bin/dark-mode-notifier.swift

import Cocoa

// Function to spawn a child process that can be used to update 
@discardableResult
func shell(_ args: [String]) -> Int32 {
    let task = Process()    // The new child process
    let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
    var env = ProcessInfo.processInfo.environment // Get the current processes environment variables
    env["DARKMODE"] = isDark ? "1" : "0"    // Append the DARKMODE environment variable to env
    task.environment = env  // Set the child processes enivronment variables to the current processes environment variables plus DARKMODE
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.standardError = FileHandle.standardError
    task.standardOutput = FileHandle.standardOutput
    task.launch()   // Spawn the child process with the new environment variables
    task.waitUntilExit()
    return task.terminationStatus
}

let args = Array(CommandLine.arguments.suffix(from: 1))
shell(args)

// Add an observer for dark mode or light mode being set
DistributedNotificationCenter.default.addObserver(
    forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil,
    queue: nil) { (notification) in
    shell(args)
}

// Add an observer to check whether dark/light mode has been updated since the device last went to sleep
NSWorkspace.shared.notificationCenter.addObserver(
    forName: NSWorkspace.didWakeNotification,
    object: nil,
    queue: nil) { (notification) in
    shell(args)
}

NSApplication.shared.run()
