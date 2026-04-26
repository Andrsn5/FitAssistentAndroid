package dev.andre.fitassistent.data.dto

import kotlinx.serialization.Serializable

@Serializable
data class DelishResponse (
    val products: List<String>,
    val calories: Double,
    val protein: Double,
    val fats: Double,
    val carbohydrates: Double,
    val cost: Double
)