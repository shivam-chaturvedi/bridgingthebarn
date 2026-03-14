import Flutter
import UIKit

private let deepLinkChannelName = "bridgingbarn/deeplink"

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var methodChannel: FlutterMethodChannel?
  private var pendingUri: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    setupDeepLinkChannel()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    handleDeepLink(url.absoluteString)
    return super.application(app, open: url, options: options)
  }

  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if let url = userActivity.webpageURL {
      handleDeepLink(url.absoluteString)
    }
    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }

  private func setupDeepLinkChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }
    methodChannel = FlutterMethodChannel(
      name: deepLinkChannelName,
      binaryMessenger: controller.binaryMessenger
    )
    methodChannel?.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "getInitialUri":
        result(self?.consumePendingUri())
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func consumePendingUri() -> String? {
    defer { pendingUri = nil }
    return pendingUri
  }

  private func handleDeepLink(_ uri: String) {
    if pendingUri == nil {
      pendingUri = uri
    }
    if methodChannel != nil {
      methodChannel?.invokeMethod("pushUri", arguments: uri)
    }
  }
}
