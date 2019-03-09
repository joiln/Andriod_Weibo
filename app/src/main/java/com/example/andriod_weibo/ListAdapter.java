package com.example.andriod_weibo;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

public class ListAdapter extends ArrayAdapter<MyList> {
    private int resourceId;

    public ListAdapter(Context context, int textViewResourceId, List<MyList> data) {
        super(context, textViewResourceId, data);

        resourceId = textViewResourceId;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        MyList list = getItem(position);

        View view = LayoutInflater.from(getContext()).inflate(resourceId, null);

        ImageView img1 =  view.findViewById(R.id.img1);
        TextView user = view.findViewById(R.id.user);
        TextView publish = view.findViewById(R.id.publish);
        TextView weibo_content = view.findViewById(R.id.weibo_content);
        ImageView content_img = view.findViewById(R.id.weibo_content_img);

        img1.setImageResource(list.getImgId());
        user.setText(list.getName());
        publish.setText(list.getPublish());
        weibo_content.setText(list.getContent());
        content_img.setImageResource(list.getContent_img());

        return view;
    }
}
