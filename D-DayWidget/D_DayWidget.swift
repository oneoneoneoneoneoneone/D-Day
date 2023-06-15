//
//  D-DayWidget.swift
//  D-DayWidget
//
//  Created by hana on 2023/02/09.
//

import Foundation

import WidgetKit
import SwiftUI
import Intents

//isPreview - 위젯갤러리에 표시하기위한 미리보기 스냅샷 표시 // : TimelineProvider
struct Provider: IntentTimelineProvider {    
    typealias Entry = ItemEntry
    
    //본격적으로 위젯에 표시될
    func placeholder(in context: Context) -> ItemEntry {
        return ItemEntry(date: Date(),
                         id: "",
                         title: "EVENT",
                         titleTextAttribute: TextAttributes(centerY: Float(TextType.title.centerY)),
                         dday: "D-Day",
                         ddayTextAttribute: TextAttributes(),
                         dateText: Date.now.toString,
                         dateTextAttribute: TextAttributes(centerY: Float(TextType.date.centerY)),
                         backImage: UIImage(),
                         backColor: .systemBackground
        )
    }

    //데이터를 가져와서 표출해주는.  스냅샷 샘플데이터 설정
    //ConfigurationIntent: D_DayWidget.intentdefinition - CustomIntent 이름
    func getSnapshot(for configuration: WidgetIntent, in context: Context, completion: @escaping (ItemEntry) -> ()) {
        let entry = ItemEntry(
            date: Date(),
            id: "",
            title: "EVENT",
            titleTextAttribute: TextAttributes(centerY: Float(TextType.title.centerY)),
            dday: "D-Day",
            ddayTextAttribute: TextAttributes(),
            dateText: Date.now.toString,
            dateTextAttribute: TextAttributes(centerY: Float(TextType.date.centerY)),
            backImage: UIImage(),
            backColor: .systemGray6
        )
        completion(entry)
    }

    //타임라인 설정 관련된. 언제 리로드할지
    func getTimeline(for configuration: WidgetIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ItemEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)! //언제 리로드할지
            
            let items = Repository().readItem()
            var item = Item()
            
            if items.filter({$0.id.stringValue == configuration.SelectedWidget?.identifier}).count > 0{
                item = items.filter{$0.id.stringValue == configuration.SelectedWidget?.identifier}.first ?? Item()
            }
            else{
                item = items.filter{$0.id.stringValue == Repository().getDefaultWidget()}.first ?? Item()
            }
            
            let entry = ItemEntry(
                date: entryDate,
                id: item.id.stringValue,
                title: item.title,
                titleTextAttribute: item.textAttributes[safe: TextType.title.rawValue] ?? TextAttributes(centerY: Float(TextType.title.centerY)),
                dday: Util.numberOfDaysFromDate(isStartCount: item.isStartCount, from: item.date),
                ddayTextAttribute: item.textAttributes[safe: TextType.dday.rawValue] ?? TextAttributes(),
                dateText: item.date.toString,
                dateTextAttribute: item.textAttributes[safe: TextType.date.rawValue] ?? TextAttributes(centerY: Float(TextType.date.centerY)),
                backImage: item.background?.isImage == true ? Repository().loadImageFromFileManager(imageName: item.id.stringValue) ?? UIImage() : UIImage(),
                backColor: item.background?.isColor == true ? UIColor(hexCode: item.background?.color ?? Background().color) : nil
            )
            entries.append(entry)
            
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    }
}

//위젯 콘텐츠를 업데이트한 date정보 + 표시하고자하는 정보 : TimelineEntry
struct ItemEntry: TimelineEntry {
    let date: Date
    let id: String
    let title: String
    let titleTextAttribute: TextAttributes
    let dday: String
    let ddayTextAttribute: TextAttributes
    let dateText: String
    let dateTextAttribute: TextAttributes
    let backImage: UIImage
    let backColor: UIColor?
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
                Image(uiImage: entry.backImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                VStack{
                    GeometryReader { geometry in
                        Text(entry.title)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .opacity(entry.titleTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.titleTextAttribute.color)))
                            .position(x: geometry.size.width/4 * CGFloat(entry.titleTextAttribute.centerX) + geometry.size.width/4,
                                      y: geometry.size.height/2 * CGFloat(entry.titleTextAttribute.centerY))
                        Text(entry.dday)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .opacity(entry.ddayTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.ddayTextAttribute.color)))
                            .position(x: geometry.size.width/4 * CGFloat(entry.ddayTextAttribute.centerX) + geometry.size.width/4,
                                      y: geometry.size.height/2 * CGFloat(entry.ddayTextAttribute.centerY))
                        Text(entry.dateText)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .opacity(entry.dateTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.dateTextAttribute.color)))
                            .position(x: geometry.size.width/4 * CGFloat(entry.dateTextAttribute.centerX) + geometry.size.width/4,
                                      y: geometry.size.height/2 * CGFloat(entry.dateTextAttribute.centerY))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(entry.backColor ?? .white))
            .widgetURL(URL(string: "open://detail?id=\(entry.id)"))
            
        case .systemMedium:
            ZStack{
                Image(uiImage: entry.backImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                VStack{
                    GeometryReader { geometry in
                        Text(entry.title)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .opacity(entry.titleTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.titleTextAttribute.color)))
                            .position(x: geometry.size.width/2 * CGFloat(entry.titleTextAttribute.centerX),
                                      y: geometry.size.height/4 * CGFloat(entry.titleTextAttribute.centerY) + geometry.size.height/4)
                        Text(entry.dday)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .opacity(entry.ddayTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.ddayTextAttribute.color)))
                            .position(x: geometry.size.width/2 * CGFloat(entry.ddayTextAttribute.centerX),
                                      y: geometry.size.height/4 * CGFloat(entry.ddayTextAttribute.centerY) + geometry.size.height/4)
                        Text(entry.dateText)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .opacity(entry.dateTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.dateTextAttribute.color)))
                            .position(x: geometry.size.width/2 * CGFloat(entry.dateTextAttribute.centerX),
                                      y: geometry.size.height/4 * CGFloat(entry.dateTextAttribute.centerY) + geometry.size.height/4)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(entry.backColor ?? .white))
            .widgetURL(URL(string: "open://detail?id=\(entry.id)"))
        case .systemLarge:
            ZStack{
                Image(uiImage: entry.backImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                VStack{
                    GeometryReader { geometry in
                        Text(entry.title)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .opacity(entry.titleTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.titleTextAttribute.color)))
                            .position(x: geometry.size.width/4 * CGFloat(entry.titleTextAttribute.centerX) + geometry.size.width/4,
                                      y: geometry.size.height/2 * CGFloat(entry.titleTextAttribute.centerY))
                        Text(entry.dday)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .opacity(entry.ddayTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.ddayTextAttribute.color)))
                            .position(x: geometry.size.width/4 * CGFloat(entry.ddayTextAttribute.centerX) + geometry.size.width/4,
                                      y: geometry.size.height/2 * CGFloat(entry.ddayTextAttribute.centerY))
                        Text(entry.dateText)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .opacity(entry.dateTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.dateTextAttribute.color)))
                            .position(x: geometry.size.width/4 * CGFloat(entry.dateTextAttribute.centerX) + geometry.size.width/4,
                                      y: geometry.size.height/2 * CGFloat(entry.dateTextAttribute.centerY))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(entry.backColor ?? .white))
            .widgetURL(URL(string: "open://detail?id=\(entry.id)"))
        case .systemExtraLarge:
            ZStack{
                Image(uiImage: entry.backImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                VStack{
                    GeometryReader { geometry in
                        Text(entry.title)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .opacity(entry.titleTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.titleTextAttribute.color)))
                            .position(x: geometry.size.width/2 * CGFloat(entry.titleTextAttribute.centerX),
                                      y: geometry.size.height/2 * CGFloat(entry.titleTextAttribute.centerY))
                        Text(entry.dday)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .opacity(entry.ddayTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.ddayTextAttribute.color)))
                            .position(x: geometry.size.width/2 * CGFloat(entry.ddayTextAttribute.centerX),
                                      y: geometry.size.height/2 * CGFloat(entry.ddayTextAttribute.centerY))
                        Text(entry.dateText)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .opacity(entry.dateTextAttribute.isHidden ? 0 : 1)
                            .foregroundColor(.init(uiColor: UIColor(hexCode: entry.dateTextAttribute.color)))
                            .position(x: geometry.size.width/2 * CGFloat(entry.dateTextAttribute.centerX),
                                      y: geometry.size.height/2 * CGFloat(entry.dateTextAttribute.centerY))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(entry.backColor ?? .white))
            .widgetURL(URL(string: "open://detail?id=\(entry.id)"))
        case .accessoryCircular:
            VStack{
                Text(entry.title.count > 3 ? String(entry.title[...entry.title.index(entry.title.startIndex, offsetBy:3)]) : entry.title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Text(entry.dday)
                    .font(.callout)
            }
            .widgetURL(URL(string: "open://detail?id=\(entry.id)"))
        case .accessoryInline:
            Text("\(entry.title)  \(entry.dday)")
                .font(.caption)
                .widgetURL(URL(string: "open://detail?id=\(entry.id)"))
        case .accessoryRectangular:
            Text("\(entry.title)  \(entry.dday)")
                .font(.caption)
                .widgetURL(URL(string: "open://detail?id=\(entry.id)"))
        default:
            Text("")
        }
    }
}

//@main
struct D_DayWidget: Widget {
    let kind: String = "D-DayWidget"            // 위젯의 ID//타임라인을 리로드할때

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: WidgetIntent.self,          //사용자가 설정하는 컨피그
            provider: Provider()                //위젯 생성자 (타이밍 설정도 가능)
        ){ entry in
            D_DayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(NSLocalizedString("디데이 위젯", comment: ""))                         //위젯 추가갤러리 - 이름
        .description(NSLocalizedString("한개의 디데이를 선택하여 위젯에 표시할 수 있습니다.", comment: ""))        //위젯 추가갤러리 - 설명
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge, .accessoryCircular, .accessoryInline, .accessoryRectangular])
    }
}


struct D_DayWidget_Previews: PreviewProvider {
    static var previews: some View {
        D_DayWidgetEntryView(entry: ItemEntry(date: Date(),
                                              id: "",
                                              title: "이벤트",
                                              titleTextAttribute: TextAttributes(centerY: Float(TextType.title.centerY)),
                                              dday: "D-Day",
                                              ddayTextAttribute: TextAttributes(),
                                              dateText: Date.now.toString,
                                              dateTextAttribute: TextAttributes(centerY: Float(TextType.date.centerY)),
                                              backImage: UIImage(),
                                              backColor: .yellow
                                             ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
