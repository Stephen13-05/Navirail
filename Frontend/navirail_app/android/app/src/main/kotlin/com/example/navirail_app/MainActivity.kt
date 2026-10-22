package com.example.navirail_app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "ar_nav_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "start_ar_navigation" -> {
                        val path = call.argument<List<String>>("path")
                        if (path == null || path.isEmpty()) {
                            result.error("INVALID_PATH", "Path is null or empty", null)
                            return@setMethodCallHandler
                        }

                        val intent = Intent(this, ArNavigationActivity::class.java).apply {
                            putStringArrayListExtra(
                                ArNavigationActivity.EXTRA_PATH,
                                ArrayList(path)
                            )
                        }
                        startActivity(intent)
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
