package dev.andre.fitassistent.data.api

import dev.andre.fitassistent.data.dto.AuthResponse
import dev.andre.fitassistent.data.dto.LoginRequest
import dev.andre.fitassistent.data.dto.ProfileResponse
import dev.andre.fitassistent.data.dto.RegisterRequest
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.POST

interface ApiService {
    @POST("/api/v1/auth/reg")
    suspend fun register(@Body request: RegisterRequest): Response<Unit>

    @POST("/api/v1/auth/login")
    suspend fun login(@Body request: LoginRequest): Response<AuthResponse>

    @GET("/api/v1/profile/me")
    suspend fun getProfile(@Header("Authorization") token: String): Response<ProfileResponse>
}