package com.example.test4;

import android.app.ActionBar;
import android.app.Activity;
import android.graphics.PixelFormat;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;
import android.widget.MediaController;
import android.widget.VideoView;

public class VideoActivity extends Activity {
	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
       
        setContentView(R.layout.video);
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			ActionBar actionBar = getActionBar();
			actionBar.setDisplayHomeAsUpEnabled(true);
		}
        
        getWindow().setFormat(PixelFormat.TRANSLUCENT);
    	VideoView videoHolder = new VideoView(this);
    	videoHolder.setMediaController(new MediaController(this));
    	Uri video = Uri.parse("android.resource://" + getPackageName() + "/" 
    	+ R.raw.video); //do not add any extension
    	//if your file is named sherif.mp4 and placed in /raw
    	//use R.raw.sherif
    	videoHolder.setVideoURI(video);
    	setContentView(videoHolder);
    	videoHolder.start();
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
