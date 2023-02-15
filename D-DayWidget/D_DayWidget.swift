//
//  D-DayWidget.swift
//  D-DayWidget
//
//  Created by hana on 2023/02/09.
//

import WidgetKit
import SwiftUI
import Intents
import RealmSwift

//isPreview - 위젯갤러리에 표시하기위한 미리보기 스냅샷 표시 // : TimelineProvider
struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    
//    typealias Intent = WidgetItemIntent
    
    //본격적으로 위젯에 표시될
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "제목입니다.", dday: "D-Day", image: UIImage())
    }

    //데이터를 가져와서 표출해주는.  스냅샷 샘플데이터 설정
    //ConfigurationIntent: D_DayWidget.intentdefinition - CustomIntent 이름
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        getItem { item in
            let entry = SimpleEntry(
                date: Date(),
                title: item.title,
                dday: NumberOfDaysFromDate(from: item.date),
                image: (Repository().loadImageFromDocumentDirectory(imageName: item.id.stringValue) ?? UIImage(systemName: "house"))!
            )
            completion(entry)
          }
    }

    //타임라인 설정 관련된. 언제 리로드할지
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getItem { item in
            let currentDate = Date()
            let entry = SimpleEntry(
                date: Date(),
                title: item.title,
                dday: NumberOfDaysFromDate(from: item.date),
                image: (Repository().loadImageFromDocumentDirectory(imageName: item.id.stringValue) ?? UIImage(systemName: "house"))!
            )
            
          let nextRefresh = Calendar.current.date(byAdding: .minute, value: 3, to: currentDate)! //언제 리로드할지
          let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
          completion(timeline)
        }
    }
    
    func getItem(completion: @escaping(Item) -> ()){
        let items = Repository().read()
        
        completion((items?.first)!)
    }
    
    func NumberOfDaysFromDate(from: Date, to: Date = Date.now) -> String{
        let calendar = NSCalendar.current
        let numberOfDays = calendar.dateComponents([.day], from: from, to: to)
        
        if numberOfDays.day! > 0{
            return "D+\(numberOfDays.day!)"
        }
        else if numberOfDays.day! < 0{
            return "D\(numberOfDays.day!)"
        }
        else{
            return "D-Day"
        }
    }
}

//위젯 콘텐츠를 업데이트한 date정보 + 표시하고자하는 정보 : TimelineEntry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let dday: String
    let image: UIImage
}

//SwiftUI로 콘텐츠 정의 :View
struct D_DayWidgetEntryView : View {
    //WidgetFamily - 위젯의 크기를 구분해서 정의
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        switch self.family {
        case .systemSmall:
            ZStack{
                Image(uiImage: entry.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                VStack{
                    Text(entry.title)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.green)
                    Spacer().frame(height: 5)
                    Text(entry.dday)
                        .font(.title)
//                        .fontDesign(.rounded)
                }
            }
            
        case .systemMedium:
            HStack{
                Text(entry.title)
                    .font(.caption)
                    .padding(10)
                Spacer()
                Text(entry.dday)
                    .font(.title)
//                    .fontDesign(.rounded)
                    .padding(10)
            }
        case .systemLarge:
            VStack{
                Text(entry.title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Spacer().frame(height: 20)
                Text(entry.dday)
                    .font(.title)
//                    .fontDesign(.rounded)
            }
        case .systemExtraLarge: // ExtraLarge는 iPad의 위젯에만 표출
            VStack{
                Text(entry.title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Spacer().frame(height: 20)
                Text(entry.dday)
                    .font(.title)
//                    .fontDesign(.rounded)
            }
        case .accessoryCircular:
            VStack{
//                Text(entry.title[...entry.title.index(entry.title.startIndex, offsetBy:3)])
//                    .font(.caption)
//                    .multilineTextAlignment(.center)
                Text(entry.dday)
                    .font(.callout)
//                    .fontDesign(.rounded)
            }
        case .accessoryInline:
            Text("\(entry.title)  \(entry.dday)")
                .font(.caption)
        case .accessoryRectangular:
            HStack{
                Text(entry.title)
                    .font(.caption)
                Text(entry.dday)
                    .font(.callout)
//                    .fontDesign(.rounded)
            }
        @unknown default:
            Text("default")
        }
    }
}

//@main
struct D_DayWidget: Widget {
    let kind: String = "D-DayWidget"            // 위젯의 ID//타임라인을 리로드할때

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,   //사용자가 설정하는 컨피그
            provider: Provider()                //위젯 생성자 (타이밍 설정도 가능)
        ){ entry in
            D_DayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")      //위젯 추가갤러리 - 이름
        .description("This is an example widget.")  //위젯 추가갤러리 - 설명
    }
}

struct D_DayWidget_Previews: PreviewProvider {
    static var previews: some View {
        D_DayWidgetEntryView(entry: SimpleEntry(date: Date(), title: "1234567899제목", dday: "D-1234", image: UIImage(systemName: "house")!))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        
    }
}
