package com.example.test4;

import android.app.ActionBar;
import android.os.Build;
import android.os.Bundle;
import android.widget.AdapterView;
import android.widget.TextView;
import android.view.MenuItem;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.support.v4.util.LruCache;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.AdapterView.OnItemClickListener;

import com.haarman.listviewanimations.ArrayAdapter;


public class Links extends BaseActivity {

	private GoogleCardsAdapter mGoogleCardsAdapter;
	private final static int NUMBER = 7;
	private final static String[] TITLE = {"Graduate Admissions",
											"Undergraduate Admissions",
											"Mystevens",
											"Moodle",
											"Campus Life",
											"Library",
											"Stevens Facebook"
											 };
	private final static String[] LINK = {"http://www.stevens.edu/sit/admissions/index.cfm",
										  "http://www.stevens.edu/sit/graduate/index.cfm",
										   "http://mystevens.stevens.edu",
										   "http://moodle.stevens.edu",
										   	"http://ugstudentlife.stevens.edu/",
										   "http://www.stevens.edu/library/",
										   "http://www.facebook.com/Stevens1870"};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.directory);

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			ActionBar actionBar = getActionBar();
			actionBar.setDisplayHomeAsUpEnabled(true);
		}

		ListView listView = (ListView) findViewById(R.id.directory_listview);
		mGoogleCardsAdapter = new GoogleCardsAdapter(this);

        listView.setAdapter(mGoogleCardsAdapter);

        mGoogleCardsAdapter.addAll(getItems());
        
        listView.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {

				String data = LINK[position];
				Intent intent = new Intent(getApplicationContext(), WebViewActivity.class);
				String data2 = "Links";
				intent.putExtra("data", data);
				intent.putExtra("data2", data2);
			    startActivity(intent);
			}
				
		});
		
	}

	private ArrayList<Integer> getItems() {
		ArrayList<Integer> items = new ArrayList<Integer>();
		for (int i = 0; i < NUMBER; i++) {
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
			
			viewHolder.textView1.setText(TITLE[getItem(position)]);
			viewHolder.textView2.setText(LINK[getItem(position)]);
			
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