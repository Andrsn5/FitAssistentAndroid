package dev.andre.fitassistent.data.api

import dev.andre.fitassistent.data.dto.AuthResponse
import dev.andre.fitassistent.data.dto.DelishResponse
import dev.andre.fitassistent.data.dto.LoginRequest
import dev.andre.fitassistent.data.dto.ProfileRequest
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

    override suspend fun getAIDelish(request: ProfileRequest): Response<List<DelishResponse>> {
        return Response.success(
            listOf(
                DelishResponse(  // Завтрак
                    products = listOf("Овсяные хлопья (50 грамм)", "Яблоко (150 грамм)", "Мед (10 грамм)"),
                    calories = 350.0,
                    protein = 10.0,
                    fats = 8.0,
                    carbohydrates = 60.0,
                    cost = 120.0
                ),
                DelishResponse(  // Обед
                    products = listOf("Куриная грудка (200 грамм)", "Брокколи (150 грамм)", "Рис (100 грамм)"),
                    calories = 550.0,
                    protein = 45.0,
                    fats = 15.0,
                    carbohydrates = 55.0,
                    cost = 280.0
                ),
                DelishResponse(  // Ужин
                    products = listOf("Рыба (150 грамм)", "Овощи гриль (200 грамм)"),
                    calories = 400.0,
                    protein = 30.0,
                    fats = 18.0,
                    carbohydrates = 20.0,
                    cost = 320.0
                )
            )
        )
    }
}
