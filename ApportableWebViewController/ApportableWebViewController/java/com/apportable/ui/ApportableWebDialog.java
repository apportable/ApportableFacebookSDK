//
//  ApportableWebDialog.java
//
//  Copyright (c) 2014 Apportable. All rights reserved.
//

package com.apportable.ui;

import android.content.Context;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.MotionEvent;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.webkit.WebSettings;
import android.util.DisplayMetrics;
import android.util.Log;

import java.util.ArrayList;

import com.apportable.app.VerdeApplication;
import com.apportable.utils.ThreadUtils;

public class ApportableWebDialog {
    private final static String TAG = "ApportableWebDialog";

    private final static int WEBVIEW_INSET = 50;

    private String mTitle;
    private String mURL;
    private ArrayList<String> mURLOverrideList;
    private Context mCtx;
    private AlertDialog mAlert;
    private ProgressBar mProgressBar;
 
    private native void onOverrideURL(String url);
    private native void onClose();

    private class ApportableWebView extends WebView {
        public ApportableWebView(Context ctx) {
            super(ctx);
        }

        @Override
        public boolean onKeyDown(int keyCode, KeyEvent event) {
            if (keyCode == KeyEvent.KEYCODE_BACK) {
                ApportableWebDialog.this._dismiss();
                ApportableWebDialog.this.onClose();
                return true;
            }
            return super.onKeyDown(keyCode, event);
        }
    }

    public ApportableWebDialog(String title, String url, Context ctx) {
        mTitle = title;
        mURL = url;
        mCtx = ctx;
        mAlert = null;
        mURLOverrideList = new ArrayList<String>();
    }

    public void setOverrideURLLoadingPrefix(String url) {
        mURLOverrideList.clear();
        mURLOverrideList.add(url);
    }

    public void addOverrideURLLoadingPrefix(String url) {
        mURLOverrideList.add(url);
    }

    public void cancel() {
        if (mAlert != null) {
            this._dismiss();
        }
    }

    private void _dismiss() {
        mAlert.dismiss();
        mAlert = null;
    }
 
    public synchronized void show() {
        if (mAlert != null) {
            return;
        }

        ThreadUtils.runOnUiThread(new Runnable() {
            @Override
            public void run() {

                AlertDialog.Builder alert = new AlertDialog.Builder(ApportableWebDialog.this.mCtx);
                alert.setTitle(ApportableWebDialog.this.mTitle);

                ApportableWebView wv = new ApportableWebView(ApportableWebDialog.this.mCtx);
                wv.getSettings().setRenderPriority(WebSettings.RenderPriority.HIGH);
                wv.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
                wv.getSettings().setJavaScriptEnabled(true);
                wv.requestFocusFromTouch();
                wv.setWebViewClient(new WebViewClient() {
                    @Override
                    public boolean shouldOverrideUrlLoading(WebView view, String url) {
                        boolean isOverriding = false;
                        for (String overrideURL : mURLOverrideList) {
                            if (url.startsWith(overrideURL)) {
                                Log.d(TAG, "WebView overriding url : "+url);
                                ApportableWebDialog.this._dismiss();
                                ApportableWebDialog.this.onOverrideURL(url);
                                isOverriding = true;
                                break;
                            }
                        }
                        if (!isOverriding) {
                            Log.d(TAG, "WebView loading url : "+url);
                            view.loadUrl(url);
                        }
                        return true;
                    }

                    @Override
                    public void onPageFinished(final WebView view, final String url) {
                        if (mProgressBar.getVisibility() == View.VISIBLE) {
                            mProgressBar.setVisibility(View.GONE);
                        }
                        super.onPageFinished(view, url);
                        view.invalidate(); // force a size change
                        if (!view.hasFocus()) {
                            view.requestFocus();
                        }
                    }
                });
                wv.setOnTouchListener(new View.OnTouchListener() {
                    @Override
                    public boolean onTouch(View v, MotionEvent event) {
                        switch (event.getAction()) {
                            case MotionEvent.ACTION_DOWN:
                            case MotionEvent.ACTION_UP:
                                if (!v.hasFocus()) {
                                    v.requestFocus();
                                }
                                break;
                        }
                        return false;
                    }
                });
                wv.loadUrl(ApportableWebDialog.this.mURL);

                RelativeLayout progressLayout = new RelativeLayout(ApportableWebDialog.this.mCtx);
                mProgressBar = new ProgressBar(ApportableWebDialog.this.mCtx, null, android.R.attr.progressBarStyleSmall/* .progressBarStyleLarge */);
                mProgressBar.setIndeterminate(true);
                mProgressBar.setVisibility(View.VISIBLE);
                RelativeLayout.LayoutParams progressParams = new RelativeLayout.LayoutParams(100,100);
                progressParams.addRule(RelativeLayout.CENTER_IN_PARENT);
                progressLayout.addView(mProgressBar, progressParams);

                // http://stackoverflow.com/questions/7252832/android-soft-keyboard-not-open-in-webview
                LinearLayout wrapper = new LinearLayout(ApportableWebDialog.this.mCtx);
                EditText keyboardHackForAndroidWebViewInsideAnAlertDialog = new EditText(ApportableWebDialog.this.mCtx);
                keyboardHackForAndroidWebViewInsideAnAlertDialog.setVisibility(View.GONE);

                WindowManager wm = (WindowManager)mCtx.getSystemService(Context.WINDOW_SERVICE);
                DisplayMetrics dm = new DisplayMetrics();
                wm.getDefaultDisplay().getMetrics(dm);

                wrapper.setOrientation(LinearLayout.VERTICAL);
                wrapper.addView(progressLayout, LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT);
                wrapper.addView(wv, dm.widthPixels-WEBVIEW_INSET, dm.heightPixels-WEBVIEW_INSET);
                wrapper.addView(keyboardHackForAndroidWebViewInsideAnAlertDialog, LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);

                ScrollView wrapper0 = new ScrollView(ApportableWebDialog.this.mCtx);
                wrapper0.addView(wrapper, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));

                alert.setView(wrapper0);
                alert.setNegativeButton("Close", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        ApportableWebDialog.this._dismiss();
                        ApportableWebDialog.this.onClose();
                    }
                });
                mAlert = alert.show();
            }
        });
    }
}

