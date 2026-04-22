package dev.andre.fitassistent.data.dto

import kotlinx.serialization.Serializable

@Serializable
data class RegisterRequest(
    val email: String,
    val password: String,
    val firstName: String,
    val lastName: String,
    val weight: Double,
    val height: Int,
    val birthDate: String,
    val gender: String,
    val activityLevel: Double,
    val targetId: Int,
    val weeklyBudget: Double
)
