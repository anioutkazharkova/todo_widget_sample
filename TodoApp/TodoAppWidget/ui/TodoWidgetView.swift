//
//  TodoWidgetView.swift
//  TodoAppOtus_6_03_24
//
//  Created by Anna Zharkova on 07.03.2024.
//

import SwiftUI
import WidgetKit

struct TodoAppWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, content: {
                Text("Notes").foregroundStyle(.white)
                Spacer()
                Text("\(entry.uncompleted)/\(entry.total)").foregroundStyle(.white).onTapGesture {
                    WidgetCenter.shared.reloadAllTimelines()
                }
               /* Button(intent: RefreshIntent()) {
                    Text("Refresh")
                }*/

            }).frame(height: 40)
            ForEach(entry.data.indices) { index in
                Button(intent: CheckTodoIntent(index: index)) {
                    Label(entry.data[index].taskName , systemImage: "circle\(entry.data[index].isCompleted ? ".fill" : "")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
               
            }
            Spacer()
            HStack(alignment: .bottom, content: {
                Text("Add task +").foregroundColor(.gray)
            }).frame(height: 40)
        }
    }
}
