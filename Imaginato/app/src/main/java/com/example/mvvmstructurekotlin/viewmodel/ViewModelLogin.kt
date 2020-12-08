package com.example.mvvmstructurekotlin.viewmodel

import android.view.View
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.mvvmstructurekotlin.R
import com.example.mvvmstructurekotlin.common.ProgressState
import com.example.mvvmstructurekotlin.common.UILoginValidationState
import com.example.mvvmstructurekotlin.constants.Constants
import com.example.mvvmstructurekotlin.constants.SingleLiveEvent
import com.example.mvvmstructurekotlin.repository.dbhandler.login.LoginTableModel
import com.example.mvvmstructurekotlin.repository.rest.response.AuthTokenResponse
import com.example.mvvmstructurekotlin.repository.RepoModel
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.rxkotlin.subscribeBy
import io.reactivex.schedulers.Schedulers
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class ViewModelLogin(val repo: RepoModel) : BaseViewModel() {

    var _username: SingleLiveEvent<String> = SingleLiveEvent()
    var userame: LiveData<String> = _username

    var _password: SingleLiveEvent<String> = SingleLiveEvent()
    var password: LiveData<String> = _password

    var _progressDialog: MutableLiveData<ProgressState> = MutableLiveData()

    var _validation: MutableLiveData<UILoginValidationState> = MutableLiveData()

    var _loginResponse: MutableLiveData<AuthTokenResponse> = MutableLiveData()

    var _checkInternet: SingleLiveEvent<Boolean> = SingleLiveEvent()

    //TODO Item Click
    override fun myOnViewClick(view: View) {
        when (view.id) {
            R.id.btn_login -> {
                if (userame.value.isNullOrEmpty()) {
                    _validation.value = UILoginValidationState.USERNAME
                } else if (userame.value!!.length > 30) {
                    _validation.value = UILoginValidationState.USERNAME
                } else if (password.value.isNullOrEmpty()) {
                    _validation.value = UILoginValidationState.PASSWORD
                } else if (password.value!!.length > 16) {
                    _validation.value = UILoginValidationState.PASSWORD
                } else {
                    if (_checkInternet.value!!) {

                        loginAPI(
                            userame.value.toString(),
                            password.value.toString()
                        )
                    } else {

                    }
                }
            }
        }
    }

    private fun loginAPI(username: String, password: String) {
        _progressDialog.value = ProgressState.SHOW

        repo.api.loginApi(username, password)
            .subscribeOn(Schedulers.io())
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeBy(
                onNext = {
                    _progressDialog.value = ProgressState.HIDE

                    val headers = it.headers()
                    val xAccToken = headers["X-Acc"]

                    val response = it.body()

                    if (response != null && response.status == Constants.HTTP_STATUS.OK) {
                        _message.value = "Login Successfully"
                        _username.value = ""
                        _password.value = ""
                        CoroutineScope(Dispatchers.IO).launch {
                            val loginDetails =
                                LoginTableModel(
                                    _loginResponse.value!!.user.userId,
                                    _loginResponse.value!!.user.userName,
                                    xAccToken!!
                                )
                            repo.loginDatabase.loginDao.insertLoginUser(loginDetails)
                        }

                        _loginResponse.value = response
                    }
                    println(it)
                },

                onComplete = {
                    _progressDialog.value = ProgressState.HIDE
                    println("Completed")
                },

                onError = {
                    _progressDialog.value = ProgressState.HIDE
                    _message.value = "Something went wrong"
                }
            )
    }

}

//TODO ViewModel Factory Using passing Data like constructor
class ViewModelLoginFactory(var repo: RepoModel) : ViewModelProvider.Factory {
    override fun <T : ViewModel?> create(modelClass: Class<T>): T = ViewModelLogin(
        repo
    ) as T
}