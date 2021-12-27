import Foundation
import CoreMIDI
import AudioKit

protocol MIDIDelegate {
    func midi(note: UInt8, isOn: Bool)
}

class MIDIManager {
    // prevent app nap
    let listenActivity = ProcessInfo.processInfo.beginActivity(options: .userInitiatedAllowingIdleSystemSleep, reason: "Listening for MIDI.")
    
    let midi = MIDI()
    var delegate: MIDIDelegate?
    
    init() {
        midi.addListener(self)
        start()
    }
    
    private func start() {
        midi.openInput()
        midi.openOutput()
    }
    
    private func stop() {
        midi.closeAllInputs()
        midi.closeOutput()
    }
    
    func reset() {
        stop()
        start()
    }
    
    func keybowStart() {
        let event = MIDIEvent(data: [MIDISystemCommand.start.byte, 0])
        midi.sendEvent(event)
    }
    
    func keybowStop() {
        let event = MIDIEvent(data: [MIDISystemCommand.stop.byte, 0])
        midi.sendEvent(event)
    }
}


// MARK: - MIDIListener
extension MIDIManager: MIDIListener {
    func receivedMIDISetupChange() {
        print("Setup Changed")
    }
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) {
        delegate?.midi(note: noteNumber, isOn: true)
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) {
        delegate?.midi(note: noteNumber, isOn: false)
    }
}


// MARK: Empty conformances
extension MIDIManager {
    func receivedMIDIController(_ controller: MIDIByte, value: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) { }
    func receivedMIDIAftertouch(noteNumber: MIDINoteNumber, pressure: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) { }
    func receivedMIDIAftertouch(_ pressure: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) { }
    func receivedMIDIPitchWheel(_ pitchWheelValue: MIDIWord, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) { }
    func receivedMIDIProgramChange(_ program: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) { }
    func receivedMIDISystemCommand(_ data: [MIDIByte], portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) { }
    func receivedMIDIPropertyChange(propertyChangeInfo: MIDIObjectPropertyChangeNotification) { }
    func receivedMIDINotification(notification: MIDINotification) { }
}
