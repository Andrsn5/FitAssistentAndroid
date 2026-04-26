package dev.andre.fitassistent.domain.model

data class AIDelish(
    val id: Long,
    val products: List<String>,
    val calories: Double,
    val protein: Double,
    val fats: Double,
    val carbohydrates: Double,
    val cost: Double
)
