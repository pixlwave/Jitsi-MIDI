import VVMIDI

// MARK: -
extension VVMIDIMsgType {
    var type: UInt8 {
        UInt8(self.rawValue)
    }
}
