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
import com.haarman.listviewanimations.itemmanipulation.contextualundo.ContextualUndoAdapter;
import com.haarman.listviewanimations.itemmanipulation.contextualundo.ContextualUndoAdapter.DeleteItemCallback;
import com.haarman.listviewanimations.swinginadapters.prepared.SwingBottomInAnimationAdapter;

public class CourseBookmarked extends BaseActivity implements OnDismissCallback {

	private GoogleCardsAdapter mGoogleCardsAdapter;
	private static int cardNumber;
	private static String[] name = new String[10];
	private static String[] id = new String[10];
	private static String[] number = new String[10];
	private static String[] professor = new String[10];
	private static String[] building = new String[10];
	private static String[] day = new String[10];
	private static String[] time = new String[10];
	private static String[] temp;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.directory);

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			ActionBar actionBar = getActionBar();
			actionBar.setDisplayHomeAsUpEnabled(true);
		}

		SharedPreferences coursePref = getSharedPreferences("UserInfo", 0);
		String courseNumber = coursePref.getString("COURSENUMBER",null);
		String courseInfo = coursePref.getString("COURSEINFO",null);
		
		if(courseNumber == null){
			cardNumber = 0;
		}
		else{
			cardNumber = Integer.parseInt(courseNumber);
			if(cardNumber != 0){
				temp = TextUtils.split(courseInfo, ",");
				for(int i = 0; i < cardNumber; i ++){
					name[i] = temp[i*9+1];
					id[i] = temp[i*9];
					number[i] = temp[i*9+2];
					professor[i] = temp[i*9+3];
					building[i] = temp[i*9+7] + "-" + temp[i*9+8];
					day[i] = temp[i*9+4];
					time[i] = temp[i*9+5] + "-" + temp[i*9+6];
				}
				
			}
		}	

		ListView listView = (ListView) findViewById(R.id.directory_listview);
		mGoogleCardsAdapter = new GoogleCardsAdapter(this);
        SwingBottomInAnimationAdapter swingBottomInAnimationAdapter = new SwingBottomInAnimationAdapter(new SwipeDismissAdapter(mGoogleCardsAdapter, this));
        swingBottomInAnimationAdapter.setInitialDelayMillis(300);
        swingBottomInAnimationAdapter.setAbsListView(listView);

        listView.setAdapter(swingBottomInAnimationAdapter);

        mGoogleCardsAdapter.addAll(getItems());
		
	}

	private ArrayList<Integer> getItems() {
		ArrayList<Integer> items = new ArrayList<Integer>();
		for (int i = 0; i < cardNumber; i++) {
			items.add(i);
		}
		return items;
	}
	
	@Override
    public void onDismiss(AbsListView listView, int[] reverseSortedPositions) {
            for (int position : reverseSortedPositions) {
                    mGoogleCardsAdapter.remove(position);
                    cardNumber--;
                    SharedPreferences coursePref = getSharedPreferences("UserInfo", 0);
                    String courseNumber = coursePref.getString("COURSENUMBER",null);
					int courseNo = Integer.parseInt(courseNumber);
					courseNo--;
					String temp2 = null;
					for(int i = 0; i < temp.length; i++){
						if(i < position * 9 || i > position * 9 + 8){
							if(i == 0){
								temp2 = temp[0];
							}
							else if(i == 9 && position == 0){
								temp2 = temp[9];
							}
							else{
								temp2 = temp2 + "," + temp[i];
							}
						}
					}
					SharedPreferences.Editor editor = coursePref.edit();
					editor.putString("COURSENUMBER", courseNo+"");
					editor.putString("COURSEINFO", temp2);
					editor.commit();
					Toast.makeText(CourseBookmarked.this, "Bookmark Deleted!", Toast.LENGTH_LONG).show();          
            }
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
						R.layout.course_bookmark_card, parent, false);

				viewHolder = new ViewHolder();
				viewHolder.textView1 = (TextView) view
						.findViewById(R.id.bm_name);
				view.setTag(viewHolder);

				viewHolder.textView2 = (TextView) view
						.findViewById(R.id.bm_id);
				viewHolder.textView3 = (TextView) view
						.findViewById(R.id.bm_number);
				viewHolder.textView4 = (TextView) view
						.findViewById(R.id.bm_professor);
				viewHolder.textView5 = (TextView) view
						.findViewById(R.id.bm_building);
				viewHolder.textView6 = (TextView) view
						.findViewById(R.id.bm_day);
				viewHolder.textView7 = (TextView) view
						.findViewById(R.id.bm_time);
			} else {
				viewHolder = (ViewHolder) view.getTag();
			}
			
			viewHolder.textView1.setText(name[getItem(position)]);
			viewHolder.textView2.setText(id[getItem(position)]);
			viewHolder.textView3.setText(number[getItem(position)]);
			viewHolder.textView4.setText(professor[getItem(position)]);
			viewHolder.textView5.setText(building[getItem(position)]);
			viewHolder.textView6.setText(day[getItem(position)]);
			viewHolder.textView7.setText(time[getItem(position)]);
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
			TextView textView3;
			TextView textView4;
			TextView textView5;
			TextView textView6;
			TextView textView7;

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