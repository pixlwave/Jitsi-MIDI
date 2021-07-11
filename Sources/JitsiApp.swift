import Quartz
import Carbon.HIToolbox
import Combine

class JitsiApp: NSObject, ObservableObject {
    static var shared: JitsiApp = JitsiApp(bundleIdentifier: "org.jitsi.jitsi-meet")
    
    let bundleIdentifier: String
    @Published var processIdentifier: pid_t?
    
    var cancellables = [AnyCancellable]()
    
    let keybow = KeybowListener()
    
    let keymap = [
        Character(" "): CGKeyCode(kVK_Space),     // push to talk
        Character("3"): CGKeyCode(kVK_ANSI_3),    // focus on person 3
        Character("0"): CGKeyCode(kVK_ANSI_0),    // focus on me
        Character("m"): CGKeyCode(kVK_ANSI_M),    // toggle mic
        
        Character("a"): CGKeyCode(kVK_ANSI_A),    // call quality
        Character("4"): CGKeyCode(kVK_ANSI_4),    // focus on person 4
        Character("1"): CGKeyCode(kVK_ANSI_1),    // focus on person 1
        Character("v"): CGKeyCode(kVK_ANSI_V),    // toggle video
        
        Character("t"): CGKeyCode(kVK_ANSI_T),    // speaker stats
        Character("5"): CGKeyCode(kVK_ANSI_5),    // focus on person 5
        Character("2"): CGKeyCode(kVK_ANSI_2),    // focus on person 2
        Character("d"): CGKeyCode(kVK_ANSI_D),    // screen sharing
        
        Character("s"): CGKeyCode(kVK_ANSI_S),    // full screen
        Character("w"): CGKeyCode(kVK_ANSI_W),    // tile view
        Character("f"): CGKeyCode(kVK_ANSI_F),    // video thumbnails
        Character("r"): CGKeyCode(kVK_ANSI_R)     // raise hand
    ]
    
    private init(bundleIdentifier: String) {
        self.bundleIdentifier = bundleIdentifier
        
        let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier).first
        processIdentifier = app?.processIdentifier
        
        super.init()
        
        keybow.delegate = self
        keybow.start()
        
        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.didLaunchApplicationNotification)
            .sink(receiveValue: didLaunchApplication(notification:))
            .store(in: &cancellables)
        
        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.didTerminateApplicationNotification)
            .sink(receiveValue: didTerminateApplication(notification:))
            .store(in: &cancellables)
    }
    
    func didLaunchApplication(notification: Notification) {
        guard let app = application(from: notification) else { return }
        processIdentifier = app.processIdentifier
    }
    
    func didTerminateApplication(notification: Notification) {
        guard let _ = application(from: notification) else { return }
        processIdentifier = nil
    }
    
    func application(from notification: Notification) -> NSRunningApplication? {
        guard
            let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            app.bundleIdentifier == bundleIdentifier
        else { return nil }
        
        return app
    }
}


extension JitsiApp: KeybowDelegate {
    func send(key: Character, keyDown: Bool) {
        guard
            let processIdentifier = processIdentifier,
            let keyCode = keymap[key],
            let source = CGEventSource(stateID: CGEventSourceStateID.privateState),
            let event = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: keyDown)
        else { return }
        
        event.postToPid(processIdentifier)
    }
}
