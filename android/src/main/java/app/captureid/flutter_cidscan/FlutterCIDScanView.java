package app.captureid.flutter_cidscan;

import android.content.Context;
import android.view.View;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;
import app.captureid.captureidlibrary.CIDScanView;

public class FlutterCIDScanView implements PlatformView, MethodCallHandler {
    private final CIDScanView scanview;
    private final MethodChannel methodChannel;

    FlutterCIDScanView(Context context, BinaryMessenger messenger, int id) {
        scanview = CIDScanView.getSharedObject(context);
        methodChannel = new MethodChannel(messenger, "app.captureid.captureidlibrary/cidscanview" + id);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public View getView() {
        return scanview;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "startDecode":
                startDecode(methodCall, result);
                break;
            case "startScanner":
                startScanner(methodCall, result);
                break;
            default:
                result.notImplemented();
        }

    }

    private void startDecode(MethodCall methodCall, MethodChannel.Result result) {
        scanview.startDecode();
        result.success(null);
    }

    private void startScanner(MethodCall methodCall, MethodChannel.Result result) {
        scanview.startScanner();
        result.success(null);
    }

    @Override
    public void dispose() {}
}
