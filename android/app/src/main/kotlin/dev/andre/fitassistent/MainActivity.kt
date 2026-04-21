package dev.andre.fitassistent

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var counter = 0
    private val CHANNEL = "counter"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Log.d("FLUTTER_NATIVE", "Channel initialized")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                Log.d("FLUTTER_NATIVE", "Method called: ${call.method}")

                when (call.method) {

                    "getCounter" -> {
                        Log.d("FLUTTER_NATIVE", "getCounter -> $counter")
                        result.success(counter)
                    }

                    "incrementCounter" -> {
                        counter++
                        Log.d("FLUTTER_NATIVE", "incrementCounter -> $counter")
                        result.success(counter)
                    }

                    else -> {
                        Log.d("FLUTTER_NATIVE", "Method not implemented")
                        result.notImplemented()
                    }
                }
            }
    }
}
