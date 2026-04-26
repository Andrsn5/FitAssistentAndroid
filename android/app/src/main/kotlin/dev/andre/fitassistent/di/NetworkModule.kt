package dev.andre.fitassistent.di

import dev.andre.fitassistent.BuildConfig
import dev.andre.fitassistent.data.api.ApiService
import dev.andre.fitassistent.data.api.AuthInterceptor
import dev.andre.fitassistent.data.api.MockApiService
import dev.andre.fitassistent.util.NetworkChecker
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import org.koin.android.ext.koin.androidApplication
import org.koin.dsl.module
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import java.util.concurrent.TimeUnit

val networkModule = module {
    single { NetworkChecker(androidApplication()) }

    single<HttpLoggingInterceptor> {
        HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        }
    }

    single { AuthInterceptor(get()) }

    single<OkHttpClient> {
        OkHttpClient.Builder()
            .connectTimeout(10, TimeUnit.SECONDS)
            .readTimeout(10, TimeUnit.SECONDS)
            .writeTimeout(10, TimeUnit.SECONDS)
            .addInterceptor(get<AuthInterceptor>())
            .apply {
                if (BuildConfig.DEBUG) addInterceptor(get<HttpLoggingInterceptor>())
            }
            .build()
    }

    single<Retrofit> {
        val json = kotlinx.serialization.json.Json { ignoreUnknownKeys = true }
        val contentType = "application/json".toMediaType()
        Retrofit.Builder()
            .baseUrl(BuildConfig.BASE_URL)
            .client(get())
            .addConverterFactory(json.asConverterFactory(contentType))
            .build()
    }

    single<ApiService> { MockApiService() }
}
