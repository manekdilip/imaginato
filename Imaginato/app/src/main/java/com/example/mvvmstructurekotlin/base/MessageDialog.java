package com.example.mvvmstructurekotlin.base;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;

import com.example.mvvmstructurekotlin.R;
import com.example.mvvmstructurekotlin.constants.Constants;

public class MessageDialog extends DialogFragment {
    private static final int CAMERA_REQUEST = 1;
    private static final int RESULT_LOAD_IMAGE = 2;
    private static final String TAG = "ImagePicker";
    private static final int CHECK_CAMERA = 3;
    private static final int CHECK_STORAGE = 4;
    OnClick listener;

    public TextView tvMsg;
    public TextView tvMsgInfo;
    public Button btCancel;
    public Button btOk;

    String tvMsgText = "", tvMsgInfoText = "", cancelTxt = "", okTxt = "";
    static MessageDialog msgDialog;

    @SuppressLint("WrongConstant")
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(0, R.style.MaterialDialogSheet);
    }

    @Override
    public void setupDialog(Dialog dialog, int style) {
        dialog.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
        dialog.getWindow().setLayout(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.getWindow().setGravity(Gravity.CENTER);
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.dialog_ok, container, false);

        btOk = view.findViewById(R.id.btOk);
        btCancel = view.findViewById(R.id.btCancel);
        tvMsg = view.findViewById(R.id.tvMsg);
        tvMsgInfo = view.findViewById(R.id.tvMsgInfo);

        btOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (listener != null) {
                    listener.set(true);
                }
            }
        });

        btCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (listener != null) {
                    listener.set(false);
                }
            }
        });

        return view;
    }

    public static MessageDialog getInstance() {
        if (msgDialog == null)
            msgDialog = new MessageDialog();
        return msgDialog;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        if (getArguments() != null) {

            tvMsgText = getArguments().getString("tvMsgText",null);
            tvMsgInfoText = getArguments().getString(Constants.TEXT_MESSAGES,null);

            cancelTxt = getArguments().getString("cancelTxt","");
            okTxt = getArguments().getString(Constants.OK,"");

            tvMsg.setVisibility(tvMsgText == null ? View.GONE : View.VISIBLE);
            tvMsgInfo.setVisibility(tvMsgInfoText == null ? View.GONE : View.VISIBLE);

            btCancel.setText(cancelTxt);
            btOk.setText(okTxt);

            tvMsg.setText(tvMsgText);
            tvMsgInfo.setText(tvMsgInfoText);
        }

        setLabel();
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        //No call for super(). Bug on API Level > 11.
    }

    private void setLabel() {
       /* if (lngList.size() == 0) {
            return;
        }
      */
        //lblTakePicture.setText(lngList.get(Label.LBL_FROM_CAMERA));
        //lblFromGallery.setText(lngList.get(Label.LBL_FROM_GALLERY));
        //tvCancel.setText(lngList.get(Label.LBL_CANCEL));
    }

    public void setListener(OnClick listener) {
        this.listener = listener;
    }

    public interface OnClick {
        public void set(boolean ok);
    }
}
