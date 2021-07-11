import VVMIDI

class MidiListener {
    let manager = VVMIDIManager()
    var delegate: MidiDelegate?
    
    init() {
        manager.setDelegate(self)
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
        case 0x90:
            delegate?.midi(note: message.data1(), isOn: true)     // note on
        case 0x80:
            delegate?.midi(note: message.data1(), isOn: false)    // note off
        default:
            break
        }
    }
}


// MARK: -
protocol MidiDelegate {
    func midi(note: UInt8, isOn: Bool)
}
