package dev.andre.fitassistent.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.TypeConverters

@Entity(tableName = "ai_delish")
@TypeConverters(ListConverter::class)
data class AIDelishEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val products:  List<String>,
    val calories: Double,
    val protein: Double,
    val fats: Double,
    val carbohydrates: Double,
    val cost: Double,
    val createdAt: Long = System.currentTimeMillis()
)