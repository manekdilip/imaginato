package com.example.mvvmstructurekotlin.ui

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.telephony.TelephonyManager
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.databinding.DataBindingUtil
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProviders
import com.example.mvvmstructurekotlin.R
import com.example.mvvmstructurekotlin.base.BaseActivity
import com.example.mvvmstructurekotlin.common.ProgressState
import com.example.mvvmstructurekotlin.common.UILoginValidationState
import com.example.mvvmstructurekotlin.constants.Constants
import com.example.mvvmstructurekotlin.constants.Constants.IMEI
import com.example.mvvmstructurekotlin.constants.Constants.IMSI
import com.example.mvvmstructurekotlin.databinding.ActivityLoginBinding
import com.example.mvvmstructurekotlin.extensions.afterTextChanged
import com.example.mvvmstructurekotlin.viewmodel.ViewModelLogin
import com.example.mvvmstructurekotlin.viewmodel.ViewModelLoginFactory

const val READ_PHONE_STATE_CODE: Int = 100

class LoginActivity : BaseActivity() {

    lateinit var binding: ActivityLoginBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = DataBindingUtil.setContentView(
            this,
            R.layout.activity_login
        )

        //TODO Create View ModelFactory
        val vm: ViewModelLogin by lazy {
            ViewModelProviders.of(this, ViewModelLoginFactory(repo))
                .get(ViewModelLogin::class.java)
        }

        binding.loginVM = vm
        binding.lifecycleOwner = this

        addObserver(vm)

        //fetch login details
        /*val loginData = repo.loginDatabase.loginDao.getAllLoginDetails()
        loginData.observe(this, Observer {
            if (it != null) {
                println("LOGIN Id: " + it.Id)
                println("LOGIN userId: " + it.userId)
                println("LOGIN username: " + it.username)
                println("LOGIN token: " + it.xAcc)
            }
        })*/

        binding.edtUsername.afterTextChanged {
            val content = it.toString()
            if (content.isEmpty()) {
                binding.tifUsername.error = resources.getString(R.string.error_empty_username)
            } else if (content.length > 30) {
                binding.tifUsername.error = resources.getString(R.string.error_length_username)
            } else {
                binding.tifUsername.error = null
            }
        }

        binding.edtPassword.afterTextChanged {
            val content = it.toString()
            if (content.isEmpty()) {
                binding.tifPassword.error = resources.getString(R.string.error_empty_password)
            } else if (content.length > 16) {
                binding.tifPassword.error = resources.getString(R.string.error_length_password)
            } else {
                binding.tifPassword.error = null
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val permissions = arrayOf<String>(Manifest.permission.READ_PHONE_STATE)
            if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.READ_PHONE_STATE
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                requestPermissions(permissions, READ_PHONE_STATE_CODE)
            } else {
                getDeviceIds()
            }
        } else {
            getDeviceIds()
        }
    }

    @SuppressLint("MissingPermission")
    private fun getDeviceIds() {
        try {
            val telephonyManager =
                getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

            IMEI = telephonyManager.deviceId
            println("imei: $IMEI")

            IMSI = telephonyManager.subscriberId
            println("msi: $IMSI")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun addObserver(vm: ViewModelLogin) {

        vm._progressDialog.observe(this, Observer {
            when (it) {
                ProgressState.SHOW -> showProgressDialog()
                else -> dismissProgressDialog()
            }
        })

        vm._validation.observe(this, Observer {

            when (it) {
                UILoginValidationState.USERNAME -> if (binding.edtUsername.text!!.isEmpty()) {
                    binding.tifUsername.error = resources.getString(R.string.error_empty_username)
                } else if (binding.edtUsername.text!!.length > 30) {
                    binding.tifUsername.error = resources.getString(R.string.error_length_username)
                }

                UILoginValidationState.PASSWORD -> if (binding.edtPassword.text!!.isEmpty()) {
                    binding.tifPassword.error = resources.getString(R.string.error_empty_password)
                } else if (binding.edtPassword.text!!.length > 16) {
                    binding.tifPassword.error = resources.getString(R.string.error_length_password)
                }
            }
        })

        vm._loginResponse.observe(this, Observer {
            if (it.status == Constants.HTTP_STATUS.OK) {

//                val intent = Intent(this@LoginActivity, MainActivity::class.java)
//                startActivity(intent)
            }
        })
        vm._checkInternet.value = checkInternet()

        vm.message.observe(this, Observer {
            showDialog(it)
        })
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        when (requestCode) {
            READ_PHONE_STATE_CODE -> if (grantResults.isNotEmpty()
                && grantResults[0] == PackageManager.PERMISSION_GRANTED
            ) {
                getDeviceIds()
            }else{
                requestPermissions(permissions, READ_PHONE_STATE_CODE)
            }
        }
    }
}