package dev.andre.fitassistent.data.dto

import androidx.room.PrimaryKey
import kotlinx.serialization.Serializable

@Serializable
data class ProfileResponse(
    val name: String,
    val surname: String,
    val weight: Double,
    val height: Int,
    val weeklyBudget: Double? = null,
    val activityLevel: Double
)