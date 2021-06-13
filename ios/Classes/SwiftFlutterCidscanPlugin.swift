import Flutter
import UIKit

public class SwiftFlutterCidscanPlugin: NSObject, FlutterPlugin {
    private var library: CaptureIDLibrary?
    private var previewView: UIView?

    private var _initChannel: FlutterEventChannel?
    private var _licenseChannel: FlutterEventChannel?
    private var _decodeChannel: FlutterEventChannel?
    
    private let _inithandler = InitStreamHandler()
    private let _licensehandler = LicenseStreamHandler()
    private let _decodehandler = DecodeStreamHandler()
    
    private let INITHANDLER_ID = "cidscan_init"
    private let LICENSEHANDLER_ID = "cidscan_license"
    private let DECODEHANDLER_ID = "cidscan_decode"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftFlutterCidscanPlugin()
        instance.initialize(messenger: registrar.messenger())
//        registrar.addMethodCallDelegate(instance, channel: _channel)
    }

    private func initialize(messenger: FlutterBinaryMessenger) {
        self._initChannel = FlutterEventChannel(name: self.INITHANDLER_ID, binaryMessenger: messenger);
        self._initChannel?.setStreamHandler(self._inithandler)
        self._licenseChannel = FlutterEventChannel(name: self.LICENSEHANDLER_ID, binaryMessenger: messenger)
        self._licenseChannel?.setStreamHandler(self._licensehandler)
        self._decodeChannel = FlutterEventChannel(name: self.DECODEHANDLER_ID, binaryMessenger: messenger)
        self._decodeChannel?.setStreamHandler(self._decodehandler)
        let _channel = FlutterMethodChannel(name: "flutter_cidscan", binaryMessenger: messenger)
        _channel.setMethodCallHandler(handle)
    }

//    private void deinitialize() {
//      _activity = null;
//      _channel.setMethodCallHandler(null);
//      _initChannel.setStreamHandler(null);
//      _licenseChannel.setStreamHandler(null);
//      _decodeChannel.setStreamHandler(null);
//      _channel = null;
//    }


//    public Map<String, Object> jsonToMap(JSONObject json) {
//      Map<String, Object> ret = new HashMap<String, Object>();
//      if(json != null) {
//        ret = toMap(json);
//      }
//      return ret;
//    }
//
//    public Map<String, Object> toMap(JSONObject obj) {
//      HashMap<String, Object> map = new HashMap<>();
//      Iterator<String> keys = obj.keys();
//      try {
//        while(keys.hasNext()) {
//          String key = keys.next();
//          Object value = obj.get(key);
//          if(value instanceof JSONArray) {
//            value = toList((JSONArray) value);
//          } else if(value instanceof JSONObject) {
//            value = toMap((JSONObject) value);
//          }
//          map.put(key, value);
//        }
//      } catch (JSONException e) {
//        Log.e(TAG, e.getMessage());
//      }
//      return map;
//    }
//
//    public List<Object> toList(JSONArray arr) {
//      ArrayList<Object> list = new ArrayList<>();
//      try {
//        for(int i = 0; i < arr.length(); i++) {
//          Object value = arr.get(i);
//          if(value instanceof JSONArray) {
//            value = toList((JSONArray) value);
//          } else if(value instanceof JSONObject) {
//            value = toMap((JSONObject) value);
//          }
//          list.add(value);
//        }
//      } catch (JSONException e) {
//        Log.e(TAG, e.getMessage());
//      }
//      return list;
//    }

    
    
    
    
    
    
    
    public func initCaptureID() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        self.previewView = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        initialize(view: previewView!)
    }
    
    private func initialize(view: UIView) {
        self.library = CaptureIDLibrary.init(uIview: view, resultBlock: { (res) -> Void in
            let result = NSMutableDictionary()
            result.setValue("initCaptureID", forKey: "FunctionName")
            result.setValue("", forKey: "error")
            result.setValue(true, forKey: "boolValue")
            result.setValue(0 as CLong, forKey: "longValue")
            result.setValue(0 as CGFloat, forKey: "floatValue")
            result.setValue("", forKey: "objValue")
            let data = NSMutableDictionary()
            data.setValue(result, forKey: "body")
            self._inithandler.send(channel: self.INITHANDLER_ID, event: "initCaptureID", data: data)
        })
    }
    
    private func activateEDKLicense(filename: String, customerID: String) {
        self.library?.activateEDKLicense(filename, customerID: customerID, resultHandler: { (res) -> Void in
            let data: NSMutableDictionary = (res[0] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            self._licensehandler.send(channel: self.LICENSEHANDLER_ID, event: "onActivationResult", data: data)
        })
    }
    
    public func changeBeepPlayerSound(name: String) {
        self.library?.changeSound(name)
    }
    
    public func closeCamera() {
        self.library?.closeCamera()
    }
    
    public func closeSharedObject() {
        self.library?.closeSharedObject()
    }
    
    public func currentSizeOfDecoderVideo() -> [CGSize] {
        return self.library?.currentSizeOfDecoderVideo() as! [CGSize]
//      com.codecorp.util.Size res = _captureid.getCameraScanner().getDecoder().currentSizeOfDecoderVideo();
//      return new Size(res.width, res.height);
    }
    
    public func decoderTimeLimitInMilliseconds(milliseconds: Int32) {
        self.library?.decoderTimeLimit(inMilliseconds: milliseconds)
    }
    
    public func decoderVersion() -> [Any] {
        return self.library!.decoderVersion()
    }
    
    public func decoderVersionLevel() -> [Any] {
        return self.library!.decoderVersionLevel()
    }
    
//    public func doDecode(java.nio.ByteBuffer pixBuf, int width, int height, int stride) {
//      _captureid.getCameraScanner().getDecoder().doDecode(pixBuf, width, height, stride);
//    }
    
    public func enableFixedExposureMode(enabled: Bool, exposureValue: CLong) {
        self.library?.enableFixedExposureMode(enabled)
    }
    
    public func enableScannedImageCapture(enable: Bool) {
        self.library?.enableScannedImageCapture(enable)
    }

    public func ensureRegionOfInterest(enable: Bool) {
        self.library?.ensureRegion(ofInterest: enable)
    }

    public func getCameraPreview() -> [UIView] {
        return self.library?.getCameraPreview() as! [UIView]
    }

//    public func getFixedExposureTime() -> CLong {
//        return self.library.fixed captureid.getCameraScanner().getDecoder().getFixedExposureTime();
//    }

    public func getFocusDistance() -> [Int32] {
        return self.library?.getFocusDistance() as! [Int32]
    }

    private func getMaxZoom() -> [CGFloat] {
        return self.library?.getMaxZoom() as! [CGFloat]
    }

    private func getSdkVersion() -> [String] {
        return self.library?.getSdkVersion() as! [String]
    }

//    private func getSensitivityBoost() {
//        self.library?.getSensitivityBoost()
//      ArrayList<String> tmp = _captureid.getCameraScanner().getDecoder().getSensitivityBoost();
//      List<String> res = new ArrayList<String>();
//      for (Object s : tmp) {
//        res.add(s.toString());
//      }
//      return res;
//    }

//    private ArrayList<Object> getSupportedCameraTypes() {
//      CameraType ct[] = _captureid.getCameraScanner().getDecoder().getSupportedCameraTypes();
//      ArrayList<Object> res = new ArrayList<>();
//      for(CameraType item: ct) {
//        res.add(item);
//      }
//      return res;
//    }
//
//    private ArrayList<Object> getSupportedFocusModes() {
//      Focus fc[] = _captureid.getCameraScanner().getDecoder().getSupportedFocusModes();
//      ArrayList<Object> res = new ArrayList<>();
//      for(Focus item: fc) {
//        res.add(item);
//      }
//      return res;
//    }
//
//    private String[] getSupportedWhiteBalance() {
//      return _captureid.getCameraScanner().getDecoder().getSupportedWhiteBalance();
//    }
//
//    private float[] getZoomRatios() {
//      return _captureid.getCameraScanner().getDecoder().getZoomRatios();
//    }
//
//    private boolean hasTorch() {
//      return _captureid.getCameraScanner().getDecoder().hasTorch();
//    }
//
//    private boolean isLicenseActivated() {
//      return _captureid.getCameraScanner().getDecoder().isLicenseActivated();
//    }
//
//    private boolean isLicenseExpired() {
//      return _captureid.getCameraScanner().getDecoder().isLicenseExpired();
//    }
//
//    private boolean isZoomSupported() {
//      return _captureid.getCameraScanner().getDecoder().isZoomSupported();
//    }
//
//    private String libraryVersion() {
//      return _captureid.getCameraScanner().getDecoder().libraryVersion();
//    }
//
//    private void lowContrastDecodingEnabled(boolean enabled) {
//      if(null != _captureid.getCameraScanner()) {
//        _captureid.getCameraScanner().lowContrastDecodingEnabled(enabled);
//      }
//    }
//
//    private void playBeepSound() {
//      _captureid.getCameraScanner().getDecoder().playBeepSound();
//    }
//
//    private void regionOfInterestHeight(int roiHeight) {
//      _captureid.getCameraScanner().getDecoder().regionOfInterestHeight(roiHeight);
//    }
//
//    private void regionOfInterestLeft(int column) {
//      _captureid.getCameraScanner().getDecoder().regionOfInterestLeft(column);
//    }
//
//    private void regionOfInterestTop(int row) {
//      _captureid.getCameraScanner().getDecoder().regionOfInterestTop(row);
//    }
//
//    private void regionOfInterestWidth(int roiWidth) {
//      _captureid.getCameraScanner().getDecoder().regionOfInterestWidth(roiWidth);
//    }
//
//    private void setAutoFocusResetByCount(boolean mEnabled) {
//      _captureid.getCameraScanner().getDecoder().setAutoFocusResetByCount(mEnabled);
//    }
//
//    private boolean setCameraType(String cameraType) {
//      return _captureid.getCameraScanner().getDecoder().setCameraType(CameraType.valueOf(cameraType));
//    }
//
//    private void setCameraZoom(boolean enabled, float zoom) {
//      _captureid.getCameraScanner().setCameraZoom(enabled, zoom);
//    }
//
//    private void setDecoderResolution(String resolution) {
//      _captureid.getCameraScanner().getDecoder().setDecoderResolution(Resolution.valueOf(resolution));
//    }
//
//    private void setDecoderToleranceLevel(int toleranceLevel) {
//      _captureid.getCameraScanner().getDecoder().setDecoderToleranceLevel(toleranceLevel);
//    }
//
//    private void setEncodingCharsetName(java.lang.String charsetName) {
//      _captureid.getCameraScanner().getDecoder().setEncodingCharsetName(charsetName);
//    }
//
//    private void setExactlyNBarcodes(boolean enable) {
//      _captureid.getCameraScanner().getDecoder().setExactlyNBarcodes(enable);
//    }
//
//    private void setExposureSensitivity(java.lang.String iso) {
//      _captureid.getCameraScanner().getDecoder().setExposureSensitivity(iso);
//    }
//
//    private void setFixedExposureTime(java.lang.Long ep) {
//      _captureid.getCameraScanner().getDecoder().setFixedExposureTime(ep);
//    }
//
//    private boolean setFocus(String focus) {
//      return _captureid.getCameraScanner().getDecoder().setFocus(Focus.valueOf(focus));
//    }
//
//    private void setFocusDistance(float distance) {
//      _captureid.getCameraScanner().getDecoder().setFocusDistance(distance);
//    }
//
//    private void setNumberOfBarcodesToDecode(int num) {
//      _captureid.setNumberOfBarcodesToDecode(num);
//    }
//
//    private void setTorch(boolean on) {
//      _captureid.getCameraScanner().getDecoder().setTorch(on);
//    }
//
//    private void setWhiteBalance(boolean enable, java.lang.String mBalance) {
//      _captureid.getCameraScanner().getDecoder().setWhiteBalance(enable, mBalance);
//    }
//
//    private void setPicklistMode(boolean enable) {
//      _captureid.setPicklistMode(enable);
//    }
//
//    private void startDecoding() {
//      if(null != _captureid.getCameraScanner()) {
//        _captureid.getCameraScanner().startDecoding(_decoder_listener);
//      }
//    }
//
//    private void stopCameraPreview() {
//      _captureid.getCameraScanner().stopCameraPreview();
//    }
//
//    private void stopDecoding() {
//      _captureid.getCameraScanner().stopDecoding();
//    }
//
//    private void toggleCamera() {
//      int cameraidx = 0;
//      CameraType ct[] = _captureid.getCameraScanner().getDecoder().getSupportedCameraTypes();
//      ArrayList<Object> res = new ArrayList<>();
//      for(CameraType item: ct) {
//        res.add(item);
//      }
//      ArrayList cameraTypes = res;
//      if (cameraTypes.size() > 1) {
//        cameraidx = cameraidx < cameraTypes.size() - 1 ? cameraidx + 1 : 0;
//        _captureid.getCameraScanner().getDecoder().setCameraType(ct[cameraidx]);
//      } else {
//        Log.e(TAG, "Can't toogle Camera, only one Camera is supported");
//      }
//    }
//
//    private void setAimStyle(int style, int color_r, int color_g, int color_b) {
//      this._captureid.getCameraScanner().setAimStyle(style, color_r, color_g, color_b);
//    }
//
//    private void setDataOverlayUrl(String url) {
//  //SH        _captureid.getDataLayer().setUrl(url);
//    }
//
//    private void setDataOverlayHtml(String html) {
//  //SH        _captureid.getDataLayer().setHtml(html);
//    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method.elementsEqual("initCaptureID")) {
            initCaptureID()
        } else if(call.method.elementsEqual("activateEDKLicense")) {
            let args = call.arguments as? NSDictionary
            let customer = args!["customerID"]
            let key = args!["key"]
            activateEDKLicense(filename: key as! String, customerID: customer as! String)
        } else if(call.method.elementsEqual("changeBeepPlayerSound")) {
        } else if(call.method.elementsEqual("closeCamera")) {
        } else if(call.method.elementsEqual("closeSharedObject")) {
        } else if(call.method.elementsEqual("currentSizeOfDecoderVideo")) {
        } else if(call.method.elementsEqual("decoderTimeLimitInMilliseconds")) {
        } else if(call.method.elementsEqual("decoderVersion")) {
            result(self.decoderVersion())
        } else if(call.method.elementsEqual("decoderVersionLevel")) {
            result(self.decoderVersionLevel())
        } else if(call.method.elementsEqual("enableFixedExposureMode")) {
        } else if(call.method.elementsEqual("enableScannedImageCapture")) {
        } else if(call.method.elementsEqual("ensureRegionOfInterest")) {
        } else if(call.method.elementsEqual("enableAllDecoders")) {
        } else if(call.method.elementsEqual("startCameraPreview")) {
        } else if(call.method.elementsEqual("startDecoding")) {
        } else if(call.method.elementsEqual("stopCameraPreview")) {
        } else if(call.method.elementsEqual("stopDecoding")) {
        } else {
            result("iOS " + UIDevice.current.systemVersion)
        }
    }
}
