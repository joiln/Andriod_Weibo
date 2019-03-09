package com.example.andriod_weibo;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;

import java.util.List;

public class VideoListAdapter extends ArrayAdapter<VideoList> {
    private int resourceId;
    public VideoListAdapter(Context context,int textViewResourceId, List<VideoList> data){
        super(context,textViewResourceId,data);

        this.resourceId = textViewResourceId;

    }


    @Override
    public View getView(int position, View convertView,  ViewGroup parent) {
        VideoList list = getItem(position);

        View view = LayoutInflater.from(getContext()).inflate(resourceId, null);

        ImageView imageView = view.findViewById(R.id.video_img_item);
        imageView.setImageResource(list.getVideoImgId());
        return view;

    }
}
