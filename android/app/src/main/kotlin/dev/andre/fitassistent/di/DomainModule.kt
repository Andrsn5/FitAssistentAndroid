package dev.andre.fitassistent.di

import dev.andre.fitassistent.data.api.ApiService
import dev.andre.fitassistent.data.impl.AuthRepositoryImpl
import dev.andre.fitassistent.data.local.ProfileDao
import dev.andre.fitassistent.data.local.ProfileEntityMapper
import dev.andre.fitassistent.domain.repository.AuthRepository
import org.koin.dsl.module

val domainModule = module {
    single<AuthRepository> {
        AuthRepositoryImpl(
            apiService = get(),
            dao = get(),
            dataStore = get(),
            networkChecker = get(),
            profileEntityMapper = get()
        )
    }
}
