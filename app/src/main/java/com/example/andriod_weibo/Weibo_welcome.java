package com.example.andriod_weibo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import java.util.Timer;
import java.util.TimerTask;

public class Weibo_welcome extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.weibo_welcome);
        Timer timer = new Timer();

        TimerTask timerTask = new TimerTask(){
            @Override
            public void run() {
                Intent intent = new Intent(Weibo_welcome.this,MainActivity.class);
                startActivity(intent);
                Weibo_welcome.this.finish();
            }
        };
        timer.schedule(timerTask,1000);
    }
}


