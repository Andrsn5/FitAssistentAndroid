package dev.andre.fitassistent

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class MainActivity : FlutterActivity(), KoinComponent {

    private val handler: MainActivityHandler by inject()

    private val CHANNEL = "native_api"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "register" ->handler.handleRegister(call, result)
                    "login" -> handler.handleLogin(call, result)
                    "profile" -> handler.handleProfile(result)
                    "getAIDelish" -> handler.handleGetAIDelish( result)
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.clear()
    }
}