package dev.andre.fitassistent.di

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore
import androidx.room.Room
import dev.andre.fitassistent.BuildConfig
import dev.andre.fitassistent.MainActivityHandler
import dev.andre.fitassistent.data.api.ApiService
import dev.andre.fitassistent.data.api.AuthInterceptor
import dev.andre.fitassistent.data.impl.AuthRepositoryImpl
import dev.andre.fitassistent.data.local.AppDatabase
import dev.andre.fitassistent.data.local.ProfileDao
import dev.andre.fitassistent.domain.repository.AuthRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import org.koin.android.ext.koin.androidApplication
import org.koin.dsl.module
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import java.util.concurrent.TimeUnit
import kotlin.coroutines.CoroutineContext

val appModule = module {
    single<AppDatabase> {
        Room.databaseBuilder(
            androidApplication(),
            AppDatabase::class.java,
            AppDatabase.DATABASE_NAME
        ).fallbackToDestructiveMigration().build()
    }

    single<ProfileDao> { get<AppDatabase>().profileDao() }

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

    single<ApiService> { get<Retrofit>().create(ApiService::class.java) }

    single<AuthRepository> {
        AuthRepositoryImpl(
            apiService = get(),
            dao = get(),
            dataStore = get()
        )
    }

    single {
        MainActivityHandler(
            authRepository = get(),
            scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
        )
    }
    single<DataStore<Preferences>> {
        androidApplication().applicationContext.dataStore
    }
}

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "app_preferences")
