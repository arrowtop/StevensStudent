package com.example.test4;

import android.app.SearchManager;
import android.content.ContentProvider;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.UriMatcher;
import android.database.Cursor;
import android.net.Uri;
import android.provider.BaseColumns;

public class CourseProvider extends ContentProvider {
	
	String TAG = "CourseProvider";
	
	public static String AUTHORITY = "com.example.CourseProvider";
	  
	public static final Uri CONTENT_URI = 
		      Uri.parse("content://" + AUTHORITY + "/course");
	
	public static final String COURSE_MIME_TYPE = ContentResolver.CURSOR_DIR_BASE_TYPE +
            "/vnd.example.android.searchabledict";
	public static final String DETAILS_MIME_TYPE = ContentResolver.CURSOR_ITEM_BASE_TYPE +
                 "/vnd.example.android.searchabledict";
    
    private CourseDB mCourse;
    
    private static final int SEARCH_COURSE = 0;
    private static final int GET_COURSE = 1;
    private static final int SEARCH_SUGGEST = 2;
    
    private static final UriMatcher sURIMatcher = buildUriMatcher();
    
    private static UriMatcher buildUriMatcher() {
        UriMatcher matcher =  new UriMatcher(UriMatcher.NO_MATCH);
        // to get definitions...
        matcher.addURI(AUTHORITY, "course", SEARCH_COURSE);
        matcher.addURI(AUTHORITY, "course/#", GET_COURSE);
        // to get suggestions...
        matcher.addURI(AUTHORITY, SearchManager.SUGGEST_URI_PATH_QUERY, SEARCH_SUGGEST);
        matcher.addURI(AUTHORITY, SearchManager.SUGGEST_URI_PATH_QUERY + "/*", SEARCH_SUGGEST);

        return matcher;
    }
    
    public boolean onCreate() {
    	mCourse = new CourseDB(getContext());
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
            case SEARCH_COURSE:
                if (selectionArgs == null) {
                  throw new IllegalArgumentException(
                      "selectionArgs must be provided for the Uri: " + uri);
                }
                return search(selectionArgs[0]);
            case GET_COURSE:
                return getCourse(uri);
            default:
                throw new IllegalArgumentException("Unknown Uri: " + uri);
        }
    }
    
    private Cursor getSuggestions(String query) {
        query = query.toLowerCase();
        String[] columns = new String[] {
            BaseColumns._ID,
            CourseDB.KEY_NAME,
            CourseDB.KEY_DETAILS,
         /* SearchManager.SUGGEST_COLUMN_SHORTCUT_ID,
                          (only if you want to refresh shortcuts) */
            SearchManager.SUGGEST_COLUMN_INTENT_DATA_ID};

        return mCourse.getCourseMatches(query, columns);
      }
    
    private Cursor search(String query) {
        query = query.toLowerCase();
        String[] columns = new String[] {
            BaseColumns._ID,
            CourseDB.KEY_NAME,
            CourseDB.KEY_DETAILS};

        return mCourse.getCourseMatches(query, columns);
      }

      private Cursor getCourse(Uri uri) {
        String rowId = uri.getLastPathSegment();
        String[] columns = new String[] {
            CourseDB.KEY_NAME,
            CourseDB.KEY_DETAILS};

        return mCourse.getCourse(rowId, columns);
      }
      
      @Override
      public String getType(Uri uri) {
          switch (sURIMatcher.match(uri)) {
              case SEARCH_COURSE:
                  return COURSE_MIME_TYPE;
              case GET_COURSE:
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
