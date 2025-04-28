import SwiftUI

struct GanttChartView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<100) { index in
                    ganttBar(for: index)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
    }

    private func ganttBar(for index: Int) -> some View {
        Rectangle()
            .fill(index % 2 == 0 ? Color.blue : Color.green)
            .frame(width: 50, height: 100)
            .overlay(Text("\(index)").foregroundColor(.white))
            .padding(5)
    }
}

struct GanttChartView_Previews: PreviewProvider {
    static var previews: some View {
        GanttChartView()
    }
}