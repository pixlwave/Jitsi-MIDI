import Foundation
import Carbon.HIToolbox

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


struct OptionKeyCommand: Command {
    let key: Int
    
    func run(keyDown: Bool, for processIdentifier: pid_t) {
        guard keyDown else { return }
        
        let events = [
            CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(key), keyDown: true),
            CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(key), keyDown: false),
        ].compactMap { $0 }
        
        events.forEach {
            $0.flags.insert(.maskAlternate)
            $0.postToPid(processIdentifier)
        }
    }
}

struct ShellCommand: Command {
    let command: String
    
    func run(keyDown: Bool, for processIdentifier: pid_t) {
        guard keyDown else { return }
    }
}
