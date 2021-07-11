import SwiftUI

struct NotesGrid: View {
    let notes = [
        NoteModel(color: .green, text: "Toggle Mic", note: "C3"),
        NoteModel(color: .red, text: "Toggle Camera", note: "C♯3"),
        NoteModel(color: .blue, text: "Share Screen", note: "D3"),
        NoteModel(color: .white, text: "Raise Hand", note: "E♭3"),
        
        NoteModel(color: .pink, text: "Focus Me", note: "A♭2"),
        NoteModel(color: .pink, text: "Focus #1", note: "A2"),
        NoteModel(color: .pink, text: "Focus #2", note: "B♭2"),
        NoteModel(color: .yellow, text: "Toggle Thumbnails", note: "B2"),
        
        NoteModel(color: .pink, text: "Focus #3", note: "E2"),
        NoteModel(color: .pink, text: "Focus #4", note: "F2"),
        NoteModel(color: .pink, text: "Focus #5", note: "F♯2"),
        NoteModel(color: .yellow, text: "Toggle Tile View", note: "G2"),
        
        NoteModel(color: .orange, text: "Push To Talk", note: "C2"),
        NoteModel(color: Color(.systemTeal), text: "Call Quality", note: "C♯2"),
        NoteModel(color: Color(.systemTeal), text: "Speaker Stats", note: "D2"),
        NoteModel(color: .blue, text: "Full Screen", note: "E♭2")
    ]
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(0..<4) { row in
                HStack(spacing: 5) {
                    let startIndex = row * 4
                    ForEach(startIndex..<(startIndex + 4)) { column in
                        NoteCell(note: notes[column])
                    }
                }
            }
        }
        .padding(5)
    }
}

struct NoteCell: View {
    let note: NoteModel
    
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
    }
}

struct NoteModel {
    let color: Color
    let text: String
    let note: String
}

struct NotesGrid_Previews: PreviewProvider {
    static var previews: some View {
        NotesGrid()
    }
}