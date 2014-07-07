package com.example.test4;

import android.app.ActionBar;
import android.app.Activity;
import android.os.Bundle;
import android.view.MenuItem;


public class Shuttle extends Activity{

	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.shuttle);
		
		ActionBar actionBar = getActionBar();
		actionBar.setDisplayHomeAsUpEnabled(true);	
		
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
}
