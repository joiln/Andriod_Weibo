package com.example.andriod_weibo;


import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.VideoView;

public class Video_fgmt extends Fragment {
    private ImageView src1,src2,src3;
    public Video_fgmt() {

    }



    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.video_fgmt, container, false);
        src1=(ImageView)view.findViewById(R.id.video_img_1);
        src2=(ImageView)view.findViewById(R.id.video_img_2);
        src3=(ImageView)view.findViewById(R.id.video_img_3);
        src1.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity( new Intent( getActivity(),video1.class ) );
            }
        } );
        src2.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity( new Intent( getActivity(),video2.class ) );
            }
        } );
        src3.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity( new Intent( getActivity(),video3.class ) );
            }
        } );
       return view;
    }


}