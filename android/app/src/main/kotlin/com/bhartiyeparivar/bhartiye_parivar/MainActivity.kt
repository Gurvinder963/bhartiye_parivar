package com.bhartiyeparivar.bhartiye_parivar

import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager;
import android.view.WindowManager.LayoutParams;
import android.os.Bundle;
class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        // Added this line
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);
    }
}
