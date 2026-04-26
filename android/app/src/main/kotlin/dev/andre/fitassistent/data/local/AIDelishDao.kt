package dev.andre.fitassistent.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query

@Dao
interface AIDelishDao {
    @Query("SELECT * FROM ai_delish ORDER BY createdAt DESC")
    suspend fun getAllAIDelish(): List<AIDelishEntity>

    @Query("SELECT * FROM ai_delish WHERE id = :id LIMIT 1")
    suspend fun getAIDelishById(id: Long): AIDelishEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAIDelish(aiDelish: AIDelishEntity): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAllAIDelish(aiDelishList: List<AIDelishEntity>)

    @Query("DELETE FROM ai_delish")
    suspend fun clearAllAIDelish()

    @Query("DELETE FROM ai_delish WHERE createdAt < :timestamp")
    suspend fun deleteOldAIDelish(timestamp: Long)
}
