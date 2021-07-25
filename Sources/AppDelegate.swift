import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // hide the dock icon
        NSApplication.shared.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
        
        // create the main view
        let contentView = ContentView()
        
        // create the window and set the content view
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView
                                            .environmentObject(Jitsi.shared))
        
        // creating the status bar item when declared crashes on macOS 11.5
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage(systemSymbolName: "pianokeys", accessibilityDescription: "Jitsi MIDI")
        statusItem.button?.action = #selector(showWindow)
    }
    
    @objc func showWindow() {
        window.makeKeyAndOrderFront(self)
        NSRunningApplication.current.activate(options: .activateIgnoringOtherApps)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

