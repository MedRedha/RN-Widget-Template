import WidgetKit
import SwiftUI
import Intents

struct WidgetData: Decodable {
  var displayText: String
}

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), displayText: "Placeholder")
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, displayText: "Data goes here")
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
    let userDefaults = UserDefaults.init(suiteName: "group.com.wuud-team.redhawidget")
    
    if userDefaults != nil {
      if let savedData = userDefaults!.value(forKey: "savedData") as? String {
        let decoder = JSONDecoder()
        let data = savedData.data(using: .utf8)
        
        if let parsedData = try? decoder.decode(WidgetData.self, from: data!) {
          let nextRefresh = Calendar.current.date(byAdding: .second, value: 10, to: Date())!
          let entry = SimpleEntry(date: nextRefresh, configuration: configuration, displayText: parsedData.displayText)
          let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))

          WidgetCenter.shared.reloadAllTimelines()
          completion(timeline)
        } else {
          print("Could not parse data")
        }

      } else {
        let nextRefresh = Calendar.current.date(byAdding: .second, value: 10, to: Date())!
        let entry = SimpleEntry(date: nextRefresh, configuration: configuration, displayText: "Fetching data...")
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        

        WidgetCenter.shared.reloadAllTimelines()
        completion(timeline)
      }
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let displayText: String
}

prefix operator ⋮
prefix func ⋮(hex:UInt32) -> Color {
    return Color(hex)
}

extension Color {
    init(_ hex: UInt32, opacity:Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

let hexColor:(UInt32) -> (Color) = {
    return Color($0)
}

struct RedhaWidgetEntryView : View {
  @Environment(\.colorScheme) var colorScheme
  var entry: Provider.Entry
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .lastTextBaseline) {
        Text("BTC")
          .bold()
          .font(.system(size: 22, design: .default))
        Text("Bitcoin")
          .foregroundColor(colorScheme == .dark ? ⋮0xDFDDDD : ⋮0x6D6D86)
          .font(.system(size: 16, weight: .regular, design: .default))
        
        Spacer()
      }
      
      HStack{
        Image(systemName: "arrowtriangle.down.fill")
          .font(.system(size: 12.0, weight: .bold))
          .foregroundColor(Color.red)
        Text("79,9%")
          .font(.system(size: 16, weight: .bold, design: .default))
          .foregroundColor(⋮0xFF2500)
      }
      
      Spacer()
      
      Text(entry.displayText)
        .font(.system(size: 21, weight: .regular, design: .default))
      
      Divider().background(⋮0xCAC8CB).frame(alignment: .center)
      
      HStack(alignment: .center) {
        Text("NURI")
          .foregroundColor(colorScheme == .dark ? ⋮0xDFDDDD : ⋮0x000000)
          .font(.system(size: 14, weight: .regular, design: .default))
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .font(.system(size: 12.0, weight: .regular))
          .foregroundColor(colorScheme == .dark ? ⋮0xDFDDDD : ⋮0x2C232E)
      }
    }.padding(.vertical, 14).padding(.horizontal, 20).background(colorScheme == .dark ? ⋮0x2C232E : ⋮0xF0F0F0)
  }
}

@main
struct RedhaWidget: Widget {
  let kind: String = "Nuri Widget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      RedhaWidgetEntryView(entry: entry)
    }
    .supportedFamilies([.systemSmall, .systemMedium])
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct RedhaWidget_Previews: PreviewProvider {
  static var previews: some View {
    RedhaWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), displayText: "Widget preview"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
