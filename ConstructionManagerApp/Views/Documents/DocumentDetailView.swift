import SwiftUI

struct DocumentDetailView: View {
    var document: Document

    var body: some View {
        VStack(alignment: .leading, spacing: DS.m) {
            Text(document.name)
                .font(DS.title)
                .fontWeight(.bold)
            if let desc = document.documentDescription {
                Text(desc)
                    .font(DS.body)
                    .foregroundColor(DS.dim(0.6))
            }
            if let updated = document.updatedAt {
                Text("Updated: \(updated.formatted())")
                    .font(DS.caption)
                    .foregroundColor(DS.dim(0.7))
            }
            Spacer()
        }
        .padding(DS.l)
        .background(Color.appCard)
        .cornerRadius(DS.cornerRadius)
        .padding(DS.m)
        .navigationTitle("Document")
    }
}
