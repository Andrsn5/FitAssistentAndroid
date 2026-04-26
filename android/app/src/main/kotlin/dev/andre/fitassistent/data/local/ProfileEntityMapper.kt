package dev.andre.fitassistent.data.local

import dev.andre.fitassistent.data.dto.ProfileResponse
import dev.andre.fitassistent.domain.model.Profile

class ProfileEntityMapper {
    fun toEntity(dto : ProfileResponse): ProfileEntity = ProfileEntity(
        name = dto.name,
        surname = dto.surname,
        weight = dto.weight,
        height = dto.height,
        weeklyBudget = dto.weeklyBudget,
        activityLevel = dto.activityLevel
    )

    fun toDomain(entity: ProfileEntity): Profile = Profile(
        name = entity.name,
        surname = entity.surname,
        weight = entity.weight,
        height = entity.height,
        weeklyBudget = entity.weeklyBudget,
        activityLevel = entity.activityLevel
    )

    fun toDto(dto: ProfileResponse): ProfileEntity = ProfileEntity(
        name = dto.name,
        surname = dto.surname,
        weight = dto.weight,
        height = dto.height,
        weeklyBudget = dto.weeklyBudget,
        activityLevel = dto.activityLevel
    )

    fun toResponse(entity: ProfileEntity): ProfileResponse = ProfileResponse(
        name = entity.name,
        surname = entity.surname,
        weight = entity.weight,
        height = entity.height,
        weeklyBudget = entity.weeklyBudget,
        activityLevel = entity.activityLevel
    )

}