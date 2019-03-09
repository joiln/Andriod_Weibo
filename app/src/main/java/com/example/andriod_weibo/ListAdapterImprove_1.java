package com.example.andriod_weibo;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class ListAdapterImprove_1 extends ArrayAdapter {
    private int resourceId;
    public ListAdapterImprove_1(Context context,int textViewResourceId){
        super(context,textViewResourceId);
        resourceId = textViewResourceId;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        MyList myList =(MyList) getItem(position);
        View view = null;
        if(convertView==null){
            view = LayoutInflater.from(getContext()).inflate(resourceId,null);
        }else
            view = convertView;
        ImageView ListImg = (ImageView) view.findViewById(R.id.img1);
        TextView ListName = (TextView) view.findViewById(R.id.user);
        ListImg.setImageResource(myList.getImgId());
        ListName.setText(myList.getName());
        return view;
    }
}
