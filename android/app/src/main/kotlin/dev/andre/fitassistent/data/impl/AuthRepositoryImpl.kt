package dev.andre.fitassistent.data.impl

import android.util.Log
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import dev.andre.fitassistent.data.api.ApiService
import dev.andre.fitassistent.data.dto.AuthResponse
import dev.andre.fitassistent.data.dto.LoginRequest
import dev.andre.fitassistent.data.dto.ProfileResponse
import dev.andre.fitassistent.data.dto.RegisterRequest
import dev.andre.fitassistent.data.local.ProfileDao
import dev.andre.fitassistent.data.local.ProfileEntityMapper
import dev.andre.fitassistent.domain.repository.AuthRepository
import dev.andre.fitassistent.util.NetworkChecker
import dev.andre.fitassistent.util.NoInternetException
import kotlinx.coroutines.flow.first

private const val TAG = "AuthRepository"

class AuthRepositoryImpl(
    private val apiService: ApiService,
    private val dao: ProfileDao,
    private val dataStore: DataStore<Preferences>,
    private val networkChecker: NetworkChecker
) : AuthRepository {
    override suspend fun register(request: RegisterRequest): Result<Unit> {
        if (!networkChecker.isOnline()) {
            return Result.failure(NoInternetException())
        }
        Log.d(TAG, "→ Register START: email=${request.email}")
        return runCatching {
            val response = apiService.register(request)
            if (!response.isSuccessful) {
                val errorBody = response.errorBody()?.string()
                throw Exception("Failed to register ${response.code()} - $errorBody")
            }
        }.onFailure { e ->
            Log.e(TAG, "← Register EXCEPTION: ${e.javaClass.simpleName}: ${e.message}", e)
        }
    }

    override suspend fun login(
        email: String,
        password: String
    ): Result<Unit> {
        if (!networkChecker.isOnline()) {
            return Result.failure(NoInternetException())
        }
        Log.d(TAG, "→ Login START: email=$email")
        return runCatching {
            val request = LoginRequest(email, password)
            Log.d(TAG, "→ Sending login request: email=$email")
            val response = apiService.login(request)
            Log.d(TAG, "← Login response: code=${response.code()}, isSuccessful=${response.isSuccessful}, body=${response.body()}")
            if (!response.isSuccessful || response.body() == null) {
                val errorBody = response.errorBody()?.string()
                Log.e(TAG, "← Login FAILED: code=${response.code()}, errorBody=$errorBody")
                throw Exception("Failed to login ${response.code()} - $errorBody")
            }
            val authResponse: AuthResponse = response.body()!!
            Log.d(TAG, "← Login SUCCESS: token=${authResponse.token.take(20)}...")
            saveToken(authResponse.token)
        }.onFailure { e ->
            Log.e(TAG, "← Login EXCEPTION: ${e.javaClass.simpleName}: ${e.message}", e)
        }
    }

    override suspend fun getProfile(): Result<ProfileResponse> {
        Log.d(TAG, "→ GetProfile START")
        
        // Если нет интернета — возвращаем кеш из БД
        if (!networkChecker.isOnline()) {
            Log.d(TAG, "→ Offline mode — loading from cache")
            val cached = dao.getProfileSingle()
            return if (cached != null) {
                Log.d(TAG, "← Profile loaded from cache")
                Result.success(ProfileEntityMapper().toResponse(cached))
            } else {
                Result.failure(NoInternetException())
            }
        }

        return runCatching {
            val token = getToken()
            Log.d(TAG, "→ Token retrieved: ${if (token != null) "exists" else "NULL"}")
            if (token.isNullOrEmpty()) {
                Log.e(TAG, "→ GetProfile FAILED: No token found")
                throw Exception("No token found")
            }
            Log.d(TAG, "→ Sending profile request with token: Bearer ${token.take(10)}...")
            val response = apiService.getProfile()
            Log.d(TAG, "← Profile response: code=${response.code()}, isSuccessful=${response.isSuccessful}")
            if (!response.isSuccessful || response.body() == null) {
                val errorBody = response.errorBody()?.string()
                Log.e(TAG, "← Profile FAILED: code=${response.code()}, errorBody=$errorBody")
                throw Exception("Failed to get profile ${response.code()}")
            }
            response.body()!!.also {
                dao.insertProfile(ProfileEntityMapper().toEntity(it))
                Log.d(TAG, "← Profile saved to cache")
            }
        }.onFailure { e ->
            Log.e(TAG, "← Profile EXCEPTION: ${e.javaClass.simpleName}: ${e.message}", e)
        }
    }

    private suspend fun saveToken(token: String) {
        Log.d(TAG, "→ Saving token: ${token.take(20)}...")
        dataStore.edit { preferences ->
            preferences[TOKEN_KEY] = token
        }
        Log.d(TAG, "← Token saved")
    }

    private suspend fun getToken(): String? {
        val token = dataStore.data.first()[TOKEN_KEY]
        Log.d(TAG, "→ Getting token: ${if (token != null) "found" else "not found"}")
        return token
    }

    companion object {
        private val TOKEN_KEY = stringPreferencesKey("auth_token")
    }
}