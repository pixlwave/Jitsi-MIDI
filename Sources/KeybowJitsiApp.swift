import SwiftUI

@main
struct JitsiKeybowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(JitsiApp.shared)
        }
    }
}
