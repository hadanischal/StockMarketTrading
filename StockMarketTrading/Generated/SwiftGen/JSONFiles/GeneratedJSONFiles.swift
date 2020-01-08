// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - JSON Files

// swiftlint:disable identifier_name line_length type_body_length
internal enum JSONFiles {
  internal enum BlockchainTicker {
    private static let _document = JSONDocument(path: "BlockchainTicker.json")
    internal static let aud: [String: Any] = _document["AUD"]
    internal static let brl: [String: Any] = _document["BRL"]
    internal static let cad: [String: Any] = _document["CAD"]
    internal static let chf: [String: Any] = _document["CHF"]
    internal static let clp: [String: Any] = _document["CLP"]
    internal static let cny: [String: Any] = _document["CNY"]
    internal static let dkk: [String: Any] = _document["DKK"]
    internal static let eur: [String: Any] = _document["EUR"]
    internal static let gbp: [String: Any] = _document["GBP"]
    internal static let hkd: [String: Any] = _document["HKD"]
    internal static let inr: [String: Any] = _document["INR"]
    internal static let isk: [String: Any] = _document["ISK"]
    internal static let jpy: [String: Any] = _document["JPY"]
    internal static let krw: [String: Any] = _document["KRW"]
    internal static let nzd: [String: Any] = _document["NZD"]
    internal static let pln: [String: Any] = _document["PLN"]
    internal static let rub: [String: Any] = _document["RUB"]
    internal static let sek: [String: Any] = _document["SEK"]
    internal static let sgd: [String: Any] = _document["SGD"]
    internal static let thb: [String: Any] = _document["THB"]
    internal static let twd: [String: Any] = _document["TWD"]
    internal static let usd: [String: Any] = _document["USD"]
  }
  internal enum PaymentsNetwork {
    private static let _document = JSONDocument(path: "PaymentsNetwork.json")
    internal static let aud: [String: Any] = _document["AUD"]
    internal static let brl: [String: Any] = _document["BRL"]
    internal static let cad: [String: Any] = _document["CAD"]
    internal static let chf: [String: Any] = _document["CHF"]
    internal static let clp: [String: Any] = _document["CLP"]
    internal static let cny: [String: Any] = _document["CNY"]
    internal static let dkk: [String: Any] = _document["DKK"]
    internal static let eur: [String: Any] = _document["EUR"]
    internal static let gbp: [String: Any] = _document["GBP"]
    internal static let hkd: [String: Any] = _document["HKD"]
    internal static let inr: [String: Any] = _document["INR"]
    internal static let isk: [String: Any] = _document["ISK"]
    internal static let jpy: [String: Any] = _document["JPY"]
    internal static let krw: [String: Any] = _document["KRW"]
    internal static let nzd: [String: Any] = _document["NZD"]
    internal static let pln: [String: Any] = _document["PLN"]
    internal static let rub: [String: Any] = _document["RUB"]
    internal static let sek: [String: Any] = _document["SEK"]
    internal static let sgd: [String: Any] = _document["SGD"]
    internal static let thb: [String: Any] = _document["THB"]
    internal static let twd: [String: Any] = _document["TWD"]
    internal static let usd: [String: Any] = _document["USD"]
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func objectFromJSON<T>(at path: String) -> T {
  let bundle = Bundle(for: BundleToken.self)
  guard let url = bundle.url(forResource: path, withExtension: nil),
    let json = try? JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []),
    let result = json as? T else {
    fatalError("Unable to load JSON at path: \(path)")
  }
  return result
}

private struct JSONDocument {
  let data: [String: Any]

  init(path: String) {
    self.data = objectFromJSON(at: path)
  }

  subscript<T>(key: String) -> T {
    guard let result = data[key] as? T else {
      fatalError("Property '\(key)' is not of type \(T.self)")
    }
    return result
  }
}

private final class BundleToken {}
