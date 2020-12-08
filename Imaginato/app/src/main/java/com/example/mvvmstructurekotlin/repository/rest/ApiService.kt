package com.example.mvvmstructurekotlin.repository.rest

import android.util.Log
import com.example.mvvmstructurekotlin.constants.Constants
import com.example.mvvmstructurekotlin.repository.rest.response.AuthTokenResponse
import io.reactivex.Observable
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Response
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Field
import retrofit2.http.FormUrlEncoded
import retrofit2.http.POST
import java.util.concurrent.TimeUnit

/**
 * All the API services are here.
 */
interface ApiService {

    @FormUrlEncoded
    @POST("login")
    fun loginApi(
        @Field(Constants.REQUEST_PRMS.username) _username: String,
        @Field(Constants.REQUEST_PRMS.password) _password: String
    ): Observable<retrofit2.Response<AuthTokenResponse>>

    companion object {
        lateinit var retrofit: Retrofit

        fun create(): ApiService {

            val httpLogger = HttpLoggingInterceptor()
            httpLogger.setLevel(HttpLoggingInterceptor.Level.BODY)

            val timeout = TimeUnit.SECONDS.toSeconds(100)

            val client = OkHttpClient.Builder()
            client.readTimeout(timeout, TimeUnit.SECONDS)
            client.writeTimeout(timeout, TimeUnit.SECONDS)
            client.connectTimeout(timeout, TimeUnit.SECONDS)

            val headerInterceptor = object : Interceptor {
                override fun intercept(chain: Interceptor.Chain): Response {
                    var request = chain.request()
                   /* request = request.newBuilder().addHeader(
                        "X-Acc",
                        "eyJhbGciOiJSUzUxMiJ9.eyJDUE4iOiJZIiwibGFzdExvZ2luIjoiMDMgQXByaWwgMjAxOCAxOTozODoxMyIsImxsZXYiOiJIbWFjU0hBNTEyIiwiaXAiOiI5Mi4zOC4xMzAuMTAwIiwiaXNzIjoiYmUqKipvIiwiZm4iOiJCcm8gQmVydGhvIiwiZmNpcyI6IlkiLCJsb2dpbiI6IiIsImZ0IjoiWSIsImZmbiI6Ik4iLCJzZCI6IjE1MjI4MDU0OTA3NTgiLCJwbG4iOiJKR2dMTUlFOHBwcktaRFZJejB6OUZBPT0iLCJmZnQiOiJOIiwidXNydHAiOiJOIiwic2siOiJmMDVjMmRkOGZkYTYzNzYyYmE2NzUwYmQ3OTc3ZTQ0Y2QwM2ZiOTBkNzY3MDU3NDZhZjk4YjgxOGMyMzBhZjIzIiwiZXhwIjoxNTIyODA2MDkwLCJqdGkiOiI3NDlhZDU4Ni01ZTAyLTRmNzItOWE0MC0wYTk4ODBmYzlkNGMiLCJmdGwiOiJOIn0.Buqs4t-hUnkAh2v3okFKk8JsJ6V6XEcCpU__BaYNgj7Q8plXEJE1728FL05UvU4DRKO6GFagUF9MGx2rqO1Fh-viropeVTKu43zyIpfRqi2d4KhwA-sEQK7_V5sV08bKBgdIwxY9LUfKE5MOIr33Q2i8gZIcUZCG2SL8SmZX3YOe6CEwtWH9Mp4hoUvo0MNhFSwR8inA1YPsm5TqrCQwj05-3FdhH6lm57CvF8uJOzBE-TGxeGaXs0BjN3a4o5lev4qWAa3nS-KEQye3IAzrvyeMNTNKA1KsNsIqgVb3ODrI8yXcPvuTN-YcV9K9JiMaUKNoL_0OV9THBFwHpbUQqw"
                    ).build()*/

                    request = request.newBuilder().addHeader(
                        "IMSI",
                        Constants.IMSI
                    ).build()
                    request = request.newBuilder().addHeader(
                        "IMEI",
                        Constants.IMEI
                    ).build()

                    Log.e("headerInterceptor: ", "")

                    val response = chain.proceed(request)
                    if (response.code == 509) {
                        Log.e("headerInterceptor: ", "return 509")
                        return response
                    } else {
                        return response
                    }
                }
            }

            client.addInterceptor(headerInterceptor)
            client.addInterceptor(httpLogger)

            retrofit = Retrofit.Builder()
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .addConverterFactory(GsonConverterFactory.create())
                .client(client.build())
                .baseUrl(Constants.baseURL)
                .build()

            return retrofit.create(ApiService::class.java)
        }
    }
}
