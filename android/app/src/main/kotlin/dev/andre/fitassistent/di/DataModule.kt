package dev.andre.fitassistent.di

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore
import androidx.room.Room
import dev.andre.fitassistent.data.local.AppDatabase
import dev.andre.fitassistent.data.local.ProfileDao
import dev.andre.fitassistent.data.local.ProfileEntityMapper
import org.koin.android.ext.koin.androidApplication
import org.koin.dsl.module

val dataModule = module {
    single<AppDatabase> {
        Room.databaseBuilder(
            androidApplication(),
            AppDatabase::class.java,
            AppDatabase.DATABASE_NAME
        ).fallbackToDestructiveMigration().build()
    }

    single<ProfileDao> { get<AppDatabase>().profileDao() }

    single<ProfileEntityMapper> { ProfileEntityMapper() }

    single<DataStore<Preferences>> {
        androidApplication().applicationContext.dataStore
    }
}

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "app_preferences")
