package com.example.andriod_weibo;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class ListAdapterImprove_2 extends ArrayAdapter {
    private int resourceId;

    public ListAdapterImprove_2(Context context, int textViewResourceId){
        super(context, textViewResourceId);
        resourceId = textViewResourceId;

    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        MyList myList = (MyList) getItem(position);
        View view =null;
        ViewHolder  viewHolder;
        if(convertView == null){
            view = LayoutInflater.from(getContext()).inflate(resourceId, null);
            viewHolder =new ViewHolder();
            viewHolder.img1 =(ImageView) view.findViewById(R.id.img1);
            viewHolder.user =(TextView) view.findViewById(R.id.user);
            view.setTag(viewHolder);
        }else{
            view = convertView;
            viewHolder = (ViewHolder) convertView.getTag();
        }
        viewHolder.img1.setImageResource(myList.getImgId());
        viewHolder.user.setText(myList.getName());
        return view;
    }

    class ViewHolder {

        ImageView img1;

        TextView user;

    }

}
