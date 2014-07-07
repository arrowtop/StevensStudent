package com.example.test4;

import android.app.SearchManager;
import android.content.ContentProvider;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.UriMatcher;
import android.database.Cursor;
import android.net.Uri;
import android.provider.BaseColumns;

public class DirectoryProvider extends ContentProvider {
	
	String TAG = "DirectoryProvider";
	
	public static String AUTHORITY = "com.example.DirectoryProvider";
	  
	public static final Uri CONTENT_URI = 
		      Uri.parse("content://" + AUTHORITY + "/directory");
	
	public static final String PEOPLE_MIME_TYPE = ContentResolver.CURSOR_DIR_BASE_TYPE +
            "/vnd.example.android.searchabledict";
	public static final String DETAILS_MIME_TYPE = ContentResolver.CURSOR_ITEM_BASE_TYPE +
                 "/vnd.example.android.searchabledict";
    
    private DirectoryDB mDirectory;
    
    private static final int SEARCH_PEOPLE = 0;
    private static final int GET_PEOPLE = 1;
    private static final int SEARCH_SUGGEST = 2;
    
    private static final UriMatcher sURIMatcher = buildUriMatcher();
    
    private static UriMatcher buildUriMatcher() {
        UriMatcher matcher =  new UriMatcher(UriMatcher.NO_MATCH);
        // to get definitions...
        matcher.addURI(AUTHORITY, "directory", SEARCH_PEOPLE);
        matcher.addURI(AUTHORITY, "directory/#", GET_PEOPLE);
        // to get suggestions...
        matcher.addURI(AUTHORITY, SearchManager.SUGGEST_URI_PATH_QUERY, SEARCH_SUGGEST);
        matcher.addURI(AUTHORITY, SearchManager.SUGGEST_URI_PATH_QUERY + "/*", SEARCH_SUGGEST);

        return matcher;
    }
    
    public boolean onCreate() {
    	mDirectory = new DirectoryDB(getContext());
        return true;
    }

    @Override
    public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs,
                        String sortOrder) {

        // Use the UriMatcher to see what kind of query we have and format the db query accordingly
        switch (sURIMatcher.match(uri)) {
            case SEARCH_SUGGEST:
                if (selectionArgs == null) {
                  throw new IllegalArgumentException(
                      "selectionArgs must be provided for the Uri: " + uri);
                }
                return getSuggestions(selectionArgs[0]);
            case SEARCH_PEOPLE:
                if (selectionArgs == null) {
                  throw new IllegalArgumentException(
                      "selectionArgs must be provided for the Uri: " + uri);
                }
                return search(selectionArgs[0]);
            case GET_PEOPLE:
                return getPeople(uri);
            default:
                throw new IllegalArgumentException("Unknown Uri: " + uri);
        }
    }
    
    private Cursor getSuggestions(String query) {
        query = query.toLowerCase();
        String[] columns = new String[] {
            BaseColumns._ID,
            DirectoryDB.KEY_NAME,
            DirectoryDB.KEY_DETAILS,
         /* SearchManager.SUGGEST_COLUMN_SHORTCUT_ID,
                          (only if you want to refresh shortcuts) */
            SearchManager.SUGGEST_COLUMN_INTENT_DATA_ID};

        return mDirectory.getPeopleMatches(query, columns);
      }
    
    private Cursor search(String query) {
        query = query.toLowerCase();
        String[] columns = new String[] {
            BaseColumns._ID,
            DirectoryDB.KEY_NAME,
            DirectoryDB.KEY_DETAILS};

        return mDirectory.getPeopleMatches(query, columns);
      }

      private Cursor getPeople(Uri uri) {
        String rowId = uri.getLastPathSegment();
        String[] columns = new String[] {
            DirectoryDB.KEY_NAME,
            DirectoryDB.KEY_DETAILS};

        return mDirectory.getPeople(rowId, columns);
      }
      
      @Override
      public String getType(Uri uri) {
          switch (sURIMatcher.match(uri)) {
              case SEARCH_PEOPLE:
                  return PEOPLE_MIME_TYPE;
              case GET_PEOPLE:
                  return DETAILS_MIME_TYPE;
              case SEARCH_SUGGEST:
                  return SearchManager.SUGGEST_MIME_TYPE;
              default:
                  throw new IllegalArgumentException("Unknown URL " + uri);
          }
      }
    
    
    // Other required implementations...
    
    @Override
    public Uri insert(Uri uri, ContentValues values) {
        throw new UnsupportedOperationException();
    }

    @Override
    public int delete(Uri uri, String selection, String[] selectionArgs) {
        throw new UnsupportedOperationException();
    }

    @Override
    public int update(Uri uri, ContentValues values, String selection, String[] selectionArgs) {
        throw new UnsupportedOperationException();
    }
	

}
