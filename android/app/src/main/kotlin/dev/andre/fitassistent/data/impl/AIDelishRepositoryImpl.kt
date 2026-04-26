package dev.andre.fitassistent.data.impl

import dev.andre.fitassistent.data.api.ApiService
import dev.andre.fitassistent.data.api.MockApiService
import dev.andre.fitassistent.data.dto.DelishResponse
import dev.andre.fitassistent.data.dto.ProfileRequest
import dev.andre.fitassistent.data.local.AIDelishDao
import dev.andre.fitassistent.data.local.AIDelishEntity
import dev.andre.fitassistent.data.local.AIDelishEntityMapper
import dev.andre.fitassistent.data.local.ProfileDao
import dev.andre.fitassistent.data.local.ProfileEntityMapper
import dev.andre.fitassistent.domain.model.AIDelish
import dev.andre.fitassistent.domain.repository.AIDelishRepository
import dev.andre.fitassistent.util.NetworkChecker
import dev.andre.fitassistent.util.NoInternetException
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import kotlin.collections.map

class AIDelishRepositoryImpl(
    private val apiService: MockApiService,
    private val profileDao: ProfileDao,
    private val profileEntityMapper: ProfileEntityMapper,
    private val aiDelishDao: AIDelishDao,
    private val aiDelishMapper: AIDelishEntityMapper,
    private val networkChecker: NetworkChecker
) : AIDelishRepository {

    private val CACHE_EXPIRY_MS = 24 * 60 * 60 * 1000L // 24 hours

    override suspend fun getAIDelish(forceRefresh: Boolean): Result<List<AIDelish>> {
        return runCatching {

            // Проверяем кеш если не форс-рефреш
            if (!forceRefresh) {
                val cached = aiDelishDao.getAllAIDelish()
                if (cached.isNotEmpty()) {
                    val oldestTimestamp = cached.minOfOrNull { it.createdAt } ?: 0L
                    if (System.currentTimeMillis() - oldestTimestamp < CACHE_EXPIRY_MS) {
                        return@runCatching cached.map { aiDelishMapper.toDomain(it) }
                    }
                }
            }

            if (!networkChecker.isOnline()) {
                val cached = aiDelishDao.getAllAIDelish()
                return@runCatching if (cached.isNotEmpty()) {
                    cached.map { aiDelishMapper.toDomain(it) }
                } else {
                    throw NoInternetException()
                }
            }

            // Берём профиль из БД
            val profileRequest = profileDao.getProfileSingle()
                ?.let { profileEntityMapper.toDto(it) }
                ?: throw Exception("Profile not found. Please complete profile setup first.")

            // Запрашиваем с сервера
            val response = apiService.getAIDelish(profileRequest)

            if (response.isSuccessful && response.body() != null) {
                val delishList = response.body()!!

                // Сохраняем в кеш
                aiDelishDao.clearAllAIDelish()
                val entities = delishList.mapIndexed { index, delish ->
                    aiDelishMapper.toEntity(delish, index.toLong())
                }
                aiDelishDao.insertAllAIDelish(entities)

                entities.map { aiDelishMapper.toDomain(it) }
            } else {
                // Сервер вернул ошибку — пробуем кеш
                val cached = aiDelishDao.getAllAIDelish()
                if (cached.isNotEmpty()) {
                    cached.map { aiDelishMapper.toDomain(it) }
                } else {
                    throw Exception("Failed to fetch AIDelish from server and no cache available")
                }
            }
        }
    }
}