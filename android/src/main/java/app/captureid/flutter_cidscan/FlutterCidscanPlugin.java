package app.captureid.flutter_cidscan;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Application;
import android.content.Context;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.util.Size;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.codecorp.camera.CameraType;
import com.codecorp.camera.Focus;
import com.codecorp.camera.Resolution;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import app.captureid.captureidlibrary.CaptureID;
import app.captureid.captureidlibrary.result.ResultListener;
import app.captureid.captureidlibrary.result.ResultObject;

/** FlutterCidscanPlugin */
public class FlutterCidscanPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener {
  private static final String TAG = FlutterCidscanPlugin.class.getSimpleName();

  private static int REQUESTID = 666;
  private static final String INITHANDLER_ID = "cidscan_init";
  private static final String DECODEHANDLER_ID = "cidscan_decode";
  private static final String LICENSEHANDLER_ID = "cidscan_license";

  private String[] PERMISSIONS = {
          "android.permission.CAMERA",
          "android.permission.INTERNET",
          "android.permission.WRITE_EXTERNAL_STORAGE" };

  public enum Functions {
    FN_UNKNOWN("unkownFunction"),
    FN_ACTIVATE_LICENSE("activateLicense"),
    FN_CAPTURE_CURRENT_IMAGE_IN_BUFFER("captureCurrentImageInBuffer"),
    FN_CHANGE_BEEP_PLAYER_SOUND("changeBeepPlayerSound"),
    FN_CLOSE_CAMERA("closeCamera"),
    FN_CLOSE_SHARED_OBJECT("closeSharedObject"),
    FN_CRD_SET("CRD_Set"),
    FN_CURRENT_SIZE_OF_DECODER_VIDEO("currentSizeOfDecoderVideo"),
    FN_DECODER_TIME_LIMIT_IN_MILLISECONDS("decoderTimeLimitInMilliseconds"),
    FN_DECODER_VERSION("decoderVersion"),
    FN_DECODER_VERSION_LEVEL("decoderVersionLevel"),
    FN_DO_DECODE("doDecode"),
    FN_ENABLE_BEEP_PLAYER("enableBeepPlayer"),
    FN_ENABLE_FIXED_EXPOSURE_MODE("enableFixedExposureMode"),
    FN_ENABLE_SCANNED_IMAGE_CAPTURE("enableScannedImageCapture"),
    FN_ENABLE_VIBRATE_ON_SCAN("enableVibrateOnScan"),
    FN_ENSURE_REGION_OF_INTEREST("ensureRegionOfInterest"),
    FN_GENERATE_DEVICE_ID("generateDeviceID"),
    FN_GET_CAMERA_PREVIEW("getCameraPreview"),
    FN_GET_DECODE_VAL("getDecodeVal"),
    FN_GET_EXPOSUE_TIME("getExposureTime"),
    FN_GET_FOCUS_DISTANCE("getFocusDistance"),
    FN_GET_LICENSED_SYMBOLOGIES("getLicensedSymbologies"),
    FN_GET_MAX_ZOOM("getMaxZoom"),
    FN_GET_SDK_VERSION("getSdkVersion"),
    FN_GET_SENSITIVITY_BOOST("getSensitivityBoost"),
    FN_GET_SIZE_FOR_ROI("getSizeForROI"),
    FN_GET_SUPPORTED_CAMERA_TYPES("getSupportedCameraTypes"),
    FN_GET_SUPPORTED_FOCUS_MODES("getSupportedFocusModes"),
    FN_GET_SUPPORTED_WHITE_BALANCE("getSupportedWhiteBalance"),
    FN_GET_ZOOM_RATIOS("getZoomRatios"),
    FN_HAS_TORCH("hasTorch"),
    FN_IS_LICENSE_ACTIVATED("isLicenseActivated"),
    FN_IS_LICENSE_EXPIRED("isLicenseExpired"),
    FN_IS_ZOOM_SUPPORTED("isZoomSupported"),
    FN_LIBRARY_VERSION("libraryVersion"),
    FN_LOAD_LICENSE_FILE("loadLicenseFile"),
    FN_LOW_CONTRAST_DECODING_ENABLED("lowContrastDecodingEnabled"),
    FN_PLAY_BEEP_SOUND("playBeepSound"),
    FN_REGION_OF_INTEREST_HEIGHT("regionOfInterestHeight"),
    FN_REGION_OF_INTEREST_LEFT("regionOfInterestLeft"),
    FN_REGION_OF_INTEREST_TOP("regionOfInterestTop"),
    FN_REGION_OG_INTEREST_WIDTH("regionOfInterestWidth"),
    FN_SET_AUTOFOCUS_RESET_BY_COUNT("setAutoFocusResetByCount"),
    FN_SET_CALLBACK("setCallback"),
    FN_SET_CAMERA_TYPE("setCameraType"),
    FN_SET_CAMERA_ZOOM("setCameraZoom"),
    FN_SET_DECODER_RESOLUTION("setDecoderResolution"),
    FN_SET_DECODER_TOLERANCE_LEVEL("setDecoderToleranceLevel"),
    FN_SET_ENCODING_CHARSET_NAME("setEncodingCharsetName"),
    FN_SET_EXACTLY_N_BARCODES("setExactlyNBarcodes"),
    FN_SET_EXPOSURE_SENSITIVITY("setExposureSensitivity"),
    FN_SET_EXPOSURE_TIME("setExposureTime"),
    FN_SET_FOCUS("setFocus"),
    FN_SET_FOCUS_DISTANCE("setFocusDistance"),
    FN_SET_LICENSE_CALLBACK("setLicenseCallback"),
    FN_SET_NUMBER_OF_BARCODES_TO_DECODE("setNumberOfBarcodesToDecode"),
    FN_SET_TORCH("setTorch"),
    FN_SET_WHITE_BALANCE("setWhiteBalance"),
    FN_START_CAMERA_PREVIEW("startCameraPreview"),
    FN_START_DECODING("startDecoding"),
    FN_STOP_CAMERA_PREVIEW("stopCameraPreview"),
    FN_STOP_DECODING("stopDecoding"),
    FN_STRING_FROM_SYMBOLOGY_TYPE("stringFromSymbologyType"),
    FN_SET_SYMBOLOGY_PROPERTIES("setSymbologyProperties"),
    FN_SET_CAMERA_BUTTONS("setCameraButtons"),
    FN_SHOW_AIM("showAim"),
    FN_TOGGLE_CAMERA("toggleCamera"),
    FN_ENABLE_NATIVE_ZOOM("enableNativeZoom"),
    FN_ENABLE_SEEKBAR_ZOOM("enableSeekBarZoom"),
    FN_ENABLE_AUGMENTED_REALITY("enableAugmentedReality"),
    FN_AR_SHOW_VISUALIZED_BARCODES("ar_showVisualizeBarcodes"),
    FN_AR_DETECT_BARCODE("ar_detectBarcode"),
    FN_AR_SHOW_DETAILS("ar_showDetails"),
    FN_ENABLE_ALL_DECODERS("enableAllDecoders"),
    FN_ACTIVATE_EDK_LICENSE("activateEDKLicense"),
    FN_INIT_CAPTUREID("initCaptureID"),
    FN_SET_PICKLIST_MODE("setPicklistMode"),
    FN_SET_AIM_STYLE("setAimStyle"),
    FN_REQUEST_PERMISSION("requestPermission"),
    FN_REQUEST_PERMISSIONS("requestPermissions"),
    FN_UPLOAD_FILE("uploadFile"),
    FN_DOWNLOAD_FILE("downloadFile"),
    FN_SET_DATA_OVERLAY_DATA("setDataOverlayData"),
    FN_SET_AIM_SIZE("setAimSize"),
    FN_TAKE_SNAPSHOT("takeSnapshot"),
    FN_START_SCANNER("startScanner"),
    FN_LIST_FILES("listFiles"),
    FN_MOVE_FILE("moveFile"),
    FN_RENAME_FILE("renameFile"),
    FN_DELETE_FILE("deleteFile"),
    FN_SET_DATA_OVERLAY_URL("setDataOverlayUrl"),
    FN_SET_DATA_OVERLAY_HTML("setDataOverlayHtml"),
    FN_STORE_FILE_TO_SMB("storeFileToSMB"),
    FN_START_SPLITSCREEN("startSplitScreen"),
    FN_START_SPLIT_OVERLAY("startSplitOverlay"),
    FN_ENABLE_CONTINUOUS_SCAN("enableContinuousScan");

    private final String name;
    private Functions(String s) { name = s; }
    public boolean equalsName(String otherName) { return name.equals(otherName); }
    public String toString() { return this.name; }
    public static Functions getValueOf(String name) {
      for(Functions itm: values()) {
        if(itm.name.equals(name)) {
          return itm;
        }
      }
      return FN_UNKNOWN;
    }
  }

  private static int STRINGVALUE = 1;
  private static int INTEGERVALUE = 2;
  private static int BOOLEANVALUE = 3;
  private static int DOUBLEVALUE = 4;
  private static int LONGVALUE = 5;


  private static FlutterCidscanPlugin _plugin;

  private InitStreamHandler _inithandler = new InitStreamHandler();
  private LicenseStreamHandler _licensehandler = new LicenseStreamHandler();
  private DecodeStreamHandler _decodehandler = new DecodeStreamHandler();

  private MethodChannel _channel;
  private EventChannel _initChannel;
  private EventChannel _licenseChannel;
  private EventChannel _decodeChannel;
//
//  private Result _initCallbackContext;
//  private Result _licenseCallbackContext;
//  private Result _permCallbackContext = null;
//  private Result _callbackContext;

  private CaptureID _captureid;
  private Context _context;
  private static Activity _activity;

  private boolean _permissionsGranted = false;
  private boolean _usePermissionCallback = false;
//  private boolean _logMode = false;

  // ************************************************ CONSTRUCTORS/DESTRUCTORS *******************************************
  public FlutterCidscanPlugin() { }

  private FlutterCidscanPlugin(FlutterActivity activity, final PluginRegistry.Registrar registrar) {
    FlutterCidscanPlugin._activity = activity;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(final PluginRegistry.Registrar registrar) {
    if (registrar.activity() == null) {
      return;
    }
    Activity activity = registrar.activity();
    Application app = null;
    if (registrar.context() != null) {
      app = (Application) (registrar.context().getApplicationContext());
    }
    registrar
            .platformViewRegistry()
            .registerViewFactory(
                    "app.captureid.captureidlibrary/cidscanview", new CIDScanViewFactory(registrar.messenger()));

    _plugin = new FlutterCidscanPlugin((FlutterActivity) registrar.activity(), registrar);
    _plugin.initialize(registrar.messenger(), activity);
  }

  private void initialize(final BinaryMessenger messenger, final Activity activity) {
    this._activity = (FlutterActivity) activity;
    _initChannel = new EventChannel(messenger, INITHANDLER_ID);
    _initChannel.setStreamHandler(_inithandler);
    _licenseChannel = new EventChannel(messenger, LICENSEHANDLER_ID);
    _licenseChannel.setStreamHandler(_licensehandler);
    _decodeChannel = new EventChannel(messenger, DECODEHANDLER_ID);
    _decodeChannel.setStreamHandler(_decodehandler);

    _channel = new MethodChannel(messenger, "flutter_cidscan");
    _channel.setMethodCallHandler(this);
  }

  private void deinitialize() {
    _activity = null;
    _channel.setMethodCallHandler(null);
    _initChannel.setStreamHandler(null);
    _licenseChannel.setStreamHandler(null);
    _decodeChannel.setStreamHandler(null);
    _channel = null;
  }

// ********************************************* END CONSTRUCTORS/DESTRUCTORS *******************************************

// ************************************************ EVENTHANDLERS *******************************************

  class InitStreamHandler implements StreamHandler {
    private final String TAG = InitStreamHandler.class.getSimpleName();

    private EventChannel.EventSink _sink;

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
      _sink = events;
    }

    @Override
    public void onCancel(Object arguments) {

    }

    private void send(String channel, String event, String data) {
      try {
        JSONObject obj = new JSONObject(data);
        Map<String, Object> map = jsonToMap(obj);
        final Map<String, Object> res = new HashMap<>();
        res.put("channel", channel);
        res.put("event", event);
        res.put("body", map);
        new Handler(Looper.getMainLooper()).post(new Runnable() {
          @Override
          public void run() {
            _sink.success(res);
          }
        });
      } catch (JSONException e) {
        Log.e(TAG, e.getMessage());
      }
    }
  }

  class LicenseStreamHandler implements StreamHandler {
    private final String TAG = LicenseStreamHandler.class.getSimpleName();

    private EventChannel.EventSink _sink;

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
      _sink = events;
    }

    @Override
    public void onCancel(Object arguments) {

    }

    private void send(String channel, String event, String data) {
      try {
        JSONObject obj = new JSONObject(data);
        Map<String, Object> map = jsonToMap(obj);
        final Map<String, Object> res = new HashMap<>();
        res.put("channel", channel);
        res.put("event", event);
        res.put("body", map);
        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
          @Override
          public void run() {
            try {
              _sink.success(res);
            } catch(NullPointerException ex) {
              Log.d(TAG, "licenseStreamHandler :" + ex.getMessage());
            }
          }
        }, 50);
      } catch (JSONException e) {
        Log.e(TAG, e.getMessage());
      }
    }
  }

  class DecodeStreamHandler implements StreamHandler {
    private final String TAG = InitStreamHandler.class.getSimpleName();

    private EventChannel.EventSink _sink;

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
      _sink = events;
    }

    @Override
    public void onCancel(Object arguments) {

    }

    private void send(String channel, String event, String data) {
      try {
        JSONObject obj = new JSONObject(data);
        Map<String, Object> map = jsonToMap(obj);
        final Map<String, Object> res = new HashMap<>();
        res.put("channel", channel);
        res.put("event", event);
        res.put("body", map);
        new Handler(Looper.getMainLooper()).post(new Runnable() {
          @Override
          public void run() {
            _sink.success(res);
          }
        });
      } catch (JSONException e) {
        Log.e(TAG, e.getMessage());
      }
    }
  }
// *********************************************END EVENTHANDLERS *******************************************

// ************************************************ HELPERS *******************************************
  public Map<String, Object> jsonToMap(JSONObject json) {
    Map<String, Object> ret = new HashMap<String, Object>();
    if(json != null) {
      ret = toMap(json);
    }
    return ret;
  }

  public Map<String, Object> toMap(JSONObject obj) {
    HashMap<String, Object> map = new HashMap<>();
    Iterator<String> keys = obj.keys();
    try {
      while(keys.hasNext()) {
        String key = keys.next();
        Object value = obj.get(key);
        if(value instanceof JSONArray) {
          value = toList((JSONArray) value);
        } else if(value instanceof JSONObject) {
          value = toMap((JSONObject) value);
        }
        map.put(key, value);
      }
    } catch (JSONException e) {
      Log.e(TAG, e.getMessage());
    }
    return map;
  }

  public List<Object> toList(JSONArray arr) {
    ArrayList<Object> list = new ArrayList<>();
    try {
      for(int i = 0; i < arr.length(); i++) {
        Object value = arr.get(i);
        if(value instanceof JSONArray) {
          value = toList((JSONArray) value);
        } else if(value instanceof JSONObject) {
          value = toMap((JSONObject) value);
        }
        list.add(value);
      }
    } catch (JSONException e) {
      Log.e(TAG, e.getMessage());
    }
    return list;
  }
// ********************************************* END HELPERS *******************************************

// ************************************************ CAPTUREID LISTENERS *******************************************
  private ResultListener _captureid_listener = new ResultListener() {
    @Override
    public void onResult(ResultObject resultObject) {
      try {
        JSONArray res = resultObject.toJSON();
        JSONObject obj = (JSONObject)res.get(0);
        if(obj.getString("FunctionName").equals("onActivationResult")) {
          _licensehandler.send(LICENSEHANDLER_ID, obj.getString("FunctionName"), obj.toString());
        }
      } catch (JSONException e) {
        e.printStackTrace();
      }
    }
  };

  private ResultListener _decoder_listener = new ResultListener() {
    @Override
    public void onResult(ResultObject resultObject) {
      try {
        JSONArray res = resultObject.toJSON();
        JSONObject obj = (JSONObject)res.get(0);
        _decodehandler.send(DECODEHANDLER_ID, obj.getString("FunctionName"), obj.toString());
      } catch (JSONException e) {
        e.printStackTrace();
      }
    }
  };
// ************************************************ END CAPTUREID LISTENERS *******************************************

// ************************************************ CAPTUREID INIT AND LICENSING *******************************************

  private void sendPermissionError(int idx, String function, String message) {
    if(null != _inithandler) {
      ResultObject res = new ResultObject(function);
      res.setStringValue(message);
      res.setIntValue(idx);
      res.setBoolValue(false);
      _inithandler.send(INITHANDLER_ID, "permissionError", res.toJSON().toString());
    }
  }

  private void sendPermissionSuccess(int idx, String function, String message) {
    if(null != _inithandler) {
      ResultObject res = new ResultObject(function);
      res.setStringValue(message);
      res.setIntValue(idx);
      res.setBoolValue(true);
      _inithandler.send(INITHANDLER_ID, "permissionSuccess", res.toJSON().toString());
    }
  }

  private boolean hasRequiredPermissions() {
    for(String perm: PERMISSIONS){
      if(ContextCompat.checkSelfPermission(_context, perm) == PackageManager.PERMISSION_DENIED) {
        return false;
      }
    }
    return true;
  }

  private void initCaptureIDComponents(boolean requestPermsOnInit) {
    Log.d(TAG, "initialize CaptureID components");
    _captureid = CaptureID.getSharedLibrary(_activity);
    _captureid.addListener(_captureid_listener);
    if(null != _inithandler) {
      ResultObject res = new ResultObject(Functions.FN_INIT_CAPTUREID.toString(), true);
      try {
        JSONObject msg = (JSONObject) ((JSONArray) res.toJSON()).get(0);
        _inithandler.send(INITHANDLER_ID, Functions.FN_INIT_CAPTUREID.toString(), msg.toString());
      } catch(JSONException ex) {
        Log.e(TAG, ex.getMessage());
      }
    } else {
      Log.d(TAG, "initCallback missing. - please apply a valid callback");
    }
  }

  private void askForPermissions(String[] permissions) {
    ResultObject res = new ResultObject("onPermissionCallback");
    res.setObjectValue((ArrayList<Object>)new ArrayList(Arrays.asList(permissions)));
    this._inithandler.send(INITHANDLER_ID, "onPermissionCallback", res.toJSON().toString());
  }

  private void requestPermissions(String[] permissions) {
    boolean result;
    for (String value : permissions) {
      result = (ContextCompat.checkSelfPermission(_context, value) == PackageManager.PERMISSION_GRANTED);
      if (result == false) {
        _activity.requestPermissions(permissions, REQUESTID);
        return;
      }
    }
  }

  public void initCIDScannerLib(MethodCall call) {
    boolean _requestPermsOnInit = call.argument("requestPermsOnInit");
    _usePermissionCallback = call.argument("useCallback");
    String _message = call.argument("message");
    _permissionsGranted = hasRequiredPermissions();
    if(_requestPermsOnInit && !_permissionsGranted) {
      if (_message != null && !_message.equals("")) {
        AlertDialog.Builder ab = new AlertDialog.Builder(_activity);
        ab.setCancelable(false).setMessage(_message)
                .setNeutralButton("Okay", new DialogInterface.OnClickListener() {
                  @Override
                  public void onClick(DialogInterface dialogInterface, int i) {
                    if(_usePermissionCallback) {
                      askForPermissions(PERMISSIONS);
                    } else {
                      requestPermissions(PERMISSIONS);
                    }
                  }
                }).show();
      } else {
        if(!_permissionsGranted) {
          if(_usePermissionCallback) {
            askForPermissions(PERMISSIONS);
          } else {
            requestPermissions(PERMISSIONS);
          }
        } else {
          _permissionsGranted = true;
          initCaptureIDComponents(_requestPermsOnInit);
        }
      }
    } else {
      initCaptureIDComponents(_requestPermsOnInit);
    }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//    _scannerlibrary = CIDScanner.getSharedLibrary(_activity);
//    _scannerlibrary.addListener(_scanner_listener);
//    if(hasRequiredPermissions()) {
//      _scannerlibrary.initialize();
//      result.success(true);
//    } else {
//      _result = result;
//      Log.d(TAG , "Plugin before");
//      if(_activity != null) {
//        ActivityCompat.requestPermissions(_activity, CIDScanner.getRequiredPermissions(), CIDScanner.requestID);
////        _activity.requestPermissions(CIDScanner.getRequiredPermissions(), CIDScanner.requestID);
//      }
////      ActivityCompat.requestPermissions(_activity, CIDScanner.getRequiredPermissions(), CIDScanner.requestID);
//    }
////    if(hasRequiredPermissions()) {
////      _scannerlibrary.initialize();
////      JSObject ret = new JSObject();
////      ret.put("value", "Permissions granted");
////      call.success(ret);
////    } else {
////      saveCall(call);
////      pluginRequestPermissions(CIDScanner.getRequiredPermissions(), CIDScanner.requestID);
////    }
  }
// ************************************************ END CAPTUREID INIT AND LICENSING *******************************************

// ************************************************ CAPTUREID METHODS *******************************************
  private void activateEDKLicense(String filename, String customerID) {
    _captureid.activateEDKLicense(filename, customerID);
  }
  private void changeBeepPlayerSound(String name) {
    _captureid.changeBeepPlayerSound(name);
  }
  private void closeCamera() {
    _captureid.getCameraScanner().getDecoder().closeCamera();
  }
  private void closeSharedObject() {
    _captureid.closeSharedLibrary();
  }
  private Size currentSizeOfDecoderVideo() {
    com.codecorp.util.Size res = _captureid.getCameraScanner().getDecoder().currentSizeOfDecoderVideo();
    return new Size(res.width, res.height);
  }
  private void decoderTimeLimitInMilliseconds(int milliseconds) {
    _captureid.getCameraScanner().getDecoder().decoderTimeLimitInMilliseconds(milliseconds);
  }
  private String decoderVersion() {
    return _captureid.getCameraScanner().getDecoder().decoderVersion();
  }
  private String decoderVersionLevel() {
    return _captureid.getCameraScanner().getDecoder().decoderVersionLevel();
  }
  private void doDecode(java.nio.ByteBuffer pixBuf, int width, int height, int stride) {
    _captureid.getCameraScanner().getDecoder().doDecode(pixBuf, width, height, stride);
  }
  private void enableFixedExposureMode(boolean enabled, java.lang.Long exposureValue) {
    _captureid.getCameraScanner().getDecoder().enableFixedExposureMode(enabled);
  }
  private void enableScannedImageCapture(boolean enable) {
    _captureid.getCameraScanner().getDecoder().enableScannedImageCapture(enable);
  }

  private void ensureRegionOfInterest(boolean enable) {
    _captureid.getCameraScanner().getDecoder().ensureRegionOfInterest(enable);
  }

  private android.view.View getCameraPreview() {
    return _captureid.getCameraScanner().getDecoder().getCameraPreview();
  }

  private long getFixedExposureTime() {
    return _captureid.getCameraScanner().getDecoder().getFixedExposureTime();
  }

  private float[] getFocusDistance() {
    return _captureid.getCameraScanner().getDecoder().getFocusDistance();
  }

/*
   private SymbologyDataList getLicensedSymbologies() {
        SymbologyDataList res = new SymbologyDataList<SymbologyData>();
        SymbologyDataList ls = _captureid.getCameraScanner().getLicensedSymbologies();
        res = ls;
        res.sortBy(SymbologyDataComparator.Order.Name);
        return res;
    }
*/

  private float getMaxZoom() {
    return _captureid.getCameraScanner().getDecoder().getMaxZoom();
  }

  private String getSdkVersion() {
    return _captureid.getCameraScanner().getDecoder().getSdkVersion();
  }

  private List<String> getSensitivityBoost() {
    ArrayList<String> tmp = _captureid.getCameraScanner().getDecoder().getSensitivityBoost();
    List<String> res = new ArrayList<String>();
    for (Object s : tmp) {
      res.add(s.toString());
    }
    return res;
  }

  private Size getSizeForROI() {
//        ArrayList<Object> res = _captureid.getCameraScanner().getDecoder().getSizeForROI();
//        if (res == null)
//            return null;
//        ArrayList tmp = new ArrayList();
//        for (Object ob : res) {
//            tmp.add(ob.toString());
//        }
//        SizeData result = (SizeData) tmp.get(0);
//        return result;
    return null;
  }

  private ArrayList<Object> getSupportedCameraTypes() {
    CameraType ct[] = _captureid.getCameraScanner().getDecoder().getSupportedCameraTypes();
    ArrayList<Object> res = new ArrayList<>();
    for(CameraType item: ct) {
      res.add(item);
    }
    return res;
  }

  private ArrayList<Object> getSupportedFocusModes() {
    Focus fc[] = _captureid.getCameraScanner().getDecoder().getSupportedFocusModes();
    ArrayList<Object> res = new ArrayList<>();
    for(Focus item: fc) {
      res.add(item);
    }
    return res;
  }

  private String[] getSupportedWhiteBalance() {
    return _captureid.getCameraScanner().getDecoder().getSupportedWhiteBalance();
  }

  private float[] getZoomRatios() {
    return _captureid.getCameraScanner().getDecoder().getZoomRatios();
  }

  private boolean hasTorch() {
    return _captureid.getCameraScanner().getDecoder().hasTorch();
  }

  private boolean isLicenseActivated() {
    return _captureid.getCameraScanner().getDecoder().isLicenseActivated();
  }

  private boolean isLicenseExpired() {
    return _captureid.getCameraScanner().getDecoder().isLicenseExpired();
  }

  private boolean isZoomSupported() {
    return _captureid.getCameraScanner().getDecoder().isZoomSupported();
  }

  private String libraryVersion() {
    return _captureid.getCameraScanner().getDecoder().libraryVersion();
  }

  private void lowContrastDecodingEnabled(boolean enabled) {
    if(null != _captureid.getCameraScanner()) {
      _captureid.getCameraScanner().lowContrastDecodingEnabled(enabled);
    }
  }

  private void playBeepSound() {
    _captureid.getCameraScanner().getDecoder().playBeepSound();
  }

  private void regionOfInterestHeight(int roiHeight) {
    _captureid.getCameraScanner().getDecoder().regionOfInterestHeight(roiHeight);
  }

  private void regionOfInterestLeft(int column) {
    _captureid.getCameraScanner().getDecoder().regionOfInterestLeft(column);
  }

  private void regionOfInterestTop(int row) {
    _captureid.getCameraScanner().getDecoder().regionOfInterestTop(row);
  }

  private void regionOfInterestWidth(int roiWidth) {
    _captureid.getCameraScanner().getDecoder().regionOfInterestWidth(roiWidth);
  }

  private void setAutoFocusResetByCount(boolean mEnabled) {
    _captureid.getCameraScanner().getDecoder().setAutoFocusResetByCount(mEnabled);
  }

  private boolean setCameraType(String cameraType) {
    return _captureid.getCameraScanner().getDecoder().setCameraType(CameraType.valueOf(cameraType));
  }

  private void setCameraZoom(boolean enabled, float zoom) {
    _captureid.getCameraScanner().setCameraZoom(enabled, zoom);
  }

  private void setDecoderResolution(String resolution) {
    _captureid.getCameraScanner().getDecoder().setDecoderResolution(Resolution.valueOf(resolution));
  }

  private void setDecoderToleranceLevel(int toleranceLevel) {
    _captureid.getCameraScanner().getDecoder().setDecoderToleranceLevel(toleranceLevel);
  }

  private void setEncodingCharsetName(java.lang.String charsetName) {
    _captureid.getCameraScanner().getDecoder().setEncodingCharsetName(charsetName);
  }

  private void setExactlyNBarcodes(boolean enable) {
    _captureid.getCameraScanner().getDecoder().setExactlyNBarcodes(enable);
  }

  private void setExposureSensitivity(java.lang.String iso) {
    _captureid.getCameraScanner().getDecoder().setExposureSensitivity(iso);
  }

  private void setFixedExposureTime(java.lang.Long ep) {
    _captureid.getCameraScanner().getDecoder().setFixedExposureTime(ep);
  }

  private boolean setFocus(String focus) {
    return _captureid.getCameraScanner().getDecoder().setFocus(Focus.valueOf(focus));
  }

  private void setFocusDistance(float distance) {
    _captureid.getCameraScanner().getDecoder().setFocusDistance(distance);
  }

  private void setNumberOfBarcodesToDecode(int num) {
    _captureid.setNumberOfBarcodesToDecode(num);
  }

  private void setTorch(boolean on) {
    _captureid.getCameraScanner().getDecoder().setTorch(on);
  }

  private void setWhiteBalance(boolean enable, java.lang.String mBalance) {
    _captureid.getCameraScanner().getDecoder().setWhiteBalance(enable, mBalance);
  }

//    private void startScanner(boolean immediate) {
//        _captureid.startScanner(new ResultHandler() {
//            @Override
//            public void onResult(ResultObject resultObject) {
//                PluginResult res = new PluginResult(Status.OK, resultObject.toJSON());
//                _callbackContext.sendPluginResult(res);
//            }
//        }, immediate);
//    }

  private void setPicklistMode(boolean enable) {
    _captureid.setPicklistMode(enable);
  }

  private void startDecoding() {
    if(null != _captureid.getCameraScanner()) {
      _captureid.getCameraScanner().startDecoding(_decoder_listener);
    }
  }

  private void stopCameraPreview() {
    _captureid.getCameraScanner().stopCameraPreview();
  }

  private void stopDecoding() {
    _captureid.getCameraScanner().stopDecoding();
  }

//    private void setCameraButtons(JSONArray buttons) {
//       this.mCameraButtons = new ArrayList<CameraButtons>();
//        try {
//            for (int i = 0; i < buttons.length(); i++) {
//                JSONObject obj = buttons.getJSONObject(i);
//                this.mCameraButtons
//                        .add(new CameraButtons(obj.getInt("index"), obj.getInt("func"), obj.getString("icon"), null));
//            }
//        } catch (JSONException ex) {
//            _callbackContext.error(ex.getMessage());
//        }
//    }

  private void toggleCamera() {
    int cameraidx = 0;
    CameraType ct[] = _captureid.getCameraScanner().getDecoder().getSupportedCameraTypes();
    ArrayList<Object> res = new ArrayList<>();
    for(CameraType item: ct) {
      res.add(item);
    }
    ArrayList cameraTypes = res;
    if (cameraTypes.size() > 1) {
      cameraidx = cameraidx < cameraTypes.size() - 1 ? cameraidx + 1 : 0;
      _captureid.getCameraScanner().getDecoder().setCameraType(ct[cameraidx]);
    } else {
      Log.e(TAG, "Can't toogle Camera, only one Camera is supported");
    }
  }

  private void setAimStyle(int style, int color_r, int color_g, int color_b) {
    this._captureid.getCameraScanner().setAimStyle(style, color_r, color_g, color_b);
  }

  private void setDataOverlayUrl(String url) {
//SH        _captureid.getDataLayer().setUrl(url);
  }

  private void setDataOverlayHtml(String html) {
//SH        _captureid.getDataLayer().setHtml(html);
  }

// **************************************************** PLUGIN OVERRIDES *****************************************

  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    boolean granted = false;
    if (requestCode == REQUESTID) {
      int i = 0;
      for (int r : grantResults) {
        i++;
        if (r == PackageManager.PERMISSION_DENIED) {
          if (_usePermissionCallback) {
            sendPermissionError(grantResults.length - i, "onPermissionDenied", "We need the permission = " + permissions[i - 1]);
          } else {
            sendPermissionError(grantResults.length - i, "onInitError", "We need the permission = " + permissions[i - 1]);
          }
        } else {
          if (grantResults.length == i) {
            if (null == _captureid) {
              initCaptureIDComponents(true);
            }
          }
          if (_usePermissionCallback) {
            sendPermissionSuccess(grantResults.length - i, "onPermissionGranted", permissions[i - 1]);
          } else {
            sendPermissionSuccess(grantResults.length - i, "onInitSuccess", permissions[i - 1]);
          }
        }
      }
    }
    return false;
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(
            "app.captureid.captureidlibrary/cidscanview",
            new CIDScanViewFactory(flutterPluginBinding.getBinaryMessenger()));
    initialize(flutterPluginBinding.getBinaryMessenger(), _activity);
  }

  @Override
  public void onDetachedFromActivity() {
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
      _activity = binding.getActivity();
    _context = _activity.getApplicationContext();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  private void startCameraPreview(final Result result) {
    _captureid.getCameraScanner().startFullScreen(new ResultListener() {
        @Override
        public void onResult(ResultObject resultObject) {
          result.success(true);
        }
      });
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch(Functions.getValueOf(call.method)) {
      case FN_ACTIVATE_EDK_LICENSE:
        String key = call.argument("key");
        String customerID = call.argument("customerID");
        this.activateEDKLicense(key, customerID);
        break;
      case FN_UNKNOWN:
        break;
      case FN_ACTIVATE_LICENSE:
        break;
      case FN_AR_DETECT_BARCODE:
        break;
      case FN_AR_SHOW_DETAILS:
        break;
      case FN_AR_SHOW_VISUALIZED_BARCODES:
        break;
      case FN_CAPTURE_CURRENT_IMAGE_IN_BUFFER:
        break;
      case FN_CHANGE_BEEP_PLAYER_SOUND:
        changeBeepPlayerSound((String)call.argument("sound"));
        break;
      case FN_CLOSE_CAMERA:
        closeCamera();
        break;
      case FN_CLOSE_SHARED_OBJECT:
        closeSharedObject();
        break;
      case FN_CRD_SET:
        break;
      case FN_CURRENT_SIZE_OF_DECODER_VIDEO:
        break;
      case FN_DECODER_TIME_LIMIT_IN_MILLISECONDS:
        break;
      case FN_DECODER_VERSION:
        result.success(decoderVersion());
        break;
      case FN_DECODER_VERSION_LEVEL:
        result.success(decoderVersionLevel());
        break;
      case FN_DELETE_FILE:
        break;
      case FN_DOWNLOAD_FILE:
        break;
      case FN_ENABLE_ALL_DECODERS:
        _captureid.getCameraScanner().enableAllDecoders((boolean)call.argument("enable"));
        result.success(true);
        break;
      case FN_ENABLE_AUGMENTED_REALITY:
        break;
      case FN_DO_DECODE:
        break;
      case FN_ENABLE_BEEP_PLAYER:
        break;
      case FN_ENABLE_CONTINUOUS_SCAN:
        break;
      case FN_ENABLE_FIXED_EXPOSURE_MODE:
        break;
      case FN_ENABLE_NATIVE_ZOOM:
        break;
      case FN_ENABLE_SCANNED_IMAGE_CAPTURE:
        break;
      case FN_ENABLE_SEEKBAR_ZOOM:
        break;
      case FN_ENABLE_VIBRATE_ON_SCAN:
        break;
      case FN_ENSURE_REGION_OF_INTEREST:
        break;
      case FN_GENERATE_DEVICE_ID:
        break;
      case FN_GET_CAMERA_PREVIEW:
        break;
      case FN_GET_DECODE_VAL:
        break;
      case FN_GET_EXPOSUE_TIME:
        break;
      case FN_GET_FOCUS_DISTANCE:
        break;
      case FN_GET_LICENSED_SYMBOLOGIES:
        break;
      case FN_GET_MAX_ZOOM:
        break;
      case FN_GET_SDK_VERSION:
        break;
      case FN_GET_SENSITIVITY_BOOST:
        break;
      case FN_GET_SIZE_FOR_ROI:
        break;
      case FN_GET_SUPPORTED_CAMERA_TYPES:
        break;
      case FN_GET_SUPPORTED_FOCUS_MODES:
        break;
      case FN_GET_SUPPORTED_WHITE_BALANCE:
        break;
      case FN_GET_ZOOM_RATIOS:
        break;
      case FN_HAS_TORCH:
        break;
      case FN_INIT_CAPTUREID:
        initCIDScannerLib(call);
        break;
      case FN_IS_LICENSE_ACTIVATED:
        break;
      case FN_IS_LICENSE_EXPIRED:
        break;
      case FN_IS_ZOOM_SUPPORTED:
        break;
      case FN_LIBRARY_VERSION:
        break;
      case FN_LIST_FILES:
        break;
      case FN_LOAD_LICENSE_FILE:
        break;
      case FN_LOW_CONTRAST_DECODING_ENABLED:
        break;
      case FN_MOVE_FILE:
        break;
      case FN_PLAY_BEEP_SOUND:
        break;
      case FN_REGION_OF_INTEREST_HEIGHT:
        break;
      case FN_REGION_OF_INTEREST_LEFT:
        break;
      case FN_REGION_OF_INTEREST_TOP:
        break;
      case FN_REGION_OG_INTEREST_WIDTH:
        break;
      case FN_RENAME_FILE:
        break;
      case FN_REQUEST_PERMISSION:
        break;
      case FN_REQUEST_PERMISSIONS:
        break;
      case FN_SET_AIM_SIZE:
        break;
      case FN_SET_AIM_STYLE:
        break;
      case FN_SET_AUTOFOCUS_RESET_BY_COUNT:
        break;
      case FN_SET_CALLBACK:
        break;
      case FN_SET_CAMERA_BUTTONS:
        break;
      case FN_SET_CAMERA_TYPE:
        break;
      case FN_SET_CAMERA_ZOOM:
        break;
      case FN_SET_DATA_OVERLAY_DATA:
        break;
      case FN_SET_DATA_OVERLAY_HTML:
        break;
      case FN_SET_DATA_OVERLAY_URL:
        break;
      case FN_SET_DECODER_RESOLUTION:
        break;
      case FN_SET_DECODER_TOLERANCE_LEVEL:
        break;
      case FN_SET_ENCODING_CHARSET_NAME:
        break;
      case FN_SET_EXACTLY_N_BARCODES:
        break;
      case FN_SET_EXPOSURE_SENSITIVITY:
        break;
      case FN_SET_EXPOSURE_TIME:
        break;
      case FN_SET_FOCUS:
        break;
      case FN_SET_FOCUS_DISTANCE:
        break;
      case FN_SET_LICENSE_CALLBACK:
        break;
      case FN_SET_NUMBER_OF_BARCODES_TO_DECODE:
        break;
      case FN_SET_PICKLIST_MODE:
        break;
      case FN_SET_SYMBOLOGY_PROPERTIES:
        break;
      case FN_SET_TORCH:
        setTorch((boolean)call.argument("enable"));
        break;
      case FN_SET_WHITE_BALANCE:
        break;
      case FN_SHOW_AIM:
        break;
      case FN_START_CAMERA_PREVIEW:
        startCameraPreview(result);
        break;
      case FN_START_DECODING:
        startDecoding();
        break;
      case FN_START_SCANNER:
        break;
      case FN_START_SPLIT_OVERLAY:
        break;
      case FN_START_SPLITSCREEN:
        break;
      case FN_STOP_CAMERA_PREVIEW:
        stopCameraPreview();
        result.success(true);
        break;
      case FN_STOP_DECODING:
        stopDecoding();
        result.success(true);
        break;
      case FN_STORE_FILE_TO_SMB:
        break;
      case FN_STRING_FROM_SYMBOLOGY_TYPE:
        break;
      case FN_TAKE_SNAPSHOT:
        break;
      case FN_TOGGLE_CAMERA:
        break;
      case FN_UPLOAD_FILE:
        break;
    }
  }
}
