package dev.andre.fitassistent.domain.repository

import dev.andre.fitassistent.domain.model.AIDelish

interface AIDelishRepository {
    suspend fun getAIDelish(forceRefresh: Boolean = false): Result<List<AIDelish>>
}