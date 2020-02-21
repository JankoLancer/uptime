import Flutter
import UIKit
import Foundation

public class SwiftUptimePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "uptime", binaryMessenger: registrar.messenger())
        let instance = SwiftUptimePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(Int(uptime()*1000))
    }
    
    func uptime() -> time_t {
        var boottime = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout.stride(ofValue: boottime)
        
        var now = time_t()
        var uptime: time_t = -1
        
        time(&now)
        
        if (sysctl(&mib, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0) {
            uptime = now - boottime.tv_sec
        }
        return uptime
    }
}
