import SwiftUI

struct NotesGrid: View {
    let notes = [
        [
            NoteModel(color: .yellow, text: "Clap", note: "C1"),
            NoteModel(color: .green, text: "Toggle Video", note: "C♯1"),
            NoteModel(color: .orange, text: "Toggle Mic", note: "D1"),
            NoteModel(color: Color(.systemRed), text: "Push To Talk", note: "E♭1")
        ],
        
        [
            NoteModel(color: .yellow, text: "Laugh", note: "E1"),
            NoteModel(color: .blue, text: "Share Screen", note: "F1"),
            NoteModel(color: .pink, text: "Toggle Thumbnails", note: "F♯1"),
            NoteModel(color: .pink, text: "Toggle Tile View", note: "G1")
        ],
        
        [
            NoteModel(color: .yellow, text: "Thumbs Up", note: "A♭1"),
            NoteModel(color: .yellow, text: "Surprised", note: "A1"),
            NoteModel(color: .yellow, text: "Raise Hand", note: "B♭1"),
            NoteModel(color: .blue, text: "End Call", note: "B1")
        ],
        
        [
            NoteModel(color: Color(.systemTeal), text: "F1", note: "C2"),
            NoteModel(color: Color(.systemTeal), text: "F2", note: "C♯2"),
            NoteModel(color: Color(.systemTeal), text: "F3", note: "D2"),
            NoteModel(color: .white, text: "Special", note: "E♭2")
        ]
    ].reversed().reduce([], +)
    
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
