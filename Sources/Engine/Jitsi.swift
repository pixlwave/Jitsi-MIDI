import Quartz
import Carbon.HIToolbox
import Combine

class Jitsi: NSObject, ObservableObject {
    static var shared: Jitsi = Jitsi(bundleIdentifier: "org.jitsi.jitsi-meet")
    
    let bundleIdentifier: String
    @Published var processIdentifier: pid_t?
    @Published var lastMidi: UInt8?
    
    var cancellables = [AnyCancellable]()
    
    let midi = MidiListener()
    
    let keymap: [UInt8: CGKeyCode] = [
        36: CGKeyCode(kVK_Space),     // push to talk
        37: CGKeyCode(kVK_ANSI_A),    // call quality
        38: CGKeyCode(kVK_ANSI_T),    // speaker stats
        39: CGKeyCode(kVK_ANSI_S),    // full screen
        
        40: CGKeyCode(kVK_ANSI_3),    // focus on person 3
        41: CGKeyCode(kVK_ANSI_4),    // focus on person 4
        42: CGKeyCode(kVK_ANSI_5),    // focus on person 5
        43: CGKeyCode(kVK_ANSI_W),    // tile view
        
        44: CGKeyCode(kVK_ANSI_0),    // focus on me
        45: CGKeyCode(kVK_ANSI_1),    // focus on person 1
        46: CGKeyCode(kVK_ANSI_2),    // focus on person 2
        47: CGKeyCode(kVK_ANSI_F),    // video thumbnails
        
        48: CGKeyCode(kVK_ANSI_M),    // toggle mic
        49: CGKeyCode(kVK_ANSI_V),    // toggle video
        50: CGKeyCode(kVK_ANSI_D),    // screen sharing
        51: CGKeyCode(kVK_ANSI_R)     // raise hand
    ]
    
    var tickTimer: AnyCancellable?
    
    private init(bundleIdentifier: String) {
        self.bundleIdentifier = bundleIdentifier
        
        let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier).first
        processIdentifier = app?.processIdentifier
        
        super.init()
        
        midi.delegate = self
        
        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.didLaunchApplicationNotification)
            .sink(receiveValue: didLaunchApplication(notification:))
            .store(in: &cancellables)
        
        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.didTerminateApplicationNotification)
            .sink(receiveValue: didTerminateApplication(notification:))
            .store(in: &cancellables)
        
        tickTimer = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.processIdentifier != nil {
                    self.midi.keybowStart()
                }
            }
    }
    
    func didLaunchApplication(notification: Notification) {
        guard let app = application(from: notification) else { return }
        processIdentifier = app.processIdentifier
        
        // light up the keybow's leds
        midi.keybowStart()
    }
    
    func didTerminateApplication(notification: Notification) {
        guard let _ = application(from: notification) else { return }
        processIdentifier = nil
        
        // turn off the keybow's leds
        midi.keybowStop()
    }
    
    func application(from notification: Notification) -> NSRunningApplication? {
        guard
            let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            app.bundleIdentifier == bundleIdentifier
        else { return nil }
        
        return app
    }
}


// MARK: - MidiDelegate
extension Jitsi: MidiDelegate {
    func midi(note: UInt8, isOn: Bool) {
        DispatchQueue.main.async { if isOn { self.lastMidi = note } }
        
        guard
            let processIdentifier = processIdentifier,
            let keyCode = keymap[note],
            let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: isOn)
        else { return }
        
        event.postToPid(processIdentifier)
    }
}
