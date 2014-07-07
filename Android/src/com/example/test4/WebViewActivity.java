package com.example.test4;

import android.app.ActionBar;
import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;
import android.webkit.WebView;
import android.webkit.WebViewClient;
 
public class WebViewActivity extends Activity {
 
	private WebView webView;
	private static String link;
	private static String title;
 
	public void onCreate(Bundle savedInstanceState) {
	   super.onCreate(savedInstanceState);
	   setContentView(R.layout.webview);
	   
	   if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			ActionBar actionBar = getActionBar();
			actionBar.setDisplayHomeAsUpEnabled(true);
		}
 
	   link = getIntent().getExtras().getString("data");
	   title = getIntent().getExtras().getString("data2"); 
	   setTitle(title);
	   
	   webView = (WebView) findViewById(R.id.webView1);

       webView.getSettings().setLoadWithOverviewMode(true);
       webView.getSettings().setUseWideViewPort(true);
	   webView.getSettings().setJavaScriptEnabled(true);
	   webView.setWebViewClient(new WebViewClient());
	   webView.loadUrl(link);
 
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem menuItem) {
		finish();
		return true;
	}

	@Override
	public void onBackPressed() {
		finish();

	}
 
}
