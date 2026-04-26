package dev.andre.fitassistent.data.validator

import dev.andre.fitassistent.data.dto.DelishResponse

class AIDelishValidator {
    
    fun validateDelishResponse(response: DelishResponse): ValidationResult {
        val errors = mutableListOf<String>()
        
        if (response.products.isEmpty()) {
            errors.add("Products list cannot be empty")
        }
        
        if (response.calories < 0) {
            errors.add("Calories cannot be negative")
        }
        
        if (response.protein < 0) {
            errors.add("Protein cannot be negative")
        }
        
        if (response.fats < 0) {
            errors.add("Fats cannot be negative")
        }
        
        if (response.carbohydrates < 0) {
            errors.add("Carbohydrates cannot be negative")
        }
        
        if (response.cost < 0) {
            errors.add("Cost cannot be negative")
        }
        
        val totalMacros = response.protein + response.fats + response.carbohydrates
        if (totalMacros == 0.0) {
            errors.add("At least one macronutrient must be greater than 0")
        }
        
        return if (errors.isEmpty()) {
            ValidationResult.Success
        } else {
            ValidationResult.Error(errors)
        }
    }
    
    fun validateDelishResponseList(responses: List<DelishResponse>): ValidationResult {
        if (responses.isEmpty()) {
            return ValidationResult.Error(listOf("Response list cannot be empty"))
        }
        
        val allErrors = mutableListOf<String>()
        responses.forEachIndexed { index, response ->
            val result = validateDelishResponse(response)
            if (result is ValidationResult.Error) {
                result.errors.forEach { error ->
                    allErrors.add("Meal plan $index: $error")
                }
            }
        }
        
        return if (allErrors.isEmpty()) {
            ValidationResult.Success
        } else {
            ValidationResult.Error(allErrors)
        }
    }
    
    sealed class ValidationResult {
        data object Success : ValidationResult()
        data class Error(val errors: List<String>) : ValidationResult()
    }
}
