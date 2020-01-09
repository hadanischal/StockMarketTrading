// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  internal enum DashBoard {
    /// Amount badly formatted
    internal static let amountError = L10n.tr("DashBoard", "AMOUNT_ERROR")
    /// Error
    internal static let failedTitle = L10n.tr("DashBoard", "FAILED_TITLE")
    /// Buy \n Market
    internal static let headerDescription = L10n.tr("DashBoard", "HEADER_DESCRIPTION")
    /// UK-100 Cash
    internal static let headerTitle = L10n.tr("DashBoard", "HEADER_TITLE")
    /// Level 1
    internal static let level1Title = L10n.tr("DashBoard", "LEVEL1_TITLE")
    /// Error contacting server
    internal static let serverError = L10n.tr("DashBoard", "SERVER_ERROR")
    /// CMS | CFD
    internal static let title = L10n.tr("DashBoard", "TITLE")
    /// Unit badly formatted
    internal static let unitError = L10n.tr("DashBoard", "UNIT_ERROR")
  }
  internal enum Mock {
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
