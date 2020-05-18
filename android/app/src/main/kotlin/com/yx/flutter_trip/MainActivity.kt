package com.yx.flutter_trip

import androidx.annotation.NonNull
import com.yx.plugin.asr.AsrPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val shimPluginRegistry = ShimPluginRegistry(flutterEngine)
        AsrPlugin.registerWith(shimPluginRegistry.registrarFor("com.yx.plugin.asr.AsrPlugin"))
    }

}
