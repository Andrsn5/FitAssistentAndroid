package dev.andre.fitassistent.data.mapper

import dev.andre.fitassistent.data.dto.ProfileResponse
import dev.andre.fitassistent.domain.model.Profile

class ProfileMapper {
    fun toDomain(profileEntity: ProfileResponse): Profile = Profile(
        name = profileEntity.name,
        surname = profileEntity.surname,
        weight = profileEntity.weight,
        height = profileEntity.height,
        weeklyBudget = profileEntity.weeklyBudget ?: 0.0,
        activityLevel = profileEntity.activityLevel
    )
}