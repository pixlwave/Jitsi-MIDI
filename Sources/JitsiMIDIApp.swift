import SwiftUI

@main
struct JitsiMIDIApp: App {
    @NSApplicationDelegateAdaptor var delegate: AppDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
