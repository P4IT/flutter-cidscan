//
//  LicenseStreamHandler.swift
//  flutter_cidscan
//
//  Created by Uwe Hoppe on 10.06.21.
//

import Foundation

public class LicenseStreamHandler: NSObject, FlutterStreamHandler {
    
    private var _sink: FlutterEventSink?
    private var _data: NSMutableDictionary?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self._sink = events
        if(_data != nil) {
            _sink!(_data)
        }
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self._sink = nil
        return nil
    }

    public func send(channel: String, event: String, data: NSMutableDictionary) {
        _data = data;
        _data!["FunctionName"] = event
        if(_sink != nil) {
            _sink!(_data)
            _data = nil
        }
    }
}
