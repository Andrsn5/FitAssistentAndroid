package dev.andre.fitassistent

import dev.andre.fitassistent.data.dto.RegisterRequest
import dev.andre.fitassistent.domain.repository.AuthRepository
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivityHandler(
    private val authRepository: AuthRepository,
    private val scope: CoroutineScope
) {

    fun handleRegister(
        email: String,
        password: String,
        result: MethodChannel.Result
    ) {
        scope.launch {
            runCatching {
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
            }.onSuccess { response ->
                withContext(Dispatchers.Main) {
                    result.success(response.isSuccess)
                }
            }.onFailure { e ->
                withContext(Dispatchers.Main) {
                    result.error("REGISTER_ERROR", e.message, null)
                }
            }
        }
    }

    fun handleLogin(
        email: String,
        password: String,
        result: MethodChannel.Result
    ) {
        scope.launch {
            runCatching {
                authRepository.login(email, password)
            }.onSuccess { response ->
                withContext(Dispatchers.Main) {
                    result.success(response.getOrNull()?.token)
                }
            }.onFailure { e ->
                withContext(Dispatchers.Main) {
                    result.error("LOGIN_ERROR", e.message, null)
                }
            }
        }
    }

    fun handleProfile(result: MethodChannel.Result) {
        scope.launch {
            runCatching {
                authRepository.getProfile()
            }.onSuccess { response ->
                withContext(Dispatchers.Main) {
                    result.success(response.getOrNull()?.toString())
                }
            }.onFailure { e ->
                withContext(Dispatchers.Main) {
                    result.error("PROFILE_ERROR", e.message, null)
                }
            }
        }
    }

    fun clear() {
        scope.cancel()
    }
}