import AppKit
import Combine

struct ControllableApp {
    let bundleIdentifier: String
    var processIdentifier: pid_t?
    
    mutating func refreshProcessIdentifier() {
        let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier).first
        processIdentifier = app?.processIdentifier
    }
}
