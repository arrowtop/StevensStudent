package com.example.test4;

import java.util.ArrayList;
import java.util.List;
import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.util.LruCache;
import android.support.v7.app.ActionBarActivity;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.AdapterView.OnItemClickListener;

import com.haarman.listviewanimations.ArrayAdapter;
import com.haarman.listviewanimations.swinginadapters.prepared.SwingBottomInAnimationAdapter;

public class MainActivity extends ActionBarActivity {

	@SuppressLint("InlinedApi")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		if (Build.VERSION.SDK_INT >= 19) {
			getWindow()
					.addFlags(
							android.view.WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
		}
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_gridview);

		GridView gridView = (GridView) findViewById(R.id.activity_gridview_gv);
		SwingBottomInAnimationAdapter swingBottomInAnimationAdapter = new SwingBottomInAnimationAdapter(
				new MyAdapter(this, getItems()));
		swingBottomInAnimationAdapter.setAbsListView(gridView);
		swingBottomInAnimationAdapter.setInitialDelayMillis(300);
		gridView.setAdapter(swingBottomInAnimationAdapter);

		gridView.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				if(position == 0) {
					Intent intent = new Intent(getApplicationContext(),
							WebViewActivity.class);
					String data = "http://155.246.170.11/StevensStudent/news_list.jsp";
					String data2 = "News";
					intent.putExtra("data", data);
					intent.putExtra("data2", data2);
					startActivity(intent);
				}
				if(position == 1){
					Intent intent = new Intent(getApplicationContext(),
							WebViewActivity.class);
					String data = "http://155.246.170.11/StevensStudent/";
					String data2 = "Events";
					intent.putExtra("data", data);
					intent.putExtra("data2", data2);
					startActivity(intent);
				}
				if(position == 2){
					Intent intent = new Intent(getApplicationContext(),
							WebViewActivity.class);
					String data = "http://www.stevensducks.com";
					String data2 = "Athletics";
					intent.putExtra("data", data);
					intent.putExtra("data2", data2);
					startActivity(intent);
				}
				if(position == 3){
					Intent intent = new Intent(getApplicationContext(),
							Shuttle.class);
					startActivity(intent);
				}
				if(position == 4){
					Intent intent = new Intent(getApplicationContext(),
							DiningFront.class);
					startActivity(intent);
				}
				if(position == 5){
					Intent intent = new Intent(getApplicationContext(),
							Directory.class);
					startActivity(intent);
				}
				if(position == 6){
					Intent intent = new Intent(getApplicationContext(),
							CourseActivity.class);
					startActivity(intent);
				}
				if(position == 7){
					Intent intent = new Intent(getApplicationContext(),
							Emergency.class);
					startActivity(intent);
				}
				if(position == 8){
					Intent intent = new Intent(getApplicationContext(),
							Building.class);
					startActivity(intent);
				}
				if(position == 9){
					Intent intent = new Intent(getApplicationContext(),
							Links.class);
					startActivity(intent);
				}
				if(position == 10){
					Intent intent = new Intent(getApplicationContext(),
							Settings.class);
					startActivity(intent);
				}
				if(position == 11){
					Intent intent = new Intent(getApplicationContext(),
							VideoActivity.class);
					startActivity(intent);
				}
			}
		});

	}

	private ArrayList<Integer> getItems() {
		ArrayList<Integer> items = new ArrayList<Integer>();
		for (int i = 0; i < 12; i++) {
			items.add(i);
		}
		return items;
	}

	private static class MyAdapter extends ArrayAdapter<Integer> {

		private Context mContext;
		private LruCache<Integer, Bitmap> mMemoryCache;

		public MyAdapter(Context context, List<Integer> list) {
			super(list);
			mContext = context;
			final int maxMemory = (int) (Runtime.getRuntime().maxMemory() / 1024);

			// Use 1/8th of the available memory for this memory cache.
			final int cacheSize = maxMemory;
			mMemoryCache = new LruCache<Integer, Bitmap>(cacheSize) {
				@Override
				protected int sizeOf(Integer key, Bitmap bitmap) {
					// The cache size will be measured in kilobytes rather than
					// number of items.
					return bitmap.getRowBytes() * bitmap.getHeight() / 1024;
				}
			};
		}

		@Override
		public View getView(int position, View convertView, ViewGroup viewGroup) {
			ImageView imageView = (ImageView) convertView;

			if (imageView == null) {
				imageView = new ImageView(mContext);
				imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
			}

			int imageResId;
			switch (getItem(position)) {
			case 0:
				imageResId = R.drawable.news;
				break;
			case 1:
				imageResId = R.drawable.events;
				break;
			case 2:
				imageResId = R.drawable.athletics;
				break;
			case 3:
				imageResId = R.drawable.shuttles;
				break;
			case 4:
				imageResId = R.drawable.dining;
				break;
			case 5:
				imageResId = R.drawable.directory;
				break;
			case 6:
				imageResId = R.drawable.course;
				break;
			case 7:
				imageResId = R.drawable.emergency;
				break;
			case 8:
				imageResId = R.drawable.building;
				break;
			case 9:
				imageResId = R.drawable.links;
				break;
			case 10:
				imageResId = R.drawable.settings;
				break;
			case 11:
				imageResId = R.drawable.about;
				break;
			default:
				imageResId = R.drawable.news;
			}

			Bitmap bitmap = getBitmapFromMemCache(imageResId);
			if (bitmap == null) {
				bitmap = BitmapFactory.decodeResource(mContext.getResources(),
						imageResId);
				addBitmapToMemoryCache(imageResId, bitmap);
			}
			imageView.setImageBitmap(bitmap);

			return imageView;
		}

		private void addBitmapToMemoryCache(int key, Bitmap bitmap) {
			if (getBitmapFromMemCache(key) == null) {
				mMemoryCache.put(key, bitmap);
			}
		}

		private Bitmap getBitmapFromMemCache(int key) {
			return mMemoryCache.get(key);
		}
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

	/*
	 * @Override public boolean onOptionsItemSelected(MenuItem item) { switch
	 * (item.getItemId()) { case android.R.id.home: finish(); return true;
	 * default: return super.onOptionsItemSelected(item); } }
	 */
}
