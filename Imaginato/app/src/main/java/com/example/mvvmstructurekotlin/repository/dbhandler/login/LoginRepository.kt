package com.example.mvvmstructurekotlin.repository.dbhandler.login


import android.content.Context
import androidx.lifecycle.LiveData

class LoginRepository(val loginDao: DAOAccess) {

    companion object {

        var loginDatabase: LoginDatabase? = null

        var loginTableModel: LiveData<LoginTableModel>? = null

        fun initializeDB(context: Context) : LoginDatabase {
            return LoginDatabase.getDatabaseClient(context)
        }
    }
}