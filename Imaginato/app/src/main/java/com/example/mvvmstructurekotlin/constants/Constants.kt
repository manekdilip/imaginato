package com.example.mvvmstructurekotlin.constants

object Constants {

    var IMEI = ""
    var IMSI = ""

    const val baseURL = "http://private-222d3-homework5.apiary-mock.com/api/"

    const val OK: String = "ok"
    const val TEXT_MESSAGES: String = "TEXT_MESSAGES"

    object REQUEST_PRMS {
        const val username = "username"
        const val password = "password"
    }

    object HTTP_STATUS {
        const val OK = "00"
        const val NOTFOUND = "404"
    }
}