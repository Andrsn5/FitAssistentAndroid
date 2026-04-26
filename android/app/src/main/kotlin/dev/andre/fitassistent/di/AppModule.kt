package dev.andre.fitassistent.di

import dev.andre.fitassistent.MainActivityHandler
import dev.andre.fitassistent.domain.repository.AuthRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import org.koin.dsl.module

val presentationModule = module {
    single {
        MainActivityHandler(
            authRepository = get(),
            aiDelishRepository = get(),
            scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
        )
    }
}
