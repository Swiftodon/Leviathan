// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum Asset: String {
  case appLogo = "AppLogo"
  case icAccount = "ic_account"
  case icFederated = "ic_federated"
  case icHome = "ic_home"
  case icLocal = "ic_local"
  case icNotifications = "ic_notifications"
  case icNotificationsNone = "ic_notifications_none"
  case icSettings = "ic_settings"
  case icWritePost = "ic_write_post"

  var image: Image {
    return Image(asset: self)
  }
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
