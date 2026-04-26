package dev.andre.fitassistent.data.api

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.Interceptor
import okhttp3.Response

class AuthInterceptor(
    private val dataStore: DataStore<Preferences>
) : Interceptor {

    private var cachedToken: String? = null

    init {
        CoroutineScope(Dispatchers.IO).launch {
            dataStore.data.collect { preferences ->
                cachedToken = preferences[TOKEN_KEY]
            }
        }
    }

    override fun intercept(chain: Interceptor.Chain): Response {
        val path = chain.request().url.encodedPath

        // Пропускаем auth endpoints
        if (path.contains("/auth/login") || path.contains("/auth/reg")) {
            return chain.proceed(chain.request())
        }

        val token = cachedToken
        val request = if (token != null) {
            chain.request().newBuilder()
                .addHeader("Authorization", "Bearer $token")
                .build()
        } else {
            chain.request()
        }
        return chain.proceed(request)
    }

    companion object {
        private val TOKEN_KEY = stringPreferencesKey("auth_token")
    }
}