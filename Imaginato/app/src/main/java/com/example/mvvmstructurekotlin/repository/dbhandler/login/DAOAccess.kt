package com.example.mvvmstructurekotlin.repository.dbhandler.login

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query

@Dao
interface DAOAccess {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertLoginUser(loginTableModel: LoginTableModel)

    @Query("SELECT * FROM Login WHERE Username =:username")
    fun getLoginDetails(username: String?): LiveData<LoginTableModel>

    @Query("SELECT * FROM Login")
    fun getAllLoginDetails(): LiveData<LoginTableModel>
}