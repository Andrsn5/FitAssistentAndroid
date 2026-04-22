package dev.andre.fitassistent.domain.model

data class Profile(
    val name: String,
    val surname: String,
    val weight: Double,
    val height: Int,
    val weeklyBudget: Double? = null,
    val activityLevel: Double
)