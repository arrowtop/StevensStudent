package com.example.test4;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;

import android.app.SearchManager;
import android.content.ContentValues;
import android.content.Context;
import android.content.res.Resources;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteQueryBuilder;
import android.provider.BaseColumns;
import android.text.TextUtils;
import android.util.Log;

public class DirectoryDB {
	private static final String TAG = "DirectoryDatabase";
	
	public static final int DATABASE_VERSION = 1;
	public static final String DATABASE_NAME = "directorydb";
	public static final String DATABASE_TABLE = "directory";

	public static final String KEY_NAME = SearchManager.SUGGEST_COLUMN_TEXT_1;
	public static final String KEY_DETAILS = SearchManager.SUGGEST_COLUMN_TEXT_2;
	
	private final DirectoryOpenHelper mDatabaseOpenHelper;
	private static final HashMap<String,String> mColumnMap = buildColumnMap();
	
	public DirectoryDB(Context context) {
        mDatabaseOpenHelper = new DirectoryOpenHelper(context);
    }
	
	private static HashMap<String,String> buildColumnMap() {
        HashMap<String,String> map = new HashMap<String,String>();
        map.put(KEY_NAME, KEY_NAME);
        map.put(KEY_DETAILS, KEY_DETAILS);
        map.put(BaseColumns._ID, "rowid AS " +
                BaseColumns._ID);
        map.put(SearchManager.SUGGEST_COLUMN_INTENT_DATA_ID, "rowid AS " +
                SearchManager.SUGGEST_COLUMN_INTENT_DATA_ID);
        map.put(SearchManager.SUGGEST_COLUMN_SHORTCUT_ID, "rowid AS " +
                SearchManager.SUGGEST_COLUMN_SHORTCUT_ID);
        return map;
    }
	
	public Cursor getPeople(String rowId, String[] columns) {
        String selection = "rowid = ?";
        String[] selectionArgs = new String[] {rowId};

        return query(selection, selectionArgs, columns);

    }
	
	public Cursor getPeopleMatches(String query, String[] columns) {
        String selection = KEY_NAME + " MATCH ?";
        String[] selectionArgs = new String[] {query+"*"};

        return query(selection, selectionArgs, columns);

    }
	
	 private Cursor query(String selection, String[] selectionArgs, String[] columns) {
	        /* The SQLiteBuilder provides a map for all possible columns requested to
	         * actual columns in the database, creating a simple column alias mechanism
	         * by which the ContentProvider does not need to know the real column names
	         */
	        SQLiteQueryBuilder builder = new SQLiteQueryBuilder();
	        builder.setTables(DATABASE_TABLE);
	        builder.setProjectionMap(mColumnMap);

	        Cursor cursor = builder.query(mDatabaseOpenHelper.getReadableDatabase(),
	                columns, selection, selectionArgs, null, null, null);

	        if (cursor == null) {
	            return null;
	        } else if (!cursor.moveToFirst()) {
	            cursor.close();
	            return null;
	        }
	        return cursor;
	    }

	 private static class DirectoryOpenHelper extends SQLiteOpenHelper {

	        private final Context mHelperContext;
	        private SQLiteDatabase mDatabase;

	        /* Note that FTS3 does not support column constraints and thus, you cannot
	         * declare a primary key. However, "rowid" is automatically used as a unique
	         * identifier, so when making requests, we will use "_id" as an alias for "rowid"
	         */
	        private static final String DATABASE_TABLE_CREATE =
	                    "CREATE VIRTUAL TABLE " + DATABASE_TABLE +
	                    " USING fts3 (" +
	                    KEY_NAME + ", " +
	                    KEY_DETAILS + ");";

	        DirectoryOpenHelper(Context context) {
	            super(context, DATABASE_NAME, null, DATABASE_VERSION);
	            mHelperContext = context;
	        }

	        @Override
	        public void onCreate(SQLiteDatabase db) {
	            mDatabase = db;
	            mDatabase.execSQL(DATABASE_TABLE_CREATE);
	            loadDirectory();
	        }

	        /**
	         * Starts a thread to load the database table with words
	         */
	        private void loadDirectory() {
	            new Thread(new Runnable() {
	                public void run() {
	                    try {
	                        loadPeople();
	                    } catch (IOException e) {
	                        throw new RuntimeException(e);
	                    }
	                }
	            }).start();
	        }

	        private void loadPeople() throws IOException {
	            Log.d(TAG, "Loading people...");
	            final Resources resources = mHelperContext.getResources();
	            InputStream inputStream = resources.openRawResource(R.raw.directory);
	            Log.d(TAG, "1");
	            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
	            Log.d(TAG, "2");

	            try {
	                String line;
	                while ((line = reader.readLine()) != null) {
	                    String[] strings = TextUtils.split(line, ",");
	                    if (strings.length < 10) continue;
	                    String[] result = new String[2];
	                    result[0] = strings[0];
	                    result[1] = strings[1];
	                    for(int i = 2; i < 10; i++)
	                    {
	                    	
	                    	result[1] = result[1] + "," + strings[i];
	                    }
	                    long id = addPeople(result[0].trim(), result[1].trim());
	                    if (id < 0) {
	                        Log.e(TAG, "unable to add people: " + result[0].trim());
	                    }
	                }
	            } finally {
	                reader.close();
	            }
	            Log.d(TAG, "DONE loading names.");
	        }

	        /**
	         * Add a word to the dictionary.
	         * @return rowId or -1 if failed
	         */
	        public long addPeople(String name, String details) {
	            ContentValues initialValues = new ContentValues();
	            initialValues.put(KEY_NAME, name);
	            initialValues.put(KEY_DETAILS, details);

	            return mDatabase.insert(DATABASE_TABLE, null, initialValues);
	        }

	        @Override
	        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
	            Log.w(TAG, "Upgrading database from version " + oldVersion + " to "
	                    + newVersion + ", which will destroy all old data");
	            db.execSQL("DROP TABLE IF EXISTS " + DATABASE_TABLE);
	            onCreate(db);
	        }
	    }
}
