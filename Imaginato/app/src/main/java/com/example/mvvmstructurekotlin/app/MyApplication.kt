package com.example.mvvmstructurekotlin.app

import android.app.Application
import com.example.mvvmstructurekotlin.repository.RepoModel
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin
import org.koin.dsl.module

class MyApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        val myModules = module {
            single { RepoModel(this@MyApplication) }
        }

        startKoin {
            // use AndroidLogger as Koin Logger - default Level.INFO
            androidLogger()
            modules(myModules)
        }
    }
}