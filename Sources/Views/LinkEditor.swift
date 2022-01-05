import SwiftUI

struct LinkEditor: View {
    private static let jitsiScheme = "jitsi-meet://"
    static var defaultsKey = ""
    
    @AppStorage(Self.defaultsKey) private var link: URL?
    
    @State private var urlString = Self.jitsiScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter URL")
                .font(.headline)
            TextField(Self.jitsiScheme, text: $urlString, onCommit: setURL)
                .frame(minWidth: 200)
        }
        .padding()
        .onAppear {
            urlString = link?.absoluteString ?? Self.jitsiScheme
        }
    }
    
    func setURL() {
        link = URL(string: urlString)
    }
}
