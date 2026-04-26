package dev.andre.fitassistent.domain.repository


import dev.andre.fitassistent.data.dto.RegisterRequest
import dev.andre.fitassistent.domain.model.Profile

interface AuthRepository {
    suspend fun register(request: RegisterRequest): Result<Unit>
    suspend fun login(email: String, password: String): Result<Unit>
    suspend fun getProfile(): Result<Profile>
}