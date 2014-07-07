package com.example.test4;

import android.app.ActionBar;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.widget.TextView;
import android.view.MenuItem;

import java.util.ArrayList;

import android.widget.AdapterView.OnItemClickListener;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.util.LruCache;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.haarman.listviewanimations.ArrayAdapter;
import com.haarman.listviewanimations.itemmanipulation.OnDismissCallback;
import com.haarman.listviewanimations.itemmanipulation.SwipeDismissAdapter;
import com.haarman.listviewanimations.swinginadapters.prepared.SwingBottomInAnimationAdapter;

public class DirectoryList extends BaseActivity {

	private GoogleCardsAdapter mGoogleCardsAdapter;
	private static String[] title = {"name", "title", "building", "room", "phone", "fax", "email", "school"
		, "department", "program"};
	private static String[] result = new String[10];

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.directory);

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			ActionBar actionBar = getActionBar();
			actionBar.setDisplayHomeAsUpEnabled(true);
		}

		Uri uri = getIntent().getData();
		Cursor cursor = managedQuery(uri, null, null, null, null);

		if (cursor == null) {
			finish();
		} else {
			cursor.moveToFirst();

			int wIndex = cursor.getColumnIndexOrThrow(DirectoryDB.KEY_NAME);
			int dIndex = cursor.getColumnIndexOrThrow(DirectoryDB.KEY_DETAILS);

			String[] temp = TextUtils.split(cursor.getString(dIndex), ",");
			String name = cursor.getString(wIndex);
			for(int i = 0; i < 10; i++){
				if(i == 0)
					result[i] = name;
				else if(i == 4 || i == 5)
					result[i] = temp[i-1].replace(".", "-");
				else
					result[i] = temp[i-1];
					
			}
		}

		ListView listView = (ListView) findViewById(R.id.directory_listview);

		mGoogleCardsAdapter = new GoogleCardsAdapter(this);

		listView.setAdapter(mGoogleCardsAdapter);

		mGoogleCardsAdapter.addAll(getItems());
		
		listView.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {

				if(position == 4){
					  if(!result[4].equals("#")){
						  Intent phoneIntent = new Intent(Intent.ACTION_CALL);
						  phoneIntent.setData(Uri.parse("tel:1-" + result[4]));

						  try {
							  startActivity(phoneIntent);
							  finish();
							  Log.i("Finished making a call...", "");
						  } catch (android.content.ActivityNotFoundException ex) {
							  Toast.makeText(DirectoryList.this, 
									  "Call faild, please try again later.", Toast.LENGTH_SHORT).show();
						  }
					  }
				}
				
				if(position == 6){
					if(!result[6].equals("#")){
						final Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);

						/* Fill it with Data */
						emailIntent.setType("plain/text");
						emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, new String[]{result[6]});
						emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "Subject");
						emailIntent.putExtra(android.content.Intent.EXTRA_TEXT, "Text");

						/* Send it off to the Activity-Chooser */
						startActivity(Intent.createChooser(emailIntent, "Send mail..."));
					}
				}
			}
		});
	}

	private ArrayList<Integer> getItems() {
		ArrayList<Integer> items = new ArrayList<Integer>();
		for (int i = 0; i < 10; i++) {
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
			
			viewHolder.textView1.setText(title[getItem(position)]);
			viewHolder.textView2.setText(result[getItem(position)]);
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
