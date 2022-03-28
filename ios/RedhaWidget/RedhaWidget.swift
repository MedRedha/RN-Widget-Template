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
  var ethPrice: String
}

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: RedhaWidgetConfigurationIntent(), btcPrice: "Placeholder", ethPrice: "Placeholder", chosenCurrency: true, theme: true)
  }
  
  func getSnapshot(for configuration: RedhaWidgetConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, btcPrice: "32,800€", ethPrice: "1750.20€", chosenCurrency: true, theme: true)
    completion(entry)
  }
  
  func getTimeline(for configuration: RedhaWidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
    let userDefaults = UserDefaults.init(suiteName: "group.com.wuud-team.redhawidget")
    let date = Date().zeroSeconds!
    var entries: [SimpleEntry] = []
    
    let theme: Bool
    let chosenCurrency: Bool
    
    switch configuration.theme {
    case .dark:
      theme = true
    case .light:
      theme = false
    }
    
    switch configuration.currency {
    case .unknown, .all:
      chosenCurrency = true
    case .bitcoin:
      chosenCurrency = true
    case .ethereum:
      chosenCurrency = false
    }
    
    if userDefaults != nil {
      if let savedData = userDefaults!.value(forKey: "savedData") as? String {
        let decoder = JSONDecoder()
        let data = savedData.data(using: .utf8)
        
        if let parsedData = try? decoder.decode(WidgetData.self, from: data!) {
          
          for interval in 0 ..< 60 {
            let nextRefresh = Calendar.current.date(byAdding: .second , value: interval, to: date)!
            let entry = SimpleEntry(date: nextRefresh, configuration: configuration, btcPrice: parsedData.btcPrice, ethPrice: parsedData.ethPrice, chosenCurrency: chosenCurrency, theme: theme)
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
        let entry = SimpleEntry(date: nextRefresh, configuration: configuration, btcPrice: "Fetching data...", ethPrice: "Fetching data...", chosenCurrency: chosenCurrency, theme: theme)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        
        WidgetCenter.shared.reloadAllTimelines()
        completion(timeline)
      }
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: RedhaWidgetConfigurationIntent
  let btcPrice: String
  let ethPrice: String
  var chosenCurrency: Bool = false
  var theme: Bool = true
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
  //  @Environment(\.colorScheme) var colorScheme
  var entry: Provider.Entry
  
  @ViewBuilder
  var body: some View {
    switch family {
    case .systemSmall:
      VStack(alignment: .leading) {
        HStack(alignment: .lastTextBaseline) {
          if entry.chosenCurrency {
            Text("BTC")
              .bold()
              .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x2C232E)
              .font(.system(size: 22.0, design: .default))
            Text("Bitcoin")
              .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x6D6D86)
              .font(.system(size: 16.0, weight: .regular, design: .default))
          } else {
            Text("ETH")
              .bold()
              .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x2C232E)
              .font(.system(size: 22.0, design: .default))
            Text("Ethereum")
              .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x6D6D86)
              .font(.system(size: 13.0, weight: .regular, design: .default))
          }
          
          Spacer()
        }
        
        HStack{
          if entry.chosenCurrency {
            Image(systemName: "arrowtriangle.down.fill")
              .font(.system(size: 12.0, weight: .bold))
              .foregroundColor(Color.red)
            Text("79,9%")
              .font(.system(size: 16.0, weight: .bold, design: .default))
              .foregroundColor(⋮0xFF2500)
          } else {
            Image(systemName: "arrowtriangle.up.fill")
              .font(.system(size: 12.0, weight: .bold))
              .foregroundColor(⋮0x1CC18C)
            Text("19,1%")
              .font(.system(size: 16.0, weight: .regular, design: .default))
              .foregroundColor(⋮0x1CC18C)
          }
        }
        
        Spacer()
        
        if entry.chosenCurrency {
          Text(entry.btcPrice)
            .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x2C232E)
            .font(.system(size: 21.0, weight: .regular, design: .default))
        } else {
          Text(entry.ethPrice)
            .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x2C232E)
            .font(.system(size: 21.0, weight: .regular, design: .default))
        }
        
        Divider().background(⋮0xCAC8CB).frame(alignment: .center)
        
        HStack(alignment: .center) {
          Text("NURI")
            .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x000000)
            .font(.system(size: 14.0, weight: .regular, design: .default))
          
          Spacer()
          
          Image(systemName: "chevron.right")
            .font(.system(size: 12.0, weight: .regular))
            .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x2C232E)
        }
      }.padding(.vertical, 14.0).padding(.horizontal, 20.0).background(entry.theme ? ⋮0x2C232E : ⋮0xF0F0F0).widgetURL(URL(string: "nuriwidget://btc")!)
    case .systemMedium:
      HStack(alignment: .center, spacing: 0.0) {
        Image(entry.theme ? "Logo" : "LogoLight")
          .resizable()
          .frame(width: 38.0, height: 38.0)
          .padding(.horizontal, 15.0)
        
        Divider().background(⋮0xCAC8CB).frame(width: 0.0)
        
        VStack(alignment: .center, spacing: 0.0) {
          Spacer()
          
          VStack(alignment: .center) {
            Link(destination: URL(string: "nuriwidget://btc")!) {
              HStack(alignment: .center) {
                Text("BTC")
                  .bold()
                  .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x2C232E)
                  .font(.system(size: 22.0, design: .default))
                
                Spacer()
                
                Text(entry.btcPrice)
                  .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x2C232E)
                  .font(.system(size: 21.0, weight: .regular, design: .default))
                  .onChange(of: entry.btcPrice) { change in
                    WidgetCenter.shared.reloadAllTimelines()
                  }
              }.padding(.horizontal, 16.0)
              
              HStack(alignment: .center) {
                Text("Bitcoin")
                  .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x6D6D86)
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
            }
            
            Divider().background(⋮0xCAC8CB).frame(width: .infinity, height: 10.0, alignment: .center)
            
            Link(destination: URL(string: "nuriwidget://eth")!) {
              HStack(alignment: .center) {
                Text("ETH")
                  .bold()
                  .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x2C232E)
                  .font(.system(size: 22.0, design: .default))
                
                Spacer()
                
                Text(entry.ethPrice)
                  .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x2C232E)
                  .font(.system(size: 21.0, weight: .regular, design: .default))
                  .onChange(of: entry.ethPrice) { change in
                    WidgetCenter.shared.reloadAllTimelines()
                  }
              }.padding(.horizontal, 16.0)
              
              HStack(alignment: .center) {
                Text("Ethereum")
                  .foregroundColor(entry.theme ? ⋮0xDFDDDD : ⋮0x6D6D86)
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
            }
          }.frame(
            maxWidth: .infinity,
            maxHeight: .infinity
          )
          
          Spacer()
        }
      }.background(entry.theme ? ⋮0x2C232E : ⋮0xF0F0F0).padding(0.0)
    default:
      Text("Some other WidgetFamily in the future.")
    }
  }
}

@main
struct RedhaWidget: Widget {
  let kind: String = "com.wuud-team.redhawidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: RedhaWidgetConfigurationIntent.self, provider: Provider()) { entry in
      RedhaWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Nuri Widget")
    .description("Nuri's Widget displays live Bitcoin and Ethereum prices. You can choose your own configuration:")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}


struct RedhaWidget_Previews: PreviewProvider {
  static var previews: some View {
    RedhaWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: RedhaWidgetConfigurationIntent(), btcPrice: "Widget preview", ethPrice: "Widget preview"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
