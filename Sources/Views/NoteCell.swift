import SwiftUI

struct NoteModel {
    let color: Color
    let text: String
    let note: String
}

struct NoteCell: View {
    let note: NoteModel
    @State private var isPresentingPopover = false
    
    var body: some View {
        VStack {
            Text(note.text)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 90, height: 90)
        .overlay(Text(note.note).padding(5), alignment: .bottom)
        .background(note.color.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black.opacity(0.2))
        )
        .onTapGesture(perform: didTapCell)
        .popover(isPresented: $isPresentingPopover) {
            LinkEditor()
        }
    }
    
    func didTapCell() {
        guard note.text.hasSuffix("Open Link") else { return }
        LinkEditor.defaultsKey = note.text[note.text.startIndex...note.text.index(after: note.text.startIndex)].lowercased() + "URL"
        isPresentingPopover.toggle()
    }
}
