package com.example.test4;

import android.app.ActionBar;
import android.app.AlertDialog;
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
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.ColorDrawable;
import android.support.v4.util.LruCache;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.Toast;

import com.haarman.listviewanimations.ArrayAdapter;
import com.haarman.listviewanimations.itemmanipulation.OnDismissCallback;
import com.haarman.listviewanimations.itemmanipulation.SwipeDismissAdapter;
import com.haarman.listviewanimations.swinginadapters.prepared.SwingBottomInAnimationAdapter;

public class Building extends BaseActivity{

	private static final String TAG = "CourseList";
	private GoogleCardsAdapter mGoogleCardsAdapter;
	private static String[] title = {"B", "C", "D", "E"," K", "L", "M", "N", "P", "X", "BC", "S", "GH", "SCH", "W", "DJ", "SL", "G", "AH", "CH", "EP", "GR", "HD", "MS", "TH", "WR",
		"110WA", "600RS", "602RS", "604RS", "606RS", "616RS", "802CP", "831CP", "835CP", "1036CP", "253-3", "OFF"};
	private static String[] name = {"Burchard Building", "Carnegie Laboratory", "Davidson Laboratory","Edwin A. Stevens Hall", "Kidde Complex", "Lieb Building", "Morton Complex",
		"Nicholl Environmental Lab", "Peirce Complex", "McLean Chemical Sciences Building", "Babbio Center", "Wesley J. Howe Center", "Gatehouse (Campus Police)", "Schaefer Athletic Center",
		"Walker Gymnasium", "Jacobus Student Center", "Samuel C. Williams Library","Earl L. Griffith Building (Physical Plant)", "Alexander C. Humphreys Hall", "Charles Hayden Hall",
		"Edgar Palmer Hall", "Graduate Residence Halls", "Harvey N. Davis Hall", "Married Students' Apartments", "Technology Hall", "Undergraduate Women's Halls", "110 Washington Street",
		"600 River Street", "602 River Street", "604 River Street", "606 River Street", "616 River Street", "Lore-El Center for Women in Engineering and Science", "831 Castle Point Terrace",
		"835 Castle Point Terrace", "1036 Park Avenue", "253 3rd Street", "Off Campus"
		};

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


	}

	private ArrayList<Integer> getItems() {
		ArrayList<Integer> items = new ArrayList<Integer>();
		for (int i = 0; i < 38; i++) {
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
			viewHolder.textView2.setText(name[getItem(position)]);
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