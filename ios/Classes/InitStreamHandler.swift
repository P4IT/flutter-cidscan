//
//  InitStreamHandler.swift
//  flutter_cidscan
//
//  Created by Uwe Hoppe on 10.06.21.
//

import Foundation

public class InitStreamHandler: NSObject, FlutterStreamHandler {
    private var _sink: FlutterEventSink?
    private var _data: NSDictionary?
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self._sink = events
        if(_data != nil) {
            _sink!(_data);
        }
        return nil
    }


    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self._sink = nil
        return nil
    }
    
    
    public func send(channel: String, event: String, data: NSDictionary) {
        _data = data;
        if(_sink != nil) {
            _sink!(_data)
            _data = nil
        }
    }
}

