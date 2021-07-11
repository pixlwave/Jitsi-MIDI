import Carbon
import Foundation
import IOKit
import IOKit.hid
import IOKit.usb

class KeybowHIDListener {
    let manager = IOHIDManagerCreate(kCFAllocatorDefault, 0)
    
    init() {
        guard CFGetTypeID(manager) == IOHIDManagerGetTypeID() else { fatalError() }
        
        let vendorId = 0x16d0
        //vendorId = 0x1234
        let productId = 0x08c6
        //productId = 0x5678
        let usagePage = kHIDPage_GenericDesktop
        let usage = kHIDUsage_GD_Keyboard
        
        let matchingDict = [
            kIOHIDVendorIDKey: vendorId,
            kIOHIDProductIDKey: productId,
            kIOHIDDeviceUsagePageKey: usagePage,
            kIOHIDDeviceUsageKey: usage
        ] as CFDictionary
        
        IOHIDManagerSetDeviceMatching(manager, matchingDict)
        
        IOHIDManagerRegisterDeviceMatchingCallback(manager, { (inContext: UnsafeMutableRawPointer?,
                                                               inResult: IOReturn,
                                                               inSender: UnsafeMutableRawPointer?,
                                                               inIOHIDDevice: IOHIDDevice) in
            NSLog("Connected")
        }, nil)
        
        
        IOHIDManagerRegisterDeviceRemovalCallback(manager, { (inContext: UnsafeMutableRawPointer?,
                                                              inResult: IOReturn,
                                                              inSender: UnsafeMutableRawPointer?,
                                                              inIOHIDDevice: IOHIDDevice) in
            NSLog("Removed")
        }, nil)
        
        IOHIDManagerRegisterInputValueCallback(manager, { (inContext: UnsafeMutableRawPointer?,
                                                           inReturn: IOReturn,
                                                           inSender: UnsafeMutableRawPointer?,
                                                           value: IOHIDValue) in
            let elem = IOHIDValueGetElement(value)

            let scancode = IOHIDElementGetUsage(elem)
            
            if scancode < 4 || scancode > 231 {
                return
            }
            
            NSLog("Key event received")
        }, nil)
        
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        
        IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
    }
}
