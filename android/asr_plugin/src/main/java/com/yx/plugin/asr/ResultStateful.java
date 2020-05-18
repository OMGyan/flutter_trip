package com.yx.plugin.asr;

import androidx.annotation.Nullable;
import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;
/**
 * Author by YX, Date on 2020/5/18.
 */
public class ResultStateful implements MethodChannel.Result {

    private static final String TAG = "AsrPlugin";
    private MethodChannel.Result result;
    private boolean called;

    private ResultStateful(MethodChannel.Result result) {
        this.result = result;
    }

    public static ResultStateful of(MethodChannel.Result result){
        return new ResultStateful(result);
    }
    @Override
    public void success(@Nullable Object o) {
        if(called){
            printError();
            return;
        }
        called = true;
        result.success(0);
    }

    @Override
    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
        if(called){
            printError();
            return;
        }
        called = true;
        result.error(errorCode,errorMessage,errorDetails);
    }

    @Override
    public void notImplemented() {
        if(called){
            printError();
            return;
        }
        called = true;
        result.notImplemented();
    }

    private void printError(){
        Log.e(TAG,"error:result called");
    }
}
