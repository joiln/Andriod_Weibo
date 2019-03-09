package com.example.andriod_weibo;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.VideoView;

public class video1 extends AppCompatActivity{
    private VideoView video;
    private ImageView img;
    private MediaController mediaController1;
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.video_1 );
        video=findViewById( R.id.video);
        img=findViewById( R.id.back );
        mediaController1 = new MediaController( this);
        String uri = "android.resource://" + getPackageName() + "/" + R.raw.video_1;
        video.setVideoURI( Uri.parse( uri ));
        video.setMediaController( mediaController1 );
        mediaController1.setMediaPlayer( video );
        video.requestFocus();
        video.start();
        img.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        } );
    }
}
