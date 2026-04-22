package dev.andre.fitassistent.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "profile")
data class ProfileEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val name: String,
    val surname: String,
    val weight: Double,
    val height: Int,
    val weeklyBudget: Double? = null,
    val activityLevel: Double
)
