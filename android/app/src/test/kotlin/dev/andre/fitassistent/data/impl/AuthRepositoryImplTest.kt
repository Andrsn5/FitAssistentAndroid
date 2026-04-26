package dev.andre.fitassistent.data.impl

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import android.util.Log
import dev.andre.fitassistent.data.api.ApiService
import dev.andre.fitassistent.data.dto.AuthResponse
import dev.andre.fitassistent.data.dto.LoginRequest
import dev.andre.fitassistent.data.dto.ProfileResponse
import dev.andre.fitassistent.data.dto.RegisterRequest
import dev.andre.fitassistent.data.local.ProfileDao
import dev.andre.fitassistent.data.local.ProfileEntity
import dev.andre.fitassistent.data.local.ProfileEntityMapper
import dev.andre.fitassistent.util.NetworkChecker
import dev.andre.fitassistent.util.NoInternetException
import io.mockk.Runs
import io.mockk.coEvery
import io.mockk.coVerify
import io.mockk.every
import io.mockk.just
import io.mockk.mockk
import io.mockk.mockkStatic
import io.mockk.unmockkStatic
import junit.framework.TestCase.assertTrue
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
import org.junit.Before
import org.junit.Test
import retrofit2.Response


@OptIn(ExperimentalCoroutinesApi::class)
class AuthRepositoryImplTest {

    private lateinit var authRepository: AuthRepositoryImpl
    private lateinit var apiService: ApiService
    private lateinit var dao: ProfileDao
    private lateinit var dataStore: DataStore<Preferences>
    private lateinit var networkChecker: NetworkChecker
    private lateinit var profileEntityMapper: ProfileEntityMapper

    private val testDispatcher = UnconfinedTestDispatcher()

    @Before
    fun setup() {
        Dispatchers.setMain(testDispatcher)
        mockkStatic(Log::class)
        every { Log.d(any(), any()) } returns 0
        every { Log.e(any(), any()) } returns 0
        every { Log.e(any(), any(), any()) } returns 0

        apiService = mockk()
        dao = mockk()
        dataStore = mockk(relaxed = true)
        networkChecker = mockk()
        profileEntityMapper = ProfileEntityMapper()

        authRepository = AuthRepositoryImpl(
            apiService = apiService,
            dao = dao,
            dataStore = dataStore,
            networkChecker = networkChecker,
            profileEntityMapper = profileEntityMapper
        )
    }

    @After
    fun tearDown() {
        Dispatchers.resetMain()
        unmockkStatic(Log::class)
    }

    // ==================== WITH INTERNET ====================

    @Test
    fun `login with internet returns success`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        val email = "test@example.com"
        val password = "password123"
        val token = "test_token_12345"
        val authResponse = AuthResponse(token, "refresh_token")
        val response = Response.success(authResponse)

        coEvery { apiService.login(any<LoginRequest>()) } returns response

        // When
        val result = authRepository.login(email, password)

        // Then
        assertTrue(result.isSuccess)
        coVerify { apiService.login(LoginRequest(email, password)) }
    }

    @Test
    fun `register with internet returns success`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        val request = RegisterRequest(
            email = "test@example.com",
            password = "password123",
            firstName = "John",
            lastName = "Doe",
            weight = 75.0,
            height = 180,
            birthDate = "1990-01-01",
            gender = "male",
            activityLevel = 1.5,
            targetId = 1,
            weeklyBudget = 2000.0
        )
        val response = Response.success(Unit)

        coEvery { apiService.register(request) } returns response

        // When
        val result = authRepository.register(request)

        // Then
        assertTrue(result.isSuccess)
        coVerify { apiService.register(request) }
    }

    @Test
    fun `getProfile with internet returns profile from API`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        val profileResponse = ProfileResponse(
            name = "John",
            surname = "Doe",
            weight = 75.0,
            height = 180,
            weeklyBudget = 2000.0,
            activityLevel = 1.5
        )
        val response = Response.success(profileResponse)
        val token = "test_token"

        val mockPreferences = mockk<Preferences>(relaxed = true)
        every { mockPreferences[any<Preferences.Key<String>>()] } returns token
        coEvery { dataStore.data } returns kotlinx.coroutines.flow.flowOf(mockPreferences)
        coEvery { apiService.getProfile() } returns response
        coEvery { dao.insertProfile(any<ProfileEntity>()) } just Runs

        // When
        val result = authRepository.getProfile()

        // Then
        assertTrue(result.isSuccess)
        assertEquals("John", result.getOrNull()?.name)
        assertEquals("Doe", result.getOrNull()?.surname)
        coVerify { apiService.getProfile() }
        coVerify { dao.insertProfile(any<ProfileEntity>()) }
    }

    // ==================== WITHOUT INTERNET ====================

    @Test
    fun `login without internet returns NoInternetException`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns false

        // When
        val result = authRepository.login("test@example.com", "password123")

        // Then
        assertTrue(result.isFailure)
        assertTrue(result.exceptionOrNull() is NoInternetException)
        coVerify(exactly = 0) { apiService.login(any<LoginRequest>()) }
    }

    @Test
    fun `register without internet returns NoInternetException`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns false
        val request = RegisterRequest(
            email = "test@example.com",
            password = "password123",
            firstName = "John",
            lastName = "Doe",
            weight = 75.0,
            height = 180,
            birthDate = "1990-01-01",
            gender = "male",
            activityLevel = 1.5,
            targetId = 1,
            weeklyBudget = 2000.0
        )

        // When
        val result = authRepository.register(request)

        // Then
        assertTrue(result.isFailure)
        assertTrue(result.exceptionOrNull() is NoInternetException)
        coVerify(exactly = 0) { apiService.register(any<RegisterRequest>()) }
    }

    @Test
    fun `getProfile without internet and cached profile returns profile from DB`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns false
        val cachedProfile = ProfileEntity(
            id = 1,
            name = "John",
            surname = "Doe",
            weight = 75.0,
            height = 180,
            weeklyBudget = 2000.0,
            activityLevel = 1.5
        )

        coEvery { dao.getProfileSingle() } returns cachedProfile

        // When
        val result = authRepository.getProfile()

        // Then
        assertTrue(result.isSuccess)
        assertEquals("John", result.getOrNull()?.name)
        assertEquals("Doe", result.getOrNull()?.surname)
        coVerify { dao.getProfileSingle() }
        coVerify(exactly = 0) { apiService.getProfile() }
    }

    @Test
    fun `getProfile without internet and no cached profile returns NoInternetException`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns false
        coEvery { dao.getProfileSingle() } returns null

        // When
        val result = authRepository.getProfile()

        // Then
        assertTrue(result.isFailure)
        assertTrue(result.exceptionOrNull() is NoInternetException)
        coVerify { dao.getProfileSingle() }
        coVerify(exactly = 0) { apiService.getProfile() }
    }

    // ==================== ERROR SCENARIOS ====================

    @Test
    fun `login with internet but API error returns failure`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        val errorBody = "Unauthorized".toResponseBody("application/json".toMediaTypeOrNull())
        val errorResponse = Response.error<AuthResponse>(401, errorBody)
        coEvery { apiService.login(any<LoginRequest>()) } returns errorResponse

        // When
        val result = authRepository.login("test@example.com", "password123")

        // Then
        assertTrue(result.isFailure)
        coVerify { apiService.login(any<LoginRequest>()) }
    }

    @Test
    fun `register with internet but API error returns failure`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        val request = RegisterRequest(
            email = "test@example.com",
            password = "password123",
            firstName = "John",
            lastName = "Doe",
            weight = 75.0,
            height = 180,
            birthDate = "1990-01-01",
            gender = "male",
            activityLevel = 1.5,
            targetId = 1,
            weeklyBudget = 2000.0
        )
        val errorBody = "Bad Request".toResponseBody("application/json".toMediaTypeOrNull())
        val errorResponse = Response.error<Unit>(400, errorBody)
        coEvery { apiService.register(request) } returns errorResponse

        // When
        val result = authRepository.register(request)

        // Then
        assertTrue(result.isFailure)
        coVerify { apiService.register(request) }
    }

    @Test
    fun `getProfile with internet but no token returns failure`() = runTest {
        // Given
        every { networkChecker.isOnline() } returns true
        val mockPreferences = mockk<Preferences>(relaxed = true)
        every { mockPreferences[any<Preferences.Key<String>>()] } returns null
        coEvery { dataStore.data } returns kotlinx.coroutines.flow.flowOf(mockPreferences)

        // When
        val result = authRepository.getProfile()

        // Then
        assertTrue(result.isFailure)
        coVerify(exactly = 0) { apiService.getProfile() }
    }
}
