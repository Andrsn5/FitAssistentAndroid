package dev.andre.fitassistent.data.api

import dev.andre.fitassistent.data.dto.AuthResponse
import dev.andre.fitassistent.data.dto.LoginRequest
import dev.andre.fitassistent.data.dto.ProfileResponse
import dev.andre.fitassistent.data.dto.RegisterRequest
import retrofit2.Response

class MockApiService : ApiService {
    override suspend fun register(request: RegisterRequest): Response<Unit> {
        return Response.success(Unit)
    }

    override suspend fun login(request: LoginRequest): Response<AuthResponse> {
        return Response.success(
            AuthResponse(
                token = "mock_access_token_12345",
                refreshToken = "mock_refresh_token_67890"
            )
        )
    }

    override suspend fun getProfile(): Response<ProfileResponse> {
        return Response.success(
            ProfileResponse(
                name = "John",
                surname = "Doe",
                weight = 70.0,
                height = 180,
                weeklyBudget = 500.0,
                activityLevel = 1.2
            )
        )
    }
}
