package com.example.test4;

import java.io.InputStream;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.Bitmap.Config;
import android.graphics.Paint;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ImageView;
import android.widget.ShareActionProvider;

public class ThirdActivity extends Activity {
	
	private int screenWidth;
	private int screenHeight;
	private float density;
	private Paint paint = new Paint();
	private ShareActionProvider mShareActionProvider;
	
	public void onCreate(Bundle savedInstanceState){
		
		super.onCreate(savedInstanceState);
		
		ActionBar actionBar = getActionBar();
		actionBar.setDisplayHomeAsUpEnabled(true);
		
		DisplayMetrics dm = new DisplayMetrics();  
		getWindowManager().getDefaultDisplay().getMetrics(dm); 
		
		density  = dm.density;
		
		screenWidth  = (int)(dm.widthPixels * density + 0.5f);   
		screenHeight = (int)(dm.heightPixels * density + 0.5f); 

		Bitmap bitmap = Bitmap.createBitmap(screenWidth, screenHeight, Config.ARGB_8888);

		Canvas canvas = new Canvas (bitmap);
		
		paint.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));  
        paint.setColor(Color.BLACK); 
        paint.setTextSize(90);
        canvas.drawText("ECOHABIT FINISHES FOURTH IN", 10, 100, paint);
        canvas.drawText("SOLAR DECATHLON", 10, 200, paint);
        
        paint.setTypeface(Typeface.defaultFromStyle(Typeface.NORMAL));  
        paint.setColor(Color.GRAY); 
        paint.setTextSize(40);
        canvas.drawText("10/14/2013", 10, 300, paint);
        
        paint.setColor(Color.RED); 
        canvas.drawLine(10, 330, 1500, 330, paint);
        
        paint.setColor(Color.BLACK);
        paint.setTextSize(60);     
        canvas.drawText("Hoboken, N.J. ¨C As corporations, governments and ", 10, 1200, paint);
        canvas.drawText("innovators across the world seek affordable clean ", 10, 1270, paint);
        canvas.drawText("energy solutions to respond to the threat of climate ", 10, 1340, paint);
        canvas.drawText("change, Stevens Institute of Technology has created ", 10, 1410, paint);
        canvas.drawText("an award-winning home which demonstrates the money- ", 10, 1480, paint);
        canvas.drawText("saving opportunities and environmental benefits ", 10, 1550, paint);
        canvas.drawText("presented  by clean energy products and design ", 10, 1620, paint);
        canvas.drawText("solutions. ", 10, 1690, paint);
        
        
        
        
        
        
		ImageView imgView  = new ImageView(this);
		   
		Drawable drawable = new BitmapDrawable(bitmap) ;  
		imgView .setBackgroundDrawable(drawable) ;
		
		setContentView(imgView) ;
		

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
