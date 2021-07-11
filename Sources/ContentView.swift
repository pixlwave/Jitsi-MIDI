import SwiftUI
import Carbon.HIToolbox

struct ContentView: View {
    @EnvironmentObject var jitsi: JitsiApp
    
    var body: some View {
        VStack {
            HStack {
                Text("Jitsi Electron:")
                Text(jitsi.processIdentifier != nil ? "Running" : "Not Running")
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
