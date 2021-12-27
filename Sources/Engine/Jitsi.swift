import Quartz
import Carbon.HIToolbox
import Combine

class Jitsi: NSObject, ObservableObject {
    static var shared: Jitsi = Jitsi(bundleIdentifier: "org.jitsi.jitsi-meet")
    
    let bundleIdentifier: String
    @Published var processIdentifier: pid_t?
    @Published var lastMidi: UInt8?
    
    var cancellables = [AnyCancellable]()
    
    let midi = MIDIManager()
    
    let keymap: [UInt8: Command] = [
        36: OptionKeyCommand(key: kVK_ANSI_C),      // reaction - clap
        37: KeyCommand(key: kVK_ANSI_V),            // toggle video
        38: KeyCommand(key: kVK_ANSI_M),            // toggle mic
        39: MomentaryKeyCommand(key: kVK_Space),    // push to talk
        
        40: OptionKeyCommand(key: kVK_ANSI_L),      // reaction - laugh
        41: KeyCommand(key: kVK_ANSI_D),            // screen sharing
        42: KeyCommand(key: kVK_ANSI_F),            // toggle thumbnails
        43: KeyCommand(key: kVK_ANSI_W),            // tile view
        
        44: OptionKeyCommand(key: kVK_ANSI_T),      // reaction - thumbs up
        45: OptionKeyCommand(key: kVK_ANSI_O),      // reaction - surprised
        46: KeyCommand(key: kVK_ANSI_R),            // raise hand
        47: ShellCommand(command: ""),              // end call ???
        
        48: ShellCommand(command: ""),              // function 1
        49: ShellCommand(command: ""),              // function 2
        50: ShellCommand(command: ""),              // function 3
        51: ShellCommand(command: "")               // special
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
extension Jitsi: MIDIDelegate {
    func midi(note: UInt8, isOn: Bool) {
        DispatchQueue.main.async { if isOn { self.lastMidi = note } }
        
        guard
            let processIdentifier = processIdentifier,
            let command = keymap[note]
        else { return }
        
        command.run(keyDown: isOn, for: processIdentifier)
    }
}
