package com.yx.plugin.asr;



import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import java.util.ArrayList;
import java.util.Map;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;


/**
 *
 * Author by YX, Date on 2020/5/18.
 */
public class AsrPlugin implements MethodChannel.MethodCallHandler {
    private Activity activity;
    private static final String TAG = "AsrPlugin";
    private AsrManager asrManager;
    private ResultStateful resultStateful;

    public static void registerWith(PluginRegistry.Registrar registrar){
        MethodChannel channel = new MethodChannel(registrar.messenger(),"asr_plugin");
        AsrPlugin instance = new AsrPlugin(registrar);
        channel.setMethodCallHandler(instance);
    }

    private AsrPlugin(PluginRegistry.Registrar registrar){
        this.activity = registrar.activity();
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        initPermission();
        resultStateful = ResultStateful.of(result);
        switch (call.method){
            case "start":
                start(call,resultStateful);
                break;
            case "stop":
                stop(call,resultStateful);
                break;
            case "cancel":
                cancel(call,resultStateful);
                break;
                default:
                    result.notImplemented();
        }

    }

    private void stop(MethodCall call, ResultStateful rs) {
        if(activity==null){
            Log.e(TAG,"Ignored start,current activity is null!");
            rs.error(null,"Ignored start,current activity is null!",null);
            return;
        }
        if(getAsrManager()!=null){
            getAsrManager().stop();
        }else {
            Log.e(TAG,"Ignored start,current AsrManager is null!");
            rs.error(null,"Ignored start,current AsrManager is null!",null);
        }
    }

    private void cancel(MethodCall call, ResultStateful rs) {
        if(activity==null){
            Log.e(TAG,"Ignored start,current activity is null!");
            rs.error(null,"Ignored start,current activity is null!",null);
            return;
        }
        if(getAsrManager()!=null){
            getAsrManager().cancel();
        }else {
            Log.e(TAG,"Ignored start,current AsrManager is null!");
            rs.error(null,"Ignored start,current AsrManager is null!",null);
        }
    }

    private void start(MethodCall call, ResultStateful rs) {
        if(activity==null){
            Log.e(TAG,"Ignored start,current activity is null!");
            rs.error(null,"Ignored start,current activity is null!",null);
            return;
        }
        if(getAsrManager()!=null){
            getAsrManager().start(call.arguments instanceof Map? (Map)call.arguments:null);
        }else {
            Log.e(TAG,"Ignored start,current AsrManager is null!");
            rs.error(null,"Ignored start,current AsrManager is null!",null);
        }
    }

    @Nullable
    public AsrManager getAsrManager() {
        if(asrManager == null){
            if(activity!=null&&activity.isFinishing()){
                asrManager = new AsrManager(activity,onAsrListener);
            }
        }
        return asrManager;
    }

    /**
     * android 6.0 以上需要动态申请权限
     */
    private void initPermission() {
        String permissions[] = {Manifest.permission.RECORD_AUDIO,
                Manifest.permission.ACCESS_NETWORK_STATE,
                Manifest.permission.INTERNET,
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
        };

        ArrayList<String> toApplyList = new ArrayList<String>();

        for (String perm :permissions){
            if (PackageManager.PERMISSION_GRANTED != ContextCompat.checkSelfPermission(activity, perm)) {
                toApplyList.add(perm);
                //进入到这里代表没有权限.

            }
        }
        String tmpList[] = new String[toApplyList.size()];
        if (!toApplyList.isEmpty()){
            ActivityCompat.requestPermissions(activity, toApplyList.toArray(tmpList), 123);
        }

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
            if(resultStateful!=null){
                resultStateful.success(results[0]);
            }

        }

        @Override
        public void onAsrFinish(RecogResult recogResult) {

        }

        @Override
        public void onAsrFinishError(int errorCode, int subErrorCode, String descMessage, RecogResult recogResult) {
            if(resultStateful!=null){
                resultStateful.error(descMessage,null,null);
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
}
