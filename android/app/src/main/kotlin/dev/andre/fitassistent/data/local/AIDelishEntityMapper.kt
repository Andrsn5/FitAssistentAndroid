package dev.andre.fitassistent.data.local

import dev.andre.fitassistent.data.dto.DelishResponse
import dev.andre.fitassistent.domain.model.AIDelish
import kotlinx.serialization.json.Json

class AIDelishEntityMapper {

    fun toEntity(response: DelishResponse, id: Long = 0): AIDelishEntity {
        return AIDelishEntity(
            id = id,
            products = response.products,
            calories = response.calories,
            protein = response.protein,
            fats = response.fats,
            carbohydrates = response.carbohydrates,
            cost = response.cost,
            createdAt = System.currentTimeMillis()
        )
    }

    fun toDomain(entity: AIDelishEntity): AIDelish {
        return AIDelish(
            id = entity.id,
            products = entity.products,
            calories = entity.calories,
            protein = entity.protein,
            fats = entity.fats,
            carbohydrates = entity.carbohydrates,
            cost = entity.cost
        )
    }
}