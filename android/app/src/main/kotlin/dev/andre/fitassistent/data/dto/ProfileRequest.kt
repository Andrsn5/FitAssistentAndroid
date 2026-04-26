package dev.andre.fitassistent.data.dto

import kotlinx.serialization.Serializable

@Serializable
data class ProfileRequest(
    val name: String,
    val surname: String,
    val weight: Double,
    val height: Int,
    val weeklyBudget: Double,
    val activityLevel: Double
)