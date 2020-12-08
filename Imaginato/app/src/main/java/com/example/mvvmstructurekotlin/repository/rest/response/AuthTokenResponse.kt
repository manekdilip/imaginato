package com.example.mvvmstructurekotlin.repository.rest.response

import com.google.gson.annotations.SerializedName

data class AuthTokenResponse(
    @SerializedName("errorMessage")
    val errorMessage: String,
    @SerializedName("errorCode")
    val status: String,
    @SerializedName("user")
    val user: User

) {
    data class User(
        @SerializedName("userId")
        val userId: String,
        @SerializedName("userName")
        val userName: String
    )
}