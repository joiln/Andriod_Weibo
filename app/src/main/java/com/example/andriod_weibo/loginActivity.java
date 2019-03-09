package com.example.andriod_weibo;

import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class loginActivity extends AppCompatActivity {
    private EditText Name;
    private EditText Password;
    private String name, password, psw, spPsw;
    public String a="1";
//    private Contact Openhelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.login );
//        DBopen helper = new DBopen( this );
//        helper.getWritableDatabase();
//        Name=findViewById( R.id.name );
//        Password=findViewById( R.id.password );
//        Openhelper=new Contact(this);
        init();
    }

    private void init() {
        Name = findViewById( R.id.name );
        Password = findViewById( R.id.password );
        name = Name.getText().toString().trim();
        password = Password.getText().toString().trim();
        TextView regist = findViewById( R.id.regist );
        regist.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent( loginActivity.this, registActivity.class );
                startActivity( intent );
            }
        } );
        Button login = findViewById( R.id.enter );
        login.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                name = Name.getText().toString().trim();
                password = Password.getText().toString().trim();
                spPsw = readPsw( name );
                if (TextUtils.isEmpty( name )) {
                    Toast.makeText( loginActivity.this, "请输入用户名", Toast.LENGTH_SHORT ).show();
                } else if (TextUtils.isEmpty( password )) {
                    Toast.makeText( loginActivity.this, "请输入密码", Toast.LENGTH_SHORT ).show();
                }else if(!password.equals(spPsw)){
                    Toast.makeText(loginActivity.this,"登录名或密码错误",Toast.LENGTH_LONG).show();
                }
                    else if (password.equals( spPsw )) {
                    saveLoginStatus("2");
                   // Intent intent = new Intent( loginActivity.this, MainActivity.class );
                    Toast.makeText(loginActivity.this,"登录成功",Toast.LENGTH_LONG).show();
                   // startActivity( intent );
                    loginActivity.this.finish();
                }
            }


        } );
    }

    public void saveLoginStatus( String b) {
        SharedPreferences sp = getSharedPreferences( "information", MODE_PRIVATE );
        SharedPreferences.Editor editor = sp.edit();
        editor.putString( "login",b );
        editor.putString( "a","1" );
        editor.putString( a,b );
        editor.apply();
    }

    private String readPsw(String name) {
        SharedPreferences sp = getSharedPreferences( "information", MODE_PRIVATE );
        return sp.getString( name, "" );
    }



    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult( requestCode, resultCode, data );
        if (data != null) {
            String name = data.getStringExtra( "name" );
            if (!TextUtils.isEmpty( name )) {
                Name.setText( name );
                Name.setSelection( name.length() );
            }
        }
//    public void enter(View view) {
//        Intent intent = new Intent( MainActivity.this, SecondActivity.class );
//        startActivity( intent );
//    }
//    public void regist(View view){
//        String name=Name.getText().toString().trim();
//        String password=Password.getText().toString().trim();
//        if (TextUtils.isEmpty( name )||TextUtils.isEmpty( password )){
//            Toast.makeText( this,"账号或密码不能为空",Toast.LENGTH_SHORT ).show();
//            return;
//        }
//        else{
//            Openhelper.add( name,password );
//            Toast.makeText( this,"添加成功",Toast.LENGTH_SHORT ).show();
//
//        }
//    }
    }
}

