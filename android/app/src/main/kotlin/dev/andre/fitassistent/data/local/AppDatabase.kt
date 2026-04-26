package dev.andre.fitassistent.data.local

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters

@Database(entities = [ProfileEntity::class, AIDelishEntity::class], version = 2)
@TypeConverters( ListConverter::class)
abstract class AppDatabase : RoomDatabase()  {
    abstract fun profileDao(): ProfileDao
    abstract fun aiDelishDao(): AIDelishDao

    companion object{
        const val DATABASE_NAME = "app_database"
    }
}