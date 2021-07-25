import VVMIDI

class MidiListener {
    // prevent app nap
    let listenActivity = ProcessInfo.processInfo.beginActivity(options: .userInitiatedAllowingIdleSystemSleep, reason: "Listening for MIDI.")
    
    let manager = VVMIDIManager()
    var delegate: MidiDelegate?
    
    init() {
        manager.setDelegate(self)
    }
    
    func keybowStart() {
        let message = VVMIDIMessage(type: VVMIDIStartVal.type, channel: 0)
        manager.sendMsg(message)
    }
    
    func keybowStop() {
        let message = VVMIDIMessage(type: VVMIDIStopVal.type, channel: 0)
        manager.sendMsg(message)
    }
}


// MARK: - VVMIDIDelegateProtocol
extension MidiListener: VVMIDIDelegateProtocol {
    func setupChanged() {
        print("Setup Changed")
    }
    
    func receivedMIDI(_ messages: [Any]!, from n: VVMIDINode!) {
        guard let messages = messages as? [VVMIDIMessage] else { return }
        messages.forEach(process)
    }
    
    func process(_ message: VVMIDIMessage) {
        switch message.type() {
        case VVMIDINoteOnVal.type:
            delegate?.midi(note: message.data1(), isOn: true)
        case VVMIDINoteOffVal.type:
            delegate?.midi(note: message.data1(), isOn: false)
        default:
            break
        }
    }
}


// MARK: -
protocol MidiDelegate {
    func midi(note: UInt8, isOn: Bool)
}
