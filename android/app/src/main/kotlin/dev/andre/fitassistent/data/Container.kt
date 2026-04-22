package dev.andre.fitassistent.data

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.preferencesDataStore
import androidx.datastore.preferences.core.Preferences
import androidx.room.Room
import dev.andre.fitassistent.BuildConfig
import dev.andre.fitassistent.data.api.ApiService
import dev.andre.fitassistent.data.local.AppDatabase
import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory

object Container {

    private val okHttp = OkHttpClient.Builder()
        .addInterceptor(
            HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY)
        )
        .build()

    private val contentType = "application/json".toMediaType()
    val json = Json { ignoreUnknownKeys = true }
    private val retrofit = Retrofit.Builder()
        .baseUrl(BuildConfig.BASE_URL)
        .client(okHttp)
        .addConverterFactory(json.asConverterFactory(contentType))
        .build()

    val api: ApiService = retrofit.create(ApiService::class.java)

    private lateinit var appContext: Context

    fun init(context: Context) {
        appContext = context.applicationContext
    }

    private val Context.dataStore by preferencesDataStore(name = "app_preferences")

    val dataStore: DataStore<Preferences> by lazy {
        appContext.dataStore
    }

    val db: AppDatabase by lazy {
        Room.databaseBuilder(appContext, AppDatabase::class.java, "app_database").build()
    }
}