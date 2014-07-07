package com.example.test4;

import android.app.ActionBar;
import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ShareActionProvider;

public class SecondActivity extends Activity{
	
	private Fragment fragment;
	private String data;
	private ShareActionProvider mShareActionProvider;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.second);
		
		ActionBar actionBar = getActionBar();
		actionBar.setDisplayHomeAsUpEnabled(true);
		
		FragmentManager fragmentManager = getFragmentManager();
		FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
		
		Intent intent = getIntent();
		data = intent.getStringExtra("data");
		
		if(data.equals("newsfeed")){
			fragment = new newsfeedFragment();
		}
		else if(data.equals("friends")){
			fragment = new friendsFragment();
		}
		else{
			fragment = new friendsFragment();
		}
		
		fragmentTransaction.add(R.id.myfragment, fragment);
		fragmentTransaction.commit();
		
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem menuItem){
		finish();
		return true;
	}
	
	@Override
	public void onBackPressed() {
		finish();

	}
	
	@Override
	 public boolean onCreateOptionsMenu(Menu menu) {
	     // Inflate menu resource file.
	     getMenuInflater().inflate(R.menu.share_menu, menu);

	     // Locate MenuItem with ShareActionProvider
	     MenuItem item = menu.findItem(R.id.menu_item_share);

	     // Fetch and store ShareActionProvider
	     mShareActionProvider = (ShareActionProvider) item.getActionProvider();

	     // Return true to display menu
	     return true;
	 }

	 // Call to update the share intent
	 private void setShareIntent(Intent shareIntent) {
	     if (mShareActionProvider != null) {
	         mShareActionProvider.setShareIntent(shareIntent);
	     }
	 }

	
}
