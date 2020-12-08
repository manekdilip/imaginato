package com.example.mvvmstructurekotlin.viewmodel

import android.view.View
import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import com.example.mvvmstructurekotlin.constants.SingleLiveEvent

abstract class BaseViewModel : ViewModel() {

    //TODO Show Message
    var _message: SingleLiveEvent<String> = SingleLiveEvent()
    var message: LiveData<String> = _message

    //TODO Show Validation Message
    var _validationMessage: SingleLiveEvent<String> = SingleLiveEvent()
    var validationMessage: LiveData<String> = _validationMessage

    //TODO Item Click
    fun onViewClick(view: View) {
        myOnViewClick(view)
    }

    //TODO ItemClick abstract fun...
    abstract fun myOnViewClick(view: View)

}