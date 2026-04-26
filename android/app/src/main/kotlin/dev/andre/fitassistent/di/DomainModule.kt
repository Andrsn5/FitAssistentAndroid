package dev.andre.fitassistent.di

import dev.andre.fitassistent.data.impl.AIDelishRepositoryImpl
import dev.andre.fitassistent.data.impl.AuthRepositoryImpl
import dev.andre.fitassistent.domain.repository.AIDelishRepository
import dev.andre.fitassistent.domain.repository.AuthRepository
import org.koin.dsl.module

val domainModule = module {
    single<AuthRepository> {
        AuthRepositoryImpl(
            apiService = get(),
            dao = get(),
            dataStore = get(),
            networkChecker = get(),
            profileEntityMapper = get(),
            profileMapper = get(),
        )
    }

    single<AIDelishRepository> {
        AIDelishRepositoryImpl(
            apiService = get(),
            aiDelishDao = get(),
            profileDao = get(),
            profileEntityMapper = get(),
            aiDelishMapper = get(),
            networkChecker = get(),
        )
    }
}
