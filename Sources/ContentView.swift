import SwiftUI
import Carbon.HIToolbox

struct ContentView: View {
    @EnvironmentObject var jitsi: JitsiApp
    
    var body: some View {
        VStack {
            HStack {
                Text("Status:")
                Text(jitsi.processIdentifier != nil ? "Jitsi Electron Detected" : "Jitsi is not running")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
