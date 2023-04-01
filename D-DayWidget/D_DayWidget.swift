//
//  D-DayWidget.swift
//  D-DayWidget
//
//  Created by hana on 2023/02/09.
//

import WidgetKit
import SwiftUI
import Intents

//isPreview - 위젯갤러리에 표시하기위한 미리보기 스냅샷 표시 // : TimelineProvider
struct Provider: IntentTimelineProvider {    
    typealias Entry = SimpleEntry
    
//    typealias Intent = WidgetItemIntent
//        .intentdefinition
    //본격적으로 위젯에 표시될
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(),
                           title: "이벤트",
                           dday: "D-Day",
                           image: UIImage(),
                           forColor: .label,
                           backColor: .systemBackground
        )
    }

    //데이터를 가져와서 표출해주는.  스냅샷 샘플데이터 설정
    //ConfigurationIntent: D_DayWidget.intentdefinition - CustomIntent 이름
    func getSnapshot(for configuration: WidgetIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let item = Array(Repository().readItem()).first
        
        let entry = SimpleEntry(
            date: Date(),
            title: "이벤트",
            dday: "D-Day",
            image: UIImage(),
            forColor: .label,
            backColor: .systemBackground
        )
        completion(entry)
    }

    //타임라인 설정 관련된. 언제 리로드할지
    func getTimeline(for configuration: WidgetIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)! //언제 리로드할지
            
            let items = Array(Repository().readItem())
            var item = items.filter{$0.id.stringValue == configuration.SelectedWidget?.identifier}.first ?? Item()
            if items.filter({$0.id.stringValue == configuration.SelectedWidget?.identifier}).count < 1 {
                item.title = "디데이를 선택해주세요."
            }
            
            let entry = SimpleEntry(
                date: entryDate,
                title: item.title,
                dday: Util.numberOfDaysFromDate(from: item.date),
                image: Repository().loadImageFromDocumentDirectory(imageName: item.id.stringValue) ?? UIImage(),
                forColor: UIColor(hexCode: item.titleColor),
                backColor: UIColor(hexCode: item.backgroundColor)
            )
            entries.append(entry)
            
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    }
}

//위젯 콘텐츠를 업데이트한 date정보 + 표시하고자하는 정보 : TimelineEntry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let dday: String
    let image: UIImage
    let forColor: UIColor
    let backColor: UIColor
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
                VStack{
                    Text(entry.title)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: 5)
                    Text(entry.dday)
                        .font(.title3)
                }.foregroundColor(.init(entry.forColor))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(entry.backColor))
            
        case .systemMedium:
            ZStack{
                Image(uiImage: entry.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                HStack{
                    Text(entry.title)
                        .font(.title3)
                        .padding(10)
                    Spacer()
                    Text(entry.dday)
                        .font(.title)
                        .padding(10)
                }.foregroundColor(.init(entry.forColor))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(entry.backColor))
        case .systemLarge:
            ZStack{
                Image(uiImage: entry.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                VStack{
                    Text(entry.title)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: 20)
                    Text(entry.dday)
                        .font(.title)
                }.foregroundColor(.init(entry.forColor))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(entry.backColor))
//        case .systemExtraLarge:
//            VStack{
//                Text(entry.title)
//                    .font(.title3)
//                    .multilineTextAlignment(.center)
//                Spacer().frame(height: 20)
//                Text(entry.dday)
//                    .font(.title)
//            }
        case .accessoryCircular:
            VStack{
                Text(entry.title.count > 3 ? String(entry.title[...entry.title.index(entry.title.startIndex, offsetBy:3)]) : entry.title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Text(entry.dday)
                    .font(.callout)
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
            intent: WidgetIntent.self,   //사용자가 설정하는 컨피그
            provider: Provider()                //위젯 생성자 (타이밍 설정도 가능)
        ){ entry in
            D_DayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("디데이 위젯")      //위젯 추가갤러리 - 이름
        .description("하나의 디데이를 선택하여 위젯에 표시할 수 있습니다.")  //위젯 추가갤러리 - 설명
    }
}


struct D_DayWidget_Previews: PreviewProvider {
    static var previews: some View {
        D_DayWidgetEntryView(entry: SimpleEntry(date: Date(),
                                                title: "이벤트",
                                                dday: "D-Day",
                                                image: UIImage(),
                                                forColor: .gray,
                                                backColor: .yellow
                                               ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
