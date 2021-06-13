//
//  DecodeStreamHandler.swift
//  flutter_cidscan
//
//  Created by Uwe Hoppe on 10.06.21.
//

import Foundation

public class DecodeStreamHandler: NSObject, FlutterStreamHandler {
    
    private var _sink: FlutterEventSink?
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self._sink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self._sink = nil
        return nil
    }


//  private void send(String channel, String event, String data) {
//    try {
//      JSONObject obj = new JSONObject(data);
//      Map<String, Object> map = jsonToMap(obj);
//      final Map<String, Object> res = new HashMap<>();
//      res.put("channel", channel);
//      res.put("event", event);
//      res.put("body", map);
//      new Handler(Looper.getMainLooper()).post(new Runnable() {
//        @Override
//        public void run() {
//          _sink.success(res);
//        }
//      });
//    } catch (JSONException e) {
//      Log.e(TAG, e.getMessage());
//    }
//  }
}
