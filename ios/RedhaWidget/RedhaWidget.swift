import WidgetKit
import SwiftUI
import Intents

extension Date {

var zeroSeconds: Date? {
    let calendar = Calendar.current
  let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    return calendar.date(from: dateComponents)
}}

struct WidgetData: Decodable {
  var btcPrice: String
}

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), btcPrice: "Placeholder")
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, btcPrice: "Data goes here")
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
    let userDefaults = UserDefaults.init(suiteName: "group.com.wuud-team.redhawidget")
    let date = Date().zeroSeconds!
    var entries: [SimpleEntry] = []
    
    if userDefaults != nil {
      if let savedData = userDefaults!.value(forKey: "savedData") as? String {
        let decoder = JSONDecoder()
        let data = savedData.data(using: .utf8)
        
        if let parsedData = try? decoder.decode(WidgetData.self, from: data!) {
          
          for interval in 0 ..< 60 {
            let nextRefresh = Calendar.current.date(byAdding: .second , value: interval, to: date)!
            let entry = SimpleEntry(date: nextRefresh, configuration: configuration, btcPrice: parsedData.btcPrice)
            entries.append(entry)
          }
          
          let timeline = Timeline(entries: entries, policy: .atEnd)
          
          WidgetCenter.shared.reloadAllTimelines()
          completion(timeline)
        } else {
          print("Could not parse data")
        }
        
      } else {
        let nextRefresh = Calendar.current.date(byAdding: .second, value: 1, to: date)!
        let entry = SimpleEntry(date: nextRefresh, configuration: configuration, btcPrice: "Fetching data...")
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
  let btcPrice: String
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
  @Environment(\.widgetFamily) var family
  @Environment(\.colorScheme) var colorScheme
  var entry: Provider.Entry
  
  @ViewBuilder
  var body: some View {
    switch family {
    case .systemSmall:
      VStack(alignment: .leading) {
        HStack(alignment: .lastTextBaseline) {
          Text("BTC")
            .bold()
            .font(.system(size: 22.0, design: .default))
          Text("Bitcoin")
            .foregroundColor(colorScheme == .dark ? ⋮0xDFDDDD : ⋮0x6D6D86)
            .font(.system(size: 16.0, weight: .regular, design: .default))
          
          Spacer()
        }
        
        HStack{
          Image(systemName: "arrowtriangle.down.fill")
            .font(.system(size: 12.0, weight: .bold))
            .foregroundColor(Color.red)
          Text("79,9%")
            .font(.system(size: 16.0, weight: .bold, design: .default))
            .foregroundColor(⋮0xFF2500)
        }
        
        Spacer()
        
        Text(entry.btcPrice)
          .font(.system(size: 21.0, weight: .regular, design: .default))
        
        Divider().background(⋮0xCAC8CB).frame(alignment: .center)
        
        HStack(alignment: .center) {
          Text("NURI")
            .foregroundColor(colorScheme == .dark ? ⋮0xDFDDDD : ⋮0x000000)
            .font(.system(size: 14.0, weight: .regular, design: .default))
          
          Spacer()
          
          Image(systemName: "chevron.right")
            .font(.system(size: 12.0, weight: .regular))
            .foregroundColor(colorScheme == .dark ? ⋮0xDFDDDD : ⋮0x2C232E)
        }
      }.padding(.vertical, 14.0).padding(.horizontal, 20.0).background(colorScheme == .dark ? ⋮0x2C232E : ⋮0xF0F0F0)
    case .systemMedium:
      HStack(alignment: .center, spacing: 0.0) {
        Image("Logo")
          .resizable()
          .frame(width: 38.0, height: 38.0)
          .padding(.horizontal, 15.0)
        
        Divider().background(⋮0xCAC8CB).frame(width: 0.0)
        
        VStack(alignment: .center, spacing: 0.0) {
          Spacer()
          
          VStack(alignment: .center) {
            HStack(alignment: .center) {
              Text("BTC")
                .bold()
                .font(.system(size: 22.0, design: .default))
              
              Spacer()
              
              Text(entry.btcPrice)
                .font(.system(size: 21.0, weight: .regular, design: .default))
                .onChange(of: entry.btcPrice) { change in
                  WidgetCenter.shared.reloadAllTimelines()
                }
            }.padding(.horizontal, 16.0)
            
            HStack(alignment: .center) {
              Text("Bitcoin")
                .foregroundColor(colorScheme == .dark ? ⋮0xDFDDDD : ⋮0x6D6D86)
                .font(.system(size: 16.0, weight: .regular, design: .default))
              
              Spacer()
              
              HStack{
                Image(systemName: "arrowtriangle.down.fill")
                  .font(.system(size: 12.0, weight: .bold))
                  .foregroundColor(Color.red)
                Text("79,9%")
                  .font(.system(size: 16.0, weight: .regular, design: .default))
                  .foregroundColor(⋮0xFF2500)
              }
            }.padding(.horizontal, 16.0)
            
            Divider().background(⋮0xCAC8CB).frame(width: .infinity, height: 10.0, alignment: .center)
            
            HStack(alignment: .center) {
              Text("ETH")
                .bold()
                .font(.system(size: 22.0, design: .default))
              
              Spacer()
              
              Text(entry.btcPrice)
                .font(.system(size: 21.0, weight: .regular, design: .default))
                .onChange(of: entry.btcPrice) { change in
                  WidgetCenter.shared.reloadAllTimelines()
                }
            }.padding(.horizontal, 16.0)
            
            HStack(alignment: .center) {
              Text("Ethereum")
                .foregroundColor(colorScheme == .dark ? ⋮0xDFDDDD : ⋮0x6D6D86)
                .font(.system(size: 16.0, weight: .regular, design: .default))
              
              Spacer()
              
              HStack{
                Image(systemName: "arrowtriangle.up.fill")
                  .font(.system(size: 12.0, weight: .bold))
                  .foregroundColor(⋮0x1CC18C)
                Text("19,1%")
                  .font(.system(size: 16.0, weight: .regular, design: .default))
                  .foregroundColor(⋮0x1CC18C)
              }
            }.padding(.horizontal, 16.0)
          }.frame(
            maxWidth: .infinity,
            maxHeight: .infinity
          )
          
          Spacer()
        }
      }.background(colorScheme == .dark ? ⋮0x2C232E : ⋮0xF0F0F0).padding(0.0)
    default:
      Text("Some other WidgetFamily in the future.")
    }
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
    RedhaWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), btcPrice: "Widget preview"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
