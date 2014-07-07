package com.example.test4;

import android.app.ListFragment;

import android.app.ListFragment;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ListView;
import android.widget.Toast;

public class newsfeedFragment extends ListFragment{

	ListView listView;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Model.LoadModel();
        String[] ids = new String[Model.Items.size()];
        for (int i= 0; i < ids.length; i++){

            ids[i] = Integer.toString(i+1);
        }

        ItemAdapter adapter = new ItemAdapter(getActivity(), R.layout.friendsfragment, ids);
        setListAdapter(adapter);
	}

	public void onListItemClick(ListView parent, View v, int position, long id) {
		getActivity().startActivity(new Intent(getActivity(), ThirdActivity.class));
	}
}

