package dev.andre.fitassistent.domain.repository

import dev.andre.fitassistent.data.dto.AuthResponse
import dev.andre.fitassistent.data.dto.ProfileResponse
import dev.andre.fitassistent.data.dto.RegisterRequest

interface AuthRepository {
    suspend fun register(request: RegisterRequest): Result<Unit>
    suspend fun login(email: String, password: String): Result<Unit>
    suspend fun getProfile(): Result<ProfileResponse>
}