package com.example.andriod_weibo;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.support.constraint.solver.widgets.Helper;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import java.util.Timer;
import java.util.TimerTask;

public class registActivity extends AppCompatActivity {
    private EditText Name;
    private EditText Password;
    private String name,password;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.regist );
        init();
  }

    private void init() {
        Button regist = findViewById( R.id.regist );
        Name=(EditText) findViewById( R.id.name );
        Password=(EditText)findViewById( R.id.password );
        regist.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                name=Name.getText().toString().trim();
                password=Password.getText().toString().trim();
                if (TextUtils.isEmpty( name )){
                    Toast.makeText( registActivity.this,"请输入账号",Toast.LENGTH_SHORT ).show();
                }else if (TextUtils.isEmpty( password )){
                    Toast.makeText( registActivity.this,"请输入密码",Toast.LENGTH_SHORT ).show();
                }else if (!isExistName(name)){
                    Toast.makeText( registActivity.this,"此账号已存在",Toast.LENGTH_SHORT ).show();
                }else {
                    Toast.makeText( registActivity.this,"注册成功",Toast.LENGTH_SHORT ).show();
                    saveRegisterInfo(name, password);
                    Intent data = new Intent();
                    data.putExtra("name", name);
                    setResult(RESULT_OK, data);
                    registActivity.this.finish();
                }
            }
        } );
    }

    private void saveRegisterInfo(String name, String password) {
        SharedPreferences sp=getSharedPreferences( "information",MODE_PRIVATE );
        SharedPreferences.Editor editor=sp.edit();
        editor.putString( name,password );
        editor.apply();
    }

    private boolean isExistName(String name) {
        boolean hasname=false;
        SharedPreferences sp=getSharedPreferences(  "information",MODE_PRIVATE);
        String psw=sp.getString( name,"" );
        if (TextUtils.isEmpty( psw )){
            hasname=true;
        }
        return hasname;
    }

    private void getEditString() {
        name=Name.getText().toString().trim();
        password=Password.getText().toString().trim();
    }
//    public void regist(View view){
//        String name=Name.getText().toString().trim();
//        String password=Password.getText().toString().trim();
//        if (TextUtils.isEmpty( name )||TextUtils.isEmpty( password )){
//            Toast.makeText( this,"账号或密码不能为空",Toast.LENGTH_SHORT ).show();
//            return;
//        }
//        else if(isExistUserName(name)){
//            Toast.makeText(this, "此账户名已经存在", Toast.LENGTH_SHORT).show();
//
//        } else{
//            Openhelper.add( name,password );
//            Toast.makeText( this,"注册成功，请用注册的账号和密码进行登录",Toast.LENGTH_SHORT ).show();
//            Timer timer = new Timer(  );
//            TimerTask timerTask = new TimerTask() {
//                @Override
//                public void run() {
//                    Intent intent = new Intent( SecondActivity.this,MainActivity.class );
//                    startActivity( intent );
//                    SecondActivity.this.finish();
//
//                }
//            };
//            timer.schedule( timerTask,1000*3 );
//        }
//    }
//    public class abc{
//        private DBopen helper;
//        public abc()
//    }

}

