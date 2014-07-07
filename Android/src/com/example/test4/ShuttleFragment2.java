package com.example.test4;

import java.util.Calendar;

import android.app.ListFragment;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

public class ShuttleFragment2 extends ListFragment{
	
	private static final String[] shuttle_station = new String[] {"6th and Hudson St", "Newark and Hudson St", "4th and Madison St", 
		"7th and Madison St", "8th and Madison St", "12th and Grand St", "11th and Park Ave", "11th and Washington St", "Howe Center"};
	private static final int[] shuttle_time = new int[] { 30, 33, 35, 37, 38, 42, 45, 46, 50};
	private static final int[] space = new int[]{10, 2, 8, 8, 8, 11, 10, 0, 20};
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		Calendar c = Calendar.getInstance();
		int hour = c.get(Calendar.HOUR);
		int minute = c.get(Calendar.MINUTE);
		String[] result = new String[9];


		for(int i = 0; i < 9; i++){
			int result_hour = 0;
			int result_minute = 0;
			if(minute <= shuttle_time[i] - 30){
				result_hour = hour;
				result_minute = shuttle_time[i] - 30;
			}
			
			if((shuttle_time[i] - 30 < minute) && (minute <= shuttle_time[i])){
				result_hour = hour;
				result_minute = shuttle_time[i];
			}
			
			if(minute > shuttle_time[i]){
				if(hour == 23){
					result_hour = 0;
				}else{
					result_hour = hour + 1;
				}
				result_minute = shuttle_time[i] - 30;
			}
			
			result[i] = shuttle_station[i];
			for(int j = 0; j < space[i] + 20; j++){
				result[i] += "\u00A0";
			}
			result[i] =	result[i] + result_hour + ":" + result_minute;
		}

		//t1.setText("Now the time is " + hour + ":" + minute);
		
		//TextView t2 = (TextView)findViewById(R.id.textView2);
		//t2.setText("Below is the arrival time of the shuttle for each station:");
		
		setListAdapter(new ArrayAdapter<String>(getActivity(), R.layout.shuttle2, result));

		//ListView listView = getListView();
		//listView.setDivider(null);
		//listView.setTextFilterEnabled(true);

	}
	
	public void onListItemClick(ListView parent, View v, int position, long id) {
		Intent intent = new Intent(getActivity(), ShuttleDetails.class);
        int data = position;
        intent.putExtra("data", data);
		getActivity().startActivity(intent);
	}

}
