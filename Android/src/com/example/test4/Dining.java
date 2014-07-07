package com.example.test4;

import java.util.ArrayList;

import com.haarman.listviewanimations.ArrayAdapter;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.util.LruCache;
import android.text.Html;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

public class Dining extends BaseActivity {

	private GoogleCardsAdapter mGoogleCardsAdapter;
	private static String day;
	private static String[] time = {"Breakfast", "Lunch", "Dinner"};
	private static String[] content = new String[3];
	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.directory);
		
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			ActionBar actionBar = getActionBar();
			actionBar.setDisplayHomeAsUpEnabled(true);
		}

		content[0] = getIntent().getStringExtra("breakfast");
		content[1] = getIntent().getStringExtra("lunch");
		content[2] = getIntent().getStringExtra("dinner");

		ListView listView = (ListView) findViewById(R.id.directory_listview);

		mGoogleCardsAdapter = new GoogleCardsAdapter(this);

		listView.setAdapter(mGoogleCardsAdapter);

		mGoogleCardsAdapter.addAll(getItems());
		
	}

	private ArrayList<Integer> getItems() {
		ArrayList<Integer> items = new ArrayList<Integer>();
		for (int i = 0; i < 3; i++) {
			items.add(i);
		}
		return items;
	}

	private static class GoogleCardsAdapter extends ArrayAdapter<Integer> {

		private Context mContext;
		private LruCache<Integer, Bitmap> mMemoryCache;

		public GoogleCardsAdapter(Context context) {
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
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder viewHolder;
			View view = convertView;
			if (view == null) {
				view = LayoutInflater.from(mContext).inflate(
						R.layout.directory_card, parent, false);

				viewHolder = new ViewHolder();
				viewHolder.textView1 = (TextView) view
						.findViewById(R.id.directory_card_textview1);
				view.setTag(viewHolder);

				viewHolder.textView2 = (TextView) view
						.findViewById(R.id.directory_card_textview2);
			} else {
				viewHolder = (ViewHolder) view.getTag();
			}

			viewHolder.textView1.setText(time[getItem(position)]);
			if(content[getItem(position)] == null){
				viewHolder.textView2.setText(null);
			}
			else{
				viewHolder.textView2.setText(Html.fromHtml(content[getItem(position)]));
			}
			return view;
		}


		private void addBitmapToMemoryCache(int key, Bitmap bitmap) {
			if (getBitmapFromMemCache(key) == null) {
				mMemoryCache.put(key, bitmap);
			}
		}

		private Bitmap getBitmapFromMemCache(int key) {
			return mMemoryCache.get(key);
		}

		private static class ViewHolder {
			TextView textView1;
			TextView textView2;
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
}
