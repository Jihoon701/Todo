//
//  ToudlyWidget.swift
//  ToudlyWidget
//
//  Created by 김지훈 on 2023/03/30.
//

import WidgetKit
import SwiftUI
import RealmSwift

struct ColorManager {
    static let mainDarkGreen = Color("mainDarkGreen")
    static let pastelGreen = Color("pastelGreen")
    static let pearl = Color("pearl")
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
                    .background(Color("pastelGreen"))
                    .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 5))
                
                Divider()
                    .overlay(Color("pastelGreen"))
                
                VStack(alignment: .leading, spacing: 8) {
                    TodoListView(content: "보고서 제출하기 ")
                    TodoListView(content: "테니스 재등록하기")
                    TodoListView(content: "학교 과제 제출하기")
                    TodoListView(content: "프로젝트 기획서 제출하기")
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                
                Divider()
                    .overlay(Color("pastelGreen"))
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 8, trailing: 5))
        }
       
    }
}

struct TodoTitleView: View {
    var date: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Text("  \(date)  ")
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
            
            Image("circle", bundle: nil)
                .renderingMode(.original)
                .resizable()
                .frame(width: 5, height: 5)
            
            Text("\(content)")
                .foregroundColor(Color.black)
                .font(.custom("NanumSquareRoundOTFR", size: 12))
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
