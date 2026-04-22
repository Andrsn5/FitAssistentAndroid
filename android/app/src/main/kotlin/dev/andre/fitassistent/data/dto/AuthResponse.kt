package dev.andre.fitassistent.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class AuthResponse(
    @SerialName("access_token")
    val token: String,
    @SerialName("refresh_token")
    val refreshToken: String
)