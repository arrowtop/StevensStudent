package com.example.test4;

import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.ShareActionProvider;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

public class FifthActivity extends ListActivity{
	
	private ShareActionProvider mShareActionProvider;
	 
	static final String[] CLASSES = new String[] { "Moodle", "Mystevens", "Ducksync"};
 
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
 
		setListAdapter(new ArrayAdapter<String>(this, R.layout.five, CLASSES));
 
		ListView listView = getListView();
		listView.setTextFilterEnabled(true);
 
		listView.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
			    // When clicked, show a toast with the TextView text
			    Toast.makeText(getApplicationContext(),
				((TextView) view).getText(), Toast.LENGTH_SHORT).show();
			}
		});
 
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
