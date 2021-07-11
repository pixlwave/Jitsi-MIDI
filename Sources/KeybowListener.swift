import ORSSerial

class KeybowListener: NSObject, ORSSerialPortDelegate {
    let port = ORSSerialPort(path: "/dev/tty.usbmodem14301")
    
    let keyDownDescriptor = ORSSerialPacketDescriptor(prefixString: "!1", suffixString: ";", maximumPacketLength: 4, userInfo: nil)
    let keyUpDescriptor = ORSSerialPacketDescriptor(prefixString: "!0", suffixString: ";", maximumPacketLength: 4, userInfo: nil)
    
    var delegate: KeybowDelegate?
    
    override init() {
        super.init()
        
        port?.delegate = self
        port?.startListeningForPackets(matching: keyDownDescriptor)
        port?.startListeningForPackets(matching: keyUpDescriptor)
    }
    
    func start() {
        port?.open()
    }
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        //
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        print("Open")
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor) {
        guard let string = String(data: packetData, encoding: .ascii) else { return }
        let keyCodeIndex = string.index(string.startIndex, offsetBy: 2)
        let keyCode = string[keyCodeIndex]
        
        switch descriptor {
        case keyDownDescriptor:
            delegate?.send(key: keyCode, keyDown: true)
        case keyUpDescriptor:
            delegate?.send(key: keyCode, keyDown: false)
        default:
            break
        }
    }
}

protocol KeybowDelegate {
    func send(key: Character, keyDown: Bool)
}
