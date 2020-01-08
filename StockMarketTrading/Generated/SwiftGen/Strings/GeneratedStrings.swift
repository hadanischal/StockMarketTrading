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
    /// Email address badly formatted
    internal static let loginEmailError = L10n.tr("DashBoard", "LOGIN_EMAIL_ERROR")
    /// Please make sure to enter correct email and password
    internal static let loginFailed = L10n.tr("DashBoard", "LOGIN_FAILED")
    /// Login Failed
    internal static let loginFailedTitle = L10n.tr("DashBoard", "LOGIN_FAILED_TITLE")
    /// Password must be at least %d characters
    internal static func loginPasswordError(_ p1: Int) -> String {
      return L10n.tr("DashBoard", "LOGIN_PASSWORD_ERROR", p1)
    }
    /// Password badly formatted
    internal static let loginPasswordErrorBadFormat = L10n.tr("DashBoard", "LOGIN_PASSWORD_ERROR_BAD_FORMAT")
    /// Password different
    internal static let loginPasswordErrorDifferent = L10n.tr("DashBoard", "LOGIN_PASSWORD_ERROR_DIFFERENT")
    /// Password repeated
    internal static let loginPasswordErrorRepeated = L10n.tr("DashBoard", "LOGIN_PASSWORD_ERROR_REPEATED")
    /// Username can only contain numbers or digits
    internal static let usernameError = L10n.tr("DashBoard", "USERNAME_ERROR")
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
