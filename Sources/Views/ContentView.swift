import SwiftUI
import Carbon.HIToolbox

struct ContentView: View {
    @EnvironmentObject var jitsi: Jitsi
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text("Jitsi Electron:")
                    .font(.title.weight(.semibold))
                
                Text(jitsi.processIdentifier != nil ? "Running" : "Not Running")
                    .font(.title.smallCaps())
                
                Spacer()
            }
            .padding(.horizontal, 10)
            
            NotesGrid()
            
            HStack {
                HStack {
                    Text("Last MIDI Note:")
                    Text(jitsi.lastMidi != nil ? jitsi.lastMidi!.description : "None")
                }
                .foregroundColor(.secondary)
                
                
                Spacer()
                
                Button("Quit") {
                    NSRunningApplication.current.terminate()
                }
            }
            .padding(.horizontal, 5)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
