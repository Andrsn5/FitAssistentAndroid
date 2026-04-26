package dev.andre.fitassistent

import android.app.Application
import dev.andre.fitassistent.di.dataModule
import dev.andre.fitassistent.di.domainModule
import dev.andre.fitassistent.di.networkModule
import dev.andre.fitassistent.di.presentationModule
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        startKoin {
            androidContext(this@App)
            modules(
                dataModule,
                networkModule,
                domainModule,
                presentationModule
            )
        }
    }
}