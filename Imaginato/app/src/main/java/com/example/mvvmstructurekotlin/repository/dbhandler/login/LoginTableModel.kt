package com.example.mvvmstructurekotlin.repository.dbhandler.login

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "Login")
data class LoginTableModel (

    @ColumnInfo(name = "user_id")
    var userId: String,

    @ColumnInfo(name = "username")
    var username: String,

    @ColumnInfo(name = "x_acc")
    var xAcc: String

) {

    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    var Id: Int? = null

}