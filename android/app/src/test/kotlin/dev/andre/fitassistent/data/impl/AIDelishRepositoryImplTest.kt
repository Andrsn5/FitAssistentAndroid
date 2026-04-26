package dev.andre.fitassistent.data.impl

import dev.andre.fitassistent.data.api.MockApiService
import dev.andre.fitassistent.data.dto.DelishResponse
import dev.andre.fitassistent.data.dto.ProfileRequest
import dev.andre.fitassistent.data.local.AIDelishDao
import dev.andre.fitassistent.data.local.AIDelishEntity
import dev.andre.fitassistent.data.local.AIDelishEntityMapper
import dev.andre.fitassistent.data.local.ProfileDao
import dev.andre.fitassistent.data.local.ProfileEntity
import dev.andre.fitassistent.data.local.ProfileEntityMapper
import dev.andre.fitassistent.domain.model.AIDelish
import dev.andre.fitassistent.util.NetworkChecker
import dev.andre.fitassistent.util.NoInternetException
import io.mockk.Runs
import io.mockk.coEvery
import io.mockk.coVerify
import io.mockk.every
import io.mockk.just
import io.mockk.mockk
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.resetMain
import kotlinx.coroutines.test.runTest
import kotlinx.coroutines.test.setMain
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.ResponseBody.Companion.toResponseBody
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import retrofit2.Response

@OptIn(ExperimentalCoroutinesApi::class)
class AIDelishRepositoryImplTest {

    private lateinit var aiDelishRepository: AIDelishRepositoryImpl
    private lateinit var apiService: MockApiService
    private lateinit var profileDao: ProfileDao
    private lateinit var profileEntityMapper: ProfileEntityMapper
    private lateinit var aiDelishDao: AIDelishDao
    private lateinit var aiDelishMapper: AIDelishEntityMapper
    private lateinit var networkChecker: NetworkChecker

    private val testDispatcher = UnconfinedTestDispatcher()

    @Before
    fun setup() {
        Dispatchers.setMain(testDispatcher)

        apiService = mockk()
        profileDao = mockk()
        profileEntityMapper = ProfileEntityMapper()
        aiDelishDao = mockk()
        aiDelishMapper = AIDelishEntityMapper()
        networkChecker = mockk()

        aiDelishRepository = AIDelishRepositoryImpl(
            apiService = apiService,
            profileDao = profileDao,
            profileEntityMapper = profileEntityMapper,
            aiDelishDao = aiDelishDao,
            aiDelishMapper = aiDelishMapper,
            networkChecker = networkChecker
        )
    }

    @After
    fun tearDown() {
        Dispatchers.resetMain()
    }

    // ==================== WITH INTERNET ====================

    @Test
    fun `getAIDelish with internet and no cache returns data from API`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        coEvery { aiDelishDao.getAllAIDelish() } returns emptyList()
        
        val profileEntity = ProfileEntity(
            id = 1,
            name = "John",
            surname = "Doe",
            weight = 75.0,
            height = 180,
            weeklyBudget = 2000.0,
            activityLevel = 1.5
        )
        coEvery { profileDao.getProfileSingle() } returns profileEntity
        
        val delishResponse = DelishResponse(
            products = listOf("Куриная грудка (200 грамм)", "Брокколи (150 грамм)"),
            calories = 500.0,
            protein = 60.0,
            fats = 10.0,
            carbohydrates = 50.0,
            cost = 300.0
        )
        val response = Response.success(listOf(delishResponse))
        coEvery { apiService.getAIDelish(any<ProfileRequest>()) } returns response
        coEvery { aiDelishDao.clearAllAIDelish() } just Runs
        coEvery { aiDelishDao.insertAllAIDelish(any()) } just Runs

        // When
        val result = aiDelishRepository.getAIDelish(forceRefresh = false)

        // Then
        assertTrue(result.isSuccess)
        assertEquals(1, result.getOrNull()?.size)
        assertEquals("Куриная грудка (200 грамм)", result.getOrNull()?.get(0)?.products?.get(0))
        coVerify { apiService.getAIDelish(any<ProfileRequest>()) }
        coVerify { aiDelishDao.clearAllAIDelish() }
        coVerify { aiDelishDao.insertAllAIDelish(any()) }
    }

    @Test
    fun `getAIDelish with internet and valid cache returns data from cache`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        
        val cachedEntity = AIDelishEntity(
            id = 1,
            products = listOf("Куриная грудка (200 грамм)", "Брокколи (150 грамм)"),
            calories = 500.0,
            protein = 60.0,
            fats = 10.0,
            carbohydrates = 50.0,
            cost = 300.0,
            createdAt = System.currentTimeMillis() - 1000 // 1 second ago (valid cache)
        )
        coEvery { aiDelishDao.getAllAIDelish() } returns listOf(cachedEntity)

        // When
        val result = aiDelishRepository.getAIDelish(forceRefresh = false)

        // Then
        assertTrue(result.isSuccess)
        assertEquals(1, result.getOrNull()?.size)
        assertEquals("Куриная грудка (200 грамм)", result.getOrNull()?.get(0)?.products?.get(0))
        coVerify(exactly = 0) { apiService.getAIDelish(any<ProfileRequest>()) }
    }

    @Test
    fun `getAIDelish with internet and expired cache fetches from API`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        
        val expiredEntity = AIDelishEntity(
            id = 1,
            products = listOf("Старые продукты"),
            calories = 100.0,
            protein = 10.0,
            fats = 5.0,
            carbohydrates = 10.0,
            cost = 50.0,
            createdAt = System.currentTimeMillis() - (25 * 60 * 60 * 1000)
        )
        coEvery { aiDelishDao.getAllAIDelish() } returns listOf(expiredEntity)
        
        val profileEntity = ProfileEntity(
            id = 1,
            name = "John",
            surname = "Doe",
            weight = 75.0,
            height = 180,
            weeklyBudget = 2000.0,
            activityLevel = 1.5
        )
        coEvery { profileDao.getProfileSingle() } returns profileEntity
        
        val delishResponse = DelishResponse(
            products = listOf("Новые продукты"),
            calories = 600.0,
            protein = 70.0,
            fats = 15.0,
            carbohydrates = 60.0,
            cost = 350.0
        )
        val response = Response.success(listOf(delishResponse))
        coEvery { apiService.getAIDelish(any<ProfileRequest>()) } returns response
        coEvery { aiDelishDao.clearAllAIDelish() } just Runs
        coEvery { aiDelishDao.insertAllAIDelish(any()) } just Runs

        // When
        val result = aiDelishRepository.getAIDelish(forceRefresh = false)

        // Then
        assertTrue(result.isSuccess)
        assertEquals("Новые продукты", result.getOrNull()?.get(0)?.products?.get(0))
        coVerify { apiService.getAIDelish(any<ProfileRequest>()) }
    }

    @Test
    fun `getAIDelish with forceRefresh ignores cache and fetches from API`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        
        val cachedEntity = AIDelishEntity(
            id = 1,
            products = listOf("Кешированные продукты"),
            calories = 100.0,
            protein = 10.0,
            fats = 5.0,
            carbohydrates = 10.0,
            cost = 50.0,
            createdAt = System.currentTimeMillis() - 1000 // Valid cache
        )
        coEvery { aiDelishDao.getAllAIDelish() } returns listOf(cachedEntity)
        
        val profileEntity = ProfileEntity(
            id = 1,
            name = "John",
            surname = "Doe",
            weight = 75.0,
            height = 180,
            weeklyBudget = 2000.0,
            activityLevel = 1.5
        )
        coEvery { profileDao.getProfileSingle() } returns profileEntity
        
        val delishResponse = DelishResponse(
            products = listOf("Свежие продукты"),
            calories = 700.0,
            protein = 80.0,
            fats = 20.0,
            carbohydrates = 70.0,
            cost = 400.0
        )
        val response = Response.success(listOf(delishResponse))
        coEvery { apiService.getAIDelish(any<ProfileRequest>()) } returns response
        coEvery { aiDelishDao.clearAllAIDelish() } just Runs
        coEvery { aiDelishDao.insertAllAIDelish(any()) } just Runs

        // When
        val result = aiDelishRepository.getAIDelish(forceRefresh = true)

        // Then
        assertTrue(result.isSuccess)
        assertEquals("Свежие продукты", result.getOrNull()?.get(0)?.products?.get(0))
        coVerify { apiService.getAIDelish(any<ProfileRequest>()) }
    }

    // ==================== WITHOUT INTERNET ====================

    @Test
    fun `getAIDelish without internet and cached data returns from cache`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns false
        
        val cachedEntity = AIDelishEntity(
            id = 1,
            products = listOf("Кешированные продукты"),
            calories = 500.0,
            protein = 60.0,
            fats = 10.0,
            carbohydrates = 50.0,
            cost = 300.0,
            createdAt = System.currentTimeMillis() - 1000
        )
        coEvery { aiDelishDao.getAllAIDelish() } returns listOf(cachedEntity)

        // When
        val result = aiDelishRepository.getAIDelish(forceRefresh = false)

        // Then
        assertTrue(result.isSuccess)
        assertEquals(1, result.getOrNull()?.size)
        assertEquals("Кешированные продукты", result.getOrNull()?.get(0)?.products?.get(0))
        coVerify(exactly = 0) { apiService.getAIDelish(any<ProfileRequest>()) }
    }

    @Test
    fun `getAIDelish without internet and no cache throws NoInternetException`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns false
        coEvery { aiDelishDao.getAllAIDelish() } returns emptyList()

        // When
        val result = aiDelishRepository.getAIDelish(forceRefresh = false)

        // Then
        assertTrue(result.isFailure)
        assertTrue(result.exceptionOrNull() is NoInternetException)
        coVerify(exactly = 0) { apiService.getAIDelish(any<ProfileRequest>()) }
    }

    // ==================== ERROR SCENARIOS ====================

    @Test
    fun `getAIDelish with internet but no profile throws exception`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        coEvery { aiDelishDao.getAllAIDelish() } returns emptyList()
        coEvery { profileDao.getProfileSingle() } returns null

        // When
        val result = aiDelishRepository.getAIDelish(forceRefresh = false)

        // Then
        assertTrue(result.isFailure)
        assertTrue(result.exceptionOrNull()?.message?.contains("Profile not found") == true)
        coVerify(exactly = 0) { apiService.getAIDelish(any<ProfileRequest>()) }
    }

    @Test
    fun `getAIDelish with internet but API error returns cached data if available`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        coEvery { aiDelishDao.getAllAIDelish() } returns emptyList()
        
        val profileEntity = ProfileEntity(
            id = 1,
            name = "John",
            surname = "Doe",
            weight = 75.0,
            height = 180,
            weeklyBudget = 2000.0,
            activityLevel = 1.5
        )
        coEvery { profileDao.getProfileSingle() } returns profileEntity
        
        val errorBody = "Internal Server Error".toResponseBody("application/json".toMediaTypeOrNull())
        val errorResponse = Response.error<List<DelishResponse>>(500, errorBody)
        coEvery { apiService.getAIDelish(any<ProfileRequest>()) } returns errorResponse
        
        val cachedEntity = AIDelishEntity(
            id = 1,
            products = listOf("Кешированные продукты"),
            calories = 500.0,
            protein = 60.0,
            fats = 10.0,
            carbohydrates = 50.0,
            cost = 300.0,
            createdAt = System.currentTimeMillis() - 1000
        )
        coEvery { aiDelishDao.getAllAIDelish() } returns listOf(cachedEntity)

        // When
        val result = aiDelishRepository.getAIDelish(forceRefresh = false)

        // Then
        assertTrue(result.isSuccess)
        assertEquals("Кешированные продукты", result.getOrNull()?.get(0)?.products?.get(0))
    }

    @Test
    fun `getAIDelish with internet but API error and no cache throws exception`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        coEvery { aiDelishDao.getAllAIDelish() } returns emptyList()
        
        val profileEntity = ProfileEntity(
            id = 1,
            name = "John",
            surname = "Doe",
            weight = 75.0,
            height = 180,
            weeklyBudget = 2000.0,
            activityLevel = 1.5
        )
        coEvery { profileDao.getProfileSingle() } returns profileEntity
        
        val errorBody = "Internal Server Error".toResponseBody("application/json".toMediaTypeOrNull())
        val errorResponse = Response.error<List<DelishResponse>>(500, errorBody)
        coEvery { apiService.getAIDelish(any<ProfileRequest>()) } returns errorResponse
        coEvery { aiDelishDao.getAllAIDelish() } returns emptyList()

        // When
        val result = aiDelishRepository.getAIDelish(forceRefresh = false)

        // Then
        assertTrue(result.isFailure)
        assertTrue(result.exceptionOrNull()?.message?.contains("Failed to fetch") == true)
    }

    @Test
    fun `getAIDelish returns multiple meal plans from API`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        coEvery { aiDelishDao.getAllAIDelish() } returns emptyList()
        
        val profileEntity = ProfileEntity(
            id = 1,
            name = "John",
            surname = "Doe",
            weight = 75.0,
            height = 180,
            weeklyBudget = 2000.0,
            activityLevel = 1.5
        )
        coEvery { profileDao.getProfileSingle() } returns profileEntity
        
        val delishList = listOf(
            DelishResponse(
                products = listOf("Куриная грудка (200 грамм)", "Брокколи (150 грамм)"),
                calories = 500.0,
                protein = 60.0,
                fats = 10.0,
                carbohydrates = 50.0,
                cost = 300.0
            ),
            DelishResponse(
                products = listOf("Творог (200 грамм)", "Гречка (100 грамм)"),
                calories = 600.0,
                protein = 50.0,
                fats = 20.0,
                carbohydrates = 60.0,
                cost = 250.0
            ),
            DelishResponse(
                products = listOf("Рыба (200 грамм)", "Киноа (100 грамм)"),
                calories = 550.0,
                protein = 55.0,
                fats = 15.0,
                carbohydrates = 65.0,
                cost = 350.0
            )
        )
        val response = Response.success(delishList)
        coEvery { apiService.getAIDelish(any<ProfileRequest>()) } returns response
        coEvery { aiDelishDao.clearAllAIDelish() } just Runs
        coEvery { aiDelishDao.insertAllAIDelish(any()) } just Runs

        // When
        val result = aiDelishRepository.getAIDelish(forceRefresh = false)

        // Then
        assertTrue(result.isSuccess)
        assertEquals(3, result.getOrNull()?.size)
        assertEquals("Куриная грудка (200 грамм)", result.getOrNull()?.get(0)?.products?.get(0))
        assertEquals("Творог (200 грамм)", result.getOrNull()?.get(1)?.products?.get(0))
        assertEquals("Рыба (200 грамм)", result.getOrNull()?.get(2)?.products?.get(0))
    }
}
