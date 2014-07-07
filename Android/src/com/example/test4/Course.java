package com.example.test4;

import android.app.ActionBar;
import android.app.Activity;
import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SearchView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class Course extends Activity{
	private TextView mTextView;
    private ListView mListView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.course_main);

        mTextView = (TextView) findViewById(R.id.course_text);
        mListView = (ListView) findViewById(R.id.course_list);
        
        ActionBar actionBar = getActionBar();
		actionBar.setDisplayHomeAsUpEnabled(true);

        handleIntent(getIntent());
    }
    
    @Override
    protected void onNewIntent(Intent intent) {
        
        handleIntent(intent);
    }

    private void handleIntent(Intent intent) {
        if (Intent.ACTION_VIEW.equals(intent.getAction())) {
            // handles a click on a search suggestion; launches activity to show word
            Intent peopleIntent = new Intent(this, CourseList.class);
            peopleIntent.setData(intent.getData());
            startActivity(peopleIntent);
        } else if (Intent.ACTION_SEARCH.equals(intent.getAction())) {
            // handles a search query
            String query = intent.getStringExtra(SearchManager.QUERY);
            showResults(query);
        }
    }

    /**
     * Searches the dictionary and displays results for the given query.
     * @param query The search query
     */
    private void showResults(String query) {

        Cursor cursor = managedQuery(CourseProvider.CONTENT_URI, null, null,
                                new String[] {query}, null);

        if (cursor == null) {
            // There are no results
            mTextView.setText(getString(R.string.no_result, new Object[] {query}));
        } else {
            // Display the number of results
            int count = cursor.getCount();
            String countString = getResources().getQuantityString(R.plurals.search_results,
                                    count, new Object[] {count, query});
            mTextView.setText(countString);

            // Specify the columns we want to display in the result
            String[] from = new String[] { CourseDB.KEY_NAME};

            // Specify the corresponding layout elements where we want the columns to go
            int[] to = new int[] { R.id.name };

            // Create a simple cursor adapter for the definitions and apply them to the ListView
            SimpleCursorAdapter people = new SimpleCursorAdapter(this,
                                          R.layout.results, cursor, from, to);
            mListView.setAdapter(people);

            // Define the on-click listener for the list items
            mListView.setOnItemClickListener(new OnItemClickListener() {

                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    // Build the Intent used to open WordActivity with a specific word Uri
                    Intent courseIntent = new Intent(getApplicationContext(), CourseList.class);
                    Uri data = Uri.withAppendedPath(CourseProvider.CONTENT_URI,
                                                    String.valueOf(id));
                    courseIntent.setData(data);
                    startActivity(courseIntent);
                }
            });
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.options_menu, menu);

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB){
            SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);
            SearchView searchView = (SearchView) menu.findItem(R.id.search).getActionView();
            searchView.setSearchableInfo(searchManager.getSearchableInfo(getComponentName()));
            searchView.setIconifiedByDefault(false);
        }

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
    	int id = item.getItemId();
        if(id == R.id.search){
             onSearchRequested();
             return true;
        }
        else{
        	finish();
            return false;
        }
    }
	
	@Override
	public void onBackPressed() {
		finish();

	}
}