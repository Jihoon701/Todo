//
//  ToudlyWidget.swift
//  ToudlyWidget
//
//  Created by 김지훈 on 2023/03/30.
//

import WidgetKit
import SwiftUI

struct ColorManager {
    static let mainDarkGreen = Color("mainDarkGreen")
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ToudlyWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {

            Color(.white)
            
            VStack(alignment: .leading, spacing: 5) {
                TodoTitleView(date: "March 30")
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    TodoListView(content: "가나다라 루이 산책시키기 일주일 동안 2시간 이상 산책시키기")
                    TodoListView(content: "라마바")
                    TodoListView(content: "사아자차")
                    TodoListView(content: "카타파하")
                    TodoListView(content: "Hello")
                    
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
            }
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 5))
        }
    }
}

struct TodoTitleView: View {
    var date: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Text("March 30")
                .foregroundColor(Color("mainDarkGreen"))
                .font(.custom("NanumSquareRoundOTFB", size: 19))
                .multilineTextAlignment(.leading)
                .lineLimit(1)
        }
    }
}

struct TodoListView: View {
    var content: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 7) {
            
            Image("colorCircle", bundle: nil)
                .resizable()
                .frame(width: 5, height: 5)
            
            Text("\(content)")
                .foregroundColor(Color.black)
                .font(.custom("NanumSquareRoundOTFEB", size: 12))
                .lineLimit(1)
        }
    }
}

struct ToudlyWidget: Widget {
    let kind: String = "ToudlyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ToudlyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("투들리")
        .description("간편하게 투들리 일정을 확인하세요.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct ToudlyWidget_Previews: PreviewProvider {
    static var previews: some View {
        ToudlyWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
