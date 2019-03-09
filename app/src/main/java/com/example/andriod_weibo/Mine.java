package com.example.andriod_weibo;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class Mine extends AppCompatActivity {
    private Button zx;
    private String a="1";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.mine_information);
        zx=findViewById( R.id.logout );
        zx.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SharedPreferences sp1 = getSharedPreferences( "information",MODE_PRIVATE );
                SharedPreferences.Editor editor=sp1.edit();
                editor.putString( a,"1" );
                editor.apply();
                Toast.makeText(Mine.this,"退出成功",Toast.LENGTH_SHORT).show();
                finish();
            }
        } );
    }
}
