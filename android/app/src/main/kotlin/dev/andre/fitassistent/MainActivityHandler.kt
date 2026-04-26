package dev.andre.fitassistent

import dev.andre.fitassistent.data.dto.RegisterRequest
import dev.andre.fitassistent.domain.repository.AuthRepository
import dev.andre.fitassistent.util.NoInternetException
import io.flutter.plugin.common.MethodCall
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

    fun handleRegister(call: MethodCall, result: MethodChannel.Result) {
        val email = call.argument<String>("email") ?: return result.error("INVALID_ARGS", "email is null", null)
        val password = call.argument<String>("password") ?: return result.error("INVALID_ARGS", "password is null", null)
        val firstName = call.argument<String>("firstName") ?: return result.error("INVALID_ARGS", "firstName is null", null)
        val lastName = call.argument<String>("lastName") ?: return result.error("INVALID_ARGS", "lastName is null", null)
        val weight = call.argument<Double>("weight") ?: return result.error("INVALID_ARGS", "weight is null", null)
        val height = call.argument<Int>("height") ?: return result.error("INVALID_ARGS", "height is null", null)
        val birthDate = call.argument<String>("birthDate") ?: return result.error("INVALID_ARGS", "birthDate is null", null)
        val gender = call.argument<String>("gender") ?: return result.error("INVALID_ARGS", "gender is null", null)
        val activityLevel = call.argument<Double>("activityLevel") ?: return result.error("INVALID_ARGS", "activityLevel is null", null)
        val targetId = call.argument<Int>("targetId") ?: return result.error("INVALID_ARGS", "targetId is null", null)
        val weeklyBudget = call.argument<Double>("weeklyBudget") ?: return result.error("INVALID_ARGS", "weeklyBudget is null", null)

        scope.launch {
            val registerResult = authRepository.register(
                RegisterRequest(
                    email = email,
                    password = password,
                    firstName = firstName,
                    lastName = lastName,
                    weight = weight,
                    height = height,
                    birthDate = birthDate,
                    gender = gender,
                    activityLevel = activityLevel,
                    targetId = targetId,
                    weeklyBudget = weeklyBudget
                )
            )
            withContext(Dispatchers.Main) {
                if (registerResult.isSuccess) {
                    result.success(true)
                } else {
                    val error = registerResult.exceptionOrNull()
                    result.error("REGISTER_ERROR", error?.message ?: "Unknown error", null)
                }
            }
        }
    }

    fun handleLogin(call: MethodCall, result: MethodChannel.Result) {
        val email = call.argument<String>("email") ?: return result.error("INVALID_ARGS", "email is null", null)
        val password = call.argument<String>("password") ?: return result.error("INVALID_ARGS", "password is null", null)

        scope.launch {
            val loginResult = authRepository.login(email, password)
            withContext(Dispatchers.Main) {
                if (loginResult.isSuccess) {
                    result.success(true)
                } else {
                    val error = loginResult.exceptionOrNull()
                    result.error("LOGIN_ERROR", error?.message ?: "Unknown error", null)
                }
            }
        }
    }

    fun handleProfile(result: MethodChannel.Result) {
        scope.launch {
            val profileResult = authRepository.getProfile()
            withContext(Dispatchers.Main) {
                if (profileResult.isSuccess) {
                    result.success(profileResult.getOrNull()?.toString())
                } else {
                    val error = profileResult.exceptionOrNull()
                    if (error is NoInternetException) {
                        result.error("NO_INTERNET", "Нет подключения к интернету", null)
                    } else {
                        result.error("PROFILE_ERROR", error?.message ?: "Unknown error", null)
                    }
                }
            }
        }
    }

    fun clear() {
        scope.cancel()
    }
}