package com.example.test4;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Timer;
import java.util.TimerTask;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.IBinder;
import android.preference.PreferenceManager;
import android.util.Log;

public class DiningHttpService extends Service {

	public static int position;
	private static int count = 0;
	private final static String URL = "http://155.246.170.11/StevensStudent/androidDB.jsp";
	private static String[] diningData = new String[1000];
	private static String[] days = {"MONDAY", "TUESDAY", "WEDNESDAY", "HURSDAY", "FRIDAY"};
	private static String[] times = {"Breakfast", "Lunch", "Dinner"};

	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {

		String data = intent.getStringExtra("data");
		position = Integer.parseInt(data);
		Log.d("tag", data);

		Thread t = new Thread(new Runnable() {
			public void run() {
				fetchDining();
			}
		});
		t.start();

		return Service.START_NOT_STICKY;
	};

	public void fetchDining() {

		try {
			URL url = new URL(URL);
			Log.d("tag", "Fetch dining.");
			HttpURLConnection urlConn = (HttpURLConnection) url
					.openConnection();
			InputStreamReader in = new InputStreamReader(
					urlConn.getInputStream());
			BufferedReader buffer = new BufferedReader(in);
			String line = null;
			while (((line = buffer.readLine()) != null) && count < 185) {
				Log.d("tag", line);
				String[]temp = line.split(",");
				if(temp.length == 4){
					line = line.replace(';', ' ');
					diningData[count] = line.trim();
					count++;
				}
			}
			in.close();
			urlConn.disconnect();
			
			direct();

		} catch (IOException e) {
			Log.e("tag", "IO Exception", e);
		}

	}
	
	public void direct(){
		if(count != 0){
			String breakfast = null;
			String lunch = null;
			String dinner = null;
			Log.d("tag", position+"");
			String temp3 = null;
			for(int i = 0; i < count; i ++){
				String[] temp = diningData[i].split(",");
				if(!temp[0].equals(days[position])){
					continue;
				}
				else{
					if(temp[1].equals(times[0])){
						if(!temp[2].equals(temp3)){
							temp3 = temp[2];
							if(breakfast == null){
								breakfast = "<b>" + temp[2] + "</b>:<br />-" + temp[3];
							}
							else{
								breakfast = breakfast + "<br /><b>" + temp[2] + "</b>:<br />-" + temp[3];
							}
							
						}
						else{
							breakfast = breakfast + "<br />-" + temp[3];
						}
					}
					if(temp[1].equals(times[1])){
						if(!temp[2].equals(temp3)){
							temp3 = temp[2];
							if(lunch == null){
								lunch = "<b>" +temp[2] + "</b>:<br />-" + temp[3];
							}
							else{
								lunch = lunch + "<br /><b>" + temp[2] + "</b>:<br />-"  + temp[3];
							}
							
						}
						else{
							lunch = lunch + "<br />-" + temp[3];
						}
					}
					if(temp[1].equals(times[2])){
						if(!temp[2].equals(temp3)){
							temp3 = temp[2];
							if(dinner == null){
								dinner = "<b>" + temp[2] + "</b>:<br />-" + temp[3];
							}
							else{
								dinner = dinner + "<br /><b>"  + temp[2] + "</b><br />-" + temp[3];
							}
							
						}
						else{
							dinner = dinner + "<br />-" + temp[3];
						}
					}
				}
				
			}
			Intent intent = new Intent().setClass(DiningHttpService.this, Dining.class);
            intent.putExtra("breakfast", breakfast);
            intent.putExtra("lunch", lunch);
            intent.putExtra("dinner", dinner);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            stopService(new Intent(this, DiningHttpService.class));
		}
	}

}
