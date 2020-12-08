package com.example.mvvmstructurekotlin.base

import android.app.Dialog
import android.os.Bundle
import android.view.View
import android.view.Window
import androidx.annotation.IdRes
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.example.mvvmstructurekotlin.R
import com.example.mvvmstructurekotlin.constants.Constants
import com.example.mvvmstructurekotlin.repository.RepoModel
import com.example.mvvmstructurekotlin.extensions.isInternetAvailable
import kotlinx.android.synthetic.main.toolbar.*
import org.koin.android.ext.android.inject

open class BaseActivity : AppCompatActivity() {

    private lateinit var mDialog: Dialog
    var isConnected: Boolean = false
    val repo: RepoModel by inject()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        mDialog = Dialog(this)
        mDialog.requestWindowFeature(Window.FEATURE_NO_TITLE)
        mDialog.setContentView(R.layout.progress_loader)
        mDialog.setCancelable(false)
        mDialog.setCanceledOnTouchOutside(false)
//      mDialog.show()
    }

    fun checkInternet(): Boolean {

        val available = isInternetAvailable()
        if (!available) {
            showInternetDialog()
        }
        return available
    }

    /**
     * @param title Title of the toolbar
     * @param isBack true (Set Menu), false (Set Back), null (Hide Icon)
     */

    fun hidetoolbar(ishide: Boolean? = false) {
        if (ishide!!) {
            toolbar.visibility = View.GONE
        }
    }

    internal lateinit var rightIconClick: OnRightIconClick

    fun setRightIconListner(rightIconClick: OnRightIconClick) {
        this.rightIconClick = rightIconClick
    }

    interface OnRightIconClick {
        fun righticonEvent()

    }

    fun addFragment(
        @NonNull fragment: Fragment,
        backStackName: Boolean = false,
        aTAG: String = "",
        @IdRes containerViewId: Int
    ) {

        /*supportFragmentManager
            .beginTransaction()
            .add(containerViewId, fragment)
            .commit()*/

        val transition = supportFragmentManager.beginTransaction()

        if (backStackName)
            transition.addToBackStack(aTAG)

        transition.add(containerViewId, fragment).commit()
    }

    override fun onPause() {
        super.onPause()
        mDialog.let { if (it.isShowing) it.cancel() }
    }

    override fun onDestroy() {
        super.onDestroy()
        mDialog.let { if (it.isShowing) it.cancel() }
    }

    fun showProgressDialog() {
        if (!isFinishing && !mDialog.isShowing) {
            mDialog.show()
        }
    }

    fun dismissProgressDialog() {
        if (mDialog.isShowing) {
            mDialog.dismiss()
        }
    }

    fun showtoast(msg: String) {
//        toast(msg)
    }

    @Synchronized
    fun showDialog(msg: String) {
        val msgDialog = MessageDialog.getInstance()
        val bundle = Bundle()
        bundle.putString(Constants.TEXT_MESSAGES, msg)
        bundle.putString(Constants.OK, "Ok")
        /*  if (!repo.labelPref.LBL_OK.isNullOrBlank()) {
              bundle.putString(Constants.OK,repo.labelPref.LBL_OK)
          } else {
              bundle.putString(Constants.OK,"Ok")
          }*/
        msgDialog.arguments = bundle
        msgDialog.show(supportFragmentManager, "")
        msgDialog.setListener(object : MessageDialog.OnClick {
            override fun set(ok: Boolean) {
                msgDialog.dismiss()
            }
        })
    }

    fun showInternetDialog() {
        val msgDialog = MessageDialog.getInstance()
        val bundle = Bundle()
        bundle.putString(Constants.TEXT_MESSAGES, "Please Check Internet Connection")
        bundle.putString(Constants.OK, "OK")
        msgDialog.arguments = bundle
        msgDialog.show(supportFragmentManager, "")
        msgDialog.setListener(object : MessageDialog.OnClick {
            override fun set(ok: Boolean) {
                msgDialog.dismiss()
            }
        })
    }
}