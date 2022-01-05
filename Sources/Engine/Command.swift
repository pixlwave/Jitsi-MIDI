import AppKit

protocol Command {
    func run(keyDown: Bool, for processIdentifier: pid_t)
}


struct KeyCommand: Command {
    let key: Int
    
    func run(keyDown: Bool, for processIdentifier: pid_t) {
        guard keyDown else { return }
        
        CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(key), keyDown: true)?.postToPid(processIdentifier)
        CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(key), keyDown: false)?.postToPid(processIdentifier)
    }
}


struct MomentaryKeyCommand: Command {
    let key: Int
    
    func run(keyDown: Bool, for processIdentifier: pid_t) {
        if keyDown {
            CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(key), keyDown: true)?.postToPid(processIdentifier)
        } else {
            CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(key), keyDown: false)?.postToPid(processIdentifier)
        }
    }
}


struct ModifiedKeyCommand: Command {
    let key: Int
    var modifierFlags: CGEventFlags = .maskAlternate
    
    func run(keyDown: Bool, for processIdentifier: pid_t) {
        guard keyDown else { return }
        
        let events = [
            CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(key), keyDown: true),
            CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(key), keyDown: false),
        ].compactMap { $0 }
        
        events.forEach {
            $0.flags.insert(modifierFlags)
            $0.postToPid(processIdentifier)
        }
    }
}


struct OpenURLCommand: Command {
    let defaultsKey: String
    
    func run(keyDown: Bool, for processIdentifier: pid_t) {
        guard
            keyDown,
            let url = UserDefaults.standard.url(forKey: defaultsKey)
        else { return }
        
        NSWorkspace.shared.open(url)
    }
}


struct OpenAppCommand: Command {
    let bundleID: String
    
    func run(keyDown: Bool, for processIdentifier: pid_t) {
        guard keyDown else { return }
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        task.arguments = ["-b", bundleID]
        try? task.run()
        task.waitUntilExit()
    }
}


struct ShellCommand: Command {
    let command: String
    
    func run(keyDown: Bool, for processIdentifier: pid_t) {
        guard keyDown else { return }
    }
}
