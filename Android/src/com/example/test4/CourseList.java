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

public class CourseList extends BaseActivity{

	private static final String TAG = "CourseList";
	private GoogleCardsAdapter mGoogleCardsAdapter;
	private static String[] title = {"course id", "course name", "call number", "professor","days", "start time", "end time"
		, "building", "room"};
	private static String[] result = new String[9];

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
			for(int i = 0; i < 9; i++){
				if(i == 0)
					result[i] = name;
				else
					result[i] = temp[i-1];
					
			}
		}

		ListView listView = (ListView) findViewById(R.id.directory_listview);

		mGoogleCardsAdapter = new GoogleCardsAdapter(this);

        listView.setAdapter(mGoogleCardsAdapter);

		mGoogleCardsAdapter.addAll(getItems());
		
		LayoutInflater layoutInflater = LayoutInflater.from(this);
	    View view = layoutInflater.inflate(R.layout.course_bookmark_alert, null);
		
		listView.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				/*
				if(position == 0){
					new AlertDialog.Builder(CourseList.this).setTitle("Bookmark").setView(
							view).setPositiveButton("OK",
							new DialogInterface.OnClickListener() {
								@Override
								public void onClick(DialogInterface dialog, int which) {
									SharedPreferences coursePref = getSharedPreferences("UserInfo", 0);
									String courseNumber = coursePref.getString("COURSENUMBER",null);
									if(courseNumber == null){
										String temp2 = result[0];
										for(int i = 1; i < 9; i++){
												temp2 = temp2 + "," + result[i];
											}
										SharedPreferences.Editor editor = coursePref.edit();
										editor.putString("COURSENUMBER", "1");
										editor.putString("COURSEINFO", temp2);
										editor.commit();
										Toast.makeText(CourseList.this, "Bookmarked Successfully!", Toast.LENGTH_LONG).show();
									}
								}

							}).setNegativeButton("Cancel",
							new DialogInterface.OnClickListener() {
								@Override
								public void onClick(DialogInterface dialog, int which) {
									
								}
							}).show();
				}
				*/
				if(position == 0){
					SharedPreferences coursePref = getSharedPreferences("UserInfo", 0);
					String courseNumber = coursePref.getString("COURSENUMBER",null);
					String courseInfo = coursePref.getString("COURSEINFO",null);
					if(courseNumber == null){
						String temp2 = result[0];
						for(int i = 1; i < 9; i++){
								temp2 = temp2 + "," + result[i];
							}
						SharedPreferences.Editor editor = coursePref.edit();
						editor.putString("COURSENUMBER", "1");
						editor.putString("COURSEINFO", temp2);
						editor.commit();
						Toast.makeText(CourseList.this, "Bookmarked Successfully!", Toast.LENGTH_LONG).show();
					}
					else{
						coursePref = getSharedPreferences("UserInfo", 0);
						courseNumber = coursePref.getString("COURSENUMBER",null);
						courseInfo = coursePref.getString("COURSEINFO",null);
						int courseNo = Integer.parseInt(courseNumber);
						if(courseNo == 0){
							String temp2 = result[0];
							for(int i = 1; i < 9; i++){
									temp2 = temp2 + "," + result[i];
							}
							SharedPreferences.Editor editor = coursePref.edit();
							editor.putString("COURSENUMBER", "1");
							editor.putString("COURSEINFO", temp2);
							editor.commit();
							Toast.makeText(CourseList.this, "Bookmarked Successfully!", Toast.LENGTH_LONG).show();
						}
						else if(courseNo == 10){
							Toast.makeText(CourseList.this, "You can only have 10 bookmarks!", Toast.LENGTH_LONG).show();
						}
						else{
							String[] temp3 = TextUtils.split(courseInfo, ",");
							for(int i = 0; i < temp3.length; i++){
								if(result[0].equals(temp3[i])){
									Log.d(TAG, "Portal1");
									courseNo--;
									String temp4 = null;
									if(temp3.length > 9){
										for(int j = i+9; j < temp3.length; j++){
											temp3[j-9] = temp3[j];
										}
										temp4 = temp3[0];
										for(int k = 1; k < temp3.length - 9; k++){
											temp4 = temp4 + "," + temp3[k];
										}
									}
								
									SharedPreferences.Editor editor = coursePref.edit();
									editor.putString("COURSENUMBER", courseNo+"");
									editor.putString("COURSEINFO", temp4);
									editor.commit();
									Toast.makeText(CourseList.this, "Bookmark Deleted!", Toast.LENGTH_LONG).show();
									break;
								}
								if(i == temp3.length-1){
									Log.d(TAG, "Portal2");
									courseNo++;
									String temp4 = temp3[0];
									for(int j = 1; j < temp3.length + 9; j++){
										if(j < temp3.length){
											temp4 = temp4 + "," + temp3[j];
										}
										else{
											temp4 = temp4 + "," + result[j-temp3.length];
										}
									
									}
									SharedPreferences.Editor editor = coursePref.edit();
									editor.putString("COURSENUMBER", courseNo+"");
									editor.putString("COURSEINFO", temp4);
									editor.commit();
									Toast.makeText(CourseList.this, "Bookmarked Successfully!", Toast.LENGTH_LONG).show();
									break;
								}
							}
				
						}
						
						

					}
				}
			}
				
		});
	}

	private ArrayList<Integer> getItems() {
		ArrayList<Integer> items = new ArrayList<Integer>();
		for (int i = 0; i < 9; i++) {
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
