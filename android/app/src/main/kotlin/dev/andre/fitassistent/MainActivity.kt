package dev.andre.fitassistent

import android.os.Bundle
import android.util.Log
import dev.andre.fitassistent.data.Container
import dev.andre.fitassistent.data.impl.AuthRepositoryImpl
import dev.andre.fitassistent.data.dto.RegisterRequest
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.runBlocking

private const val TAG = "MainActivity"

class MainActivity : FlutterActivity() {

    private val CHANNEL = "native_api"
    private lateinit var authRepository: AuthRepositoryImpl

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "→ onCreate: Initializing Container")
        Container.init(applicationContext)
        authRepository = AuthRepositoryImpl(
            apiService = Container.api,
            dataStore = Container.dataStore,
            dao = Container.db.profileDao()
        )
        Log.d(TAG, "← onCreate: Container initialized")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d(TAG, "→ configureFlutterEngine: Setting up MethodChannel")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                Log.d(TAG, "→ MethodChannel called: method=${call.method}, args=${call.arguments}")

                when (call.method) {
                    "register" -> {
                        val email = call.argument<String>("email")!!
                        val password = call.argument<String>("password")!!
                        Log.d(TAG, "→ Register: email=$email")

                        val response = runBlocking {
                            authRepository.register(
                                RegisterRequest(
                                    email = email,
                                    password = password,
                                    firstName = "John",
                                    lastName = "Doe",
                                    weight = 70.0,
                                    height = 180,
                                    birthDate = "1990-01-01",
                                    gender = "MALE",
                                    activityLevel = 1.2,
                                    targetId = 1,
                                    weeklyBudget = 500.0
                                )
                            )
                        }

                        Log.d(TAG, "← Register result: isSuccess=${response.isSuccess}, exception=${response.exceptionOrNull()?.message}")
                        result.success(response.isSuccess)
                    }

                    "login" -> {
                        val email = call.argument<String>("email")!!
                        val password = call.argument<String>("password")!!
                        Log.d(TAG, "→ Login: email=$email")

                        val response = runBlocking {
                            authRepository.login(email, password)
                        }

                        val token = response.getOrNull()
                        Log.d(TAG, "← Login result: token=${if (token != null) "exists" else "null"}, error=${response.exceptionOrNull()?.message}")
                        result.success(token?.token)
                    }

                    "profile" -> {
                        Log.d(TAG, "→ Profile requested")
                        val response = runBlocking {
                            authRepository.getProfile()
                        }

                        val profile = response.getOrNull()
                        Log.d(TAG, "← Profile result: profile=${profile?.toString()}, error=${response.exceptionOrNull()?.message}")
                        result.success(profile?.toString())
                    }

                    else -> {
                        Log.w(TAG, "← Unknown method: ${call.method}")
                        result.notImplemented()
                    }
                }
            }
    }
}