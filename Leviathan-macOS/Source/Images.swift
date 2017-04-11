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
  case Ic_account = "ic_account"
  case Ic_federated = "ic_federated"
  case Ic_home = "ic_home"
  case Ic_local = "ic_local"
  case Ic_notifications = "ic_notifications"
  case Ic_notifications_none = "ic_notifications_none"
  case Ic_write_post = "ic_write_post"

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
