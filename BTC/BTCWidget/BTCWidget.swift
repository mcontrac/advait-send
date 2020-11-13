//
//  BTCWidget.swift
//  BTCWidget
//
//  Created by Milind Contractor on 31/10/20.
//

import WidgetKit
import SwiftUI

class NetworkManager {
    func getWeatherData(completion: @escaping (SimpleEntry.BTCData?) ->Void) {
        guard let url = URL(string: "https://api.blockchain.com/v3/exchange/tickers/ETH-USD") else { return completion(nil)}
        URLSession.shared.dataTask(with: url) { d, res, err
            in
            var result: SimpleEntry.BTCData?
            if let data = d,
                let response = res as? HTTPURLResponse,
                    response.statusCode == 200 {
                do {
                    result = try JSONDecoder().decode(SimpleEntry.BTCData.self, from: data)
                } catch {
                    print(error)
                }
            }
            
            return completion(result)
        }
        .resume()
    }
}

struct Provider: TimelineProvider {
    let networkManager = NetworkManager()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),data: .previewData, error: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        networkManager.getWeatherData{ data in
            let entry = SimpleEntry(date: Date(),data: data ?? .error, error: data == nil)
        completion(entry)
    }

}
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        networkManager.getWeatherData { data in
        var entries: [SimpleEntry] = []
        let timeline = Timeline(
            entries: [SimpleEntry(date: Date(), data: .previewData, error: false)], policy:
                .after(Calendar.current.date(byAdding: .minute, value: 1, to: Date())!))
        completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var data: BTCData = .previewData
    var error: Bool = false
    
    enum DifferenceMode: String {
        case up = "up"
        case down = "down"
        case error = "error"
    }
    
    var diffMode: DifferenceMode {
        if error || data.difference == 0.0 {
            return .error
        } else if data.difference > 0.0 {
            return .up
        } else {
            return .down
        }
    }
    
    struct BTCData: Decodable {
        let price_24h: Double
        let volume_24h: Double
        let last_trade_price: Double
        let symbol: String
        
        var difference: Double { price_24h - last_trade_price }
        
        static let previewData = BTCData(price_24h: 13315.4, volume_24h: 408.8495372, last_trade_price: 13660.32, symbol: "")
        static let error = BTCData(price_24h: 0, volume_24h: 0, last_trade_price: 0, symbol: "ERROR")
        
    }
}

struct BTCWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var theme
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("bitcoin.org.photo")
                .resizable()
                .unredacted()
            HStack {
                VStack(alignment: .leading) {
                    header
                    Spacer()
                    pricing
                    Spacer()
                    if family != .systemSmall {
                        volume
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
    var header: some View {
        Group {
            if family == .systemSmall {
                Text("VOLUME: \(entry.error ? "NO INTERNET" : "\(String(format: "%.4f", entry.data.volume_24h))")")
                    .font(family == .systemSmall ? .system(size: 15) : .title2)
                    .bold()
                    .foregroundColor(Color("\(entry.diffMode)Color"))
                    .italic()
            } else {
                Text("Stocks \(entry.data.symbol)")
                    .font(family == .systemSmall ? .system(size: 20) : .system(size: 30))
                    .bold()
            }
        }
        .foregroundColor(Color("headingColor"))
    }

    var pricing: some View {
        Group {
            if family == .systemMedium {
                HStack(alignment: .firstTextBaseline) {
                    price
                    difference
                }
            } else {
                price
                difference
            }
        }
    }
    
    
    var price: some View {
        Text(entry.error ? "NO INTERNET" : "\(String(format: "%.3f", entry.data.price_24h))")
            .font(family == .systemSmall ? .system(size: 21.25) : .system(size: CGFloat(family.rawValue * 25 + 5)))
            .bold()
    }
    
    var difference: some View {
        Text(entry.error ? "± ––––" : "\(entry.diffMode == .up ? "+" : "")\(String(format: "%.3f", entry.data.difference))")
            .font(family == .systemSmall ? .footnote : .title2)
            .bold()
            .foregroundColor(Color("\(entry.diffMode)Color"))
    }
    var volume: some View {
        Text("VOLUME: \(entry.error ? "NO INTERNET" : "\(String(format: "%.4f", entry.data.volume_24h))")")
            .font(family == .systemSmall ? .body : .title2)
            .bold()
            .foregroundColor(Color("\(entry.diffMode)Color"))
            .italic()
    }
}

@main
struct BTCWidget: Widget {
    let kind: String = "BTCWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BTCWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Stocks")
        .description("Stocks. Edit the code on GitHub by AdvaitThePro to get different stocks. Default: BTC-USD. Source: https://api.blockchain.com/v3/exchange/tickers/BTC-USD.")
    }
}

struct BTCWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        BTCWidgetEntryView(entry: SimpleEntry(date: Date(),data: .previewData, error: false))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        BTCWidgetEntryView(entry: SimpleEntry(date: Date(),data: .previewData, error: false))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        BTCWidgetEntryView(entry: SimpleEntry(date: Date(), data: .previewData, error: false))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
        .environment(\.colorScheme, .light)
//        .redacted(reason: .placeholder)
        Group {
        BTCWidgetEntryView(entry: SimpleEntry(date: Date(),data: .previewData, error: false))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        BTCWidgetEntryView(entry: SimpleEntry(date: Date(),data: .previewData, error: false))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        BTCWidgetEntryView(entry: SimpleEntry(date: Date(), data: .previewData, error: false))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
        .environment(\.colorScheme, .dark)
//        .redacted(reason: .placeholder)
    }
}
