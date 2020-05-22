package com.yx.plugin.asr;


import android.app.Activity;

import java.util.Map;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;



/**
 *
 * Author by YX, Date on 2020/5/18.
 */
public class AsrPlugin implements MethodChannel.MethodCallHandler,FlutterPlugin,ActivityAware{

    private final static String TAG = "AsrPlugin";
    private ResultStateful resultStateful;
    private AsrManager asrManager;
    private Activity activity;
    private static MethodChannel channel;


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        android.util.Log.i(TAG, "onAttachedToEngine: ");
        channel = new MethodChannel(binding.getBinaryMessenger(),"asr_plugin");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "start":
                resultStateful = ResultStateful.of(result);
                start(methodCall, resultStateful);
                break;
            case "stop":
                stop(methodCall,result);
                break;
            case "cancel":
                cancel(methodCall,result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void start(MethodCall call, ResultStateful result) {
        if (activity == null) {
            Log.e(TAG, "Ignored start, current activity is null.");
            result.error("Ignored start, current activity is null.", null, null);
            return;
        }
        if (getAsrManager() != null) {
            getAsrManager().start(call.arguments instanceof Map ? (Map) call.arguments : null);
        } else {
            Log.e(TAG, "Ignored start, current getAsrManager is null.");
            result.error("Ignored start, current getAsrManager is null.", null, null);
        }
    }

    private void stop(MethodCall call, MethodChannel.Result result) {
        if (asrManager != null) {
            asrManager.stop();
        }
    }

    private void cancel(MethodCall call, MethodChannel.Result result) {
        if (asrManager != null) {
            asrManager.cancel();
        }
    }

    @Nullable
    private AsrManager getAsrManager() {
        if (asrManager == null) {
            if (activity != null && !activity.isFinishing()) {
                asrManager = new AsrManager(activity, onAsrListener);
            }
        }
        return asrManager;
    }

    private OnAsrListener onAsrListener = new OnAsrListener() {
        @Override
        public void onAsrReady() {

        }

        @Override
        public void onAsrBegin() {

        }

        @Override
        public void onAsrEnd() {

        }

        @Override
        public void onAsrPartialResult(String[] results, RecogResult recogResult) {

        }

        @Override
        public void onAsrOnlineNluResult(String nluResult) {

        }

        @Override
        public void onAsrFinalResult(String[] results, RecogResult recogResult) {
            if (resultStateful != null) {
                resultStateful.success(results[0]);
            }
        }

        @Override
        public void onAsrFinish(RecogResult recogResult) {

        }

        @Override
        public void onAsrFinishError(int errorCode, int subErrorCode, String descMessage, RecogResult recogResult) {
            if (resultStateful != null) {
                resultStateful.error(descMessage, null, null);
            }
        }

        @Override
        public void onAsrLongFinish() {

        }

        @Override
        public void onAsrVolume(int volumePercent, int volume) {

        }

        @Override
        public void onAsrAudio(byte[] data, int offset, int length) {

        }

        @Override
        public void onAsrExit() {

        }

        @Override
        public void onOfflineLoaded() {

        }

        @Override
        public void onOfflineUnLoaded() {

        }
    };

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }
}
