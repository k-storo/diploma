package com.example.ar_navigator

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "test_activity"
    private val CHANNEL_2 = "poc.deeplink.flutter.dev/channel"

    private var startString: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (intent.action == Intent.ACTION_VIEW) {
            Log.d("TAGGERR", "YES YES")
            intent.data?.let {
                startString = it.getQueryParameter("dropoffLocationAddress")
                Log.d("TAGGERR", "YES paramaters $startString")
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(getFlutterEngine()!!.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler { call, result ->
            val intent = Intent(this, HomeActivity::class.java)
            startActivity(intent)
            result.success("ActivityStarted")
        }

        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL_2).setMethodCallHandler { call, result ->
            if (call.method == "initialLink") {
                if (startString != null) {
                    result.success(startString)
                }
            }
        }
    }
}