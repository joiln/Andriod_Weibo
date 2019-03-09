package com.example.andriod_weibo;

import android.Manifest;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;

import com.google.zxing.client.android.CaptureActivity;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity  {
    private static final String TAG = "MainActivity";

    public static final int PAGE_ONE = 0;
    public static final int PAGE_TWO = 1;
    public static final int PAGE_THREE = 2;
    public static final int PAGE_FOUR = 3;
    public static final int PAGE_FIVE = 4;


    //public ListView listView;
    //private List<MyList>mlist = new ArrayList<MyList>();

    private String name,a="1";

    private ViewPager vp;
    private Home_fgmt home_fgmt;
    private Video_fgmt video_fgmt;
    private Find_fgmt find_fgmt;
    private News_fgmt news_fgmt;
    private Hot_fgmt hot_fgmt;

    private RadioButton camera;
    private RadioButton plus;

    private RadioGroup radioGroup_bottom;
    private RadioButton home;
    private RadioButton video;
    private RadioButton find;
    private RadioButton news;
    private RadioButton mine;

    private RadioGroup radioGroup_top;
    private RadioButton home_focus;
    private RadioButton home_hot;

    private List<Fragment> mFragmentList = new ArrayList<Fragment>();
    private FragmentAdapter mFragmentAdapter;


    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);
        //准备好数据
        initView();

        //新方法
        //给Fragment添加适配器
        mFragmentAdapter = new FragmentAdapter(this.getSupportFragmentManager(), mFragmentList);

        vp.setOffscreenPageLimit(5);//缓存Viewpager未4帧
        vp.setAdapter(mFragmentAdapter);
        vp.setCurrentItem(0);//设置初始viewpager未第一帧
        home.setChecked(true);
        home_focus.setChecked(true);

        radioGroup_bottom.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId){
                    case R.id.home:
                        vp.setCurrentItem(PAGE_ONE);
                        home_focus.setChecked(true);
                        break;
                    case R.id.video:
                        home_hot.setChecked(false);
                        vp.setCurrentItem(PAGE_TWO);
                        break;
                    case R.id.find:
                        vp.setCurrentItem(PAGE_THREE);
                        break;
                    case R.id.news:
                        vp.setCurrentItem(PAGE_FOUR);
                        break;
                }
            }
        });

        radioGroup_top.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId){
                    case R.id.home_focus:
                        home.setChecked(true);
                        vp.setCurrentItem(PAGE_ONE);
                        break;
                }
            }
        });

        //Viewpager的监听事件
        vp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                /*此方法在页面被选中时调用*/

            }

            @Override
            public void onPageScrollStateChanged(int state) {
                if(state == 2){
                    int currentItemPosition = vp.getCurrentItem();
                    switch (currentItemPosition){
                        case PAGE_ONE:
                            home.setChecked(true);
                            home_focus.setChecked(true);
                            break;
                        case PAGE_TWO:
                            video.setChecked(true);
                            break;
                        case PAGE_THREE:
                            find.setChecked(true);
                            break;
                        case PAGE_FOUR:
                            news.setChecked(true);
                            break;
                    }
                }
            }
        });

        vp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


            }
        });

        //相机控制
        camera.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.CAMERA) == PackageManager.PERMISSION_DENIED) {
                    ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.CAMERA}, 1);
                }else {
                    Intent intent = new Intent(MainActivity.this, CaptureActivity.class);
                    startActivity(intent);
                }

//                Toast.makeText(MainActivity.this,"打开相机失败,请重试！",Toast.LENGTH_SHORT).show();
            }
        });

        //右上角“+”控制
        plus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(true){
                    Toast.makeText(MainActivity.this,"添加消息失败,请重试！",Toast.LENGTH_SHORT).show();
                }
            }
        });

        //点击“我”的控制
        mine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                SharedPreferences sp1 = getSharedPreferences( "information",MODE_PRIVATE );
                name=sp1.getString( a,"");
                if(name.equals("2")){

                    Intent intent = new Intent( MainActivity.this,Mine.class );
                    startActivity( intent );
                }else{
                    Intent intent = new Intent( MainActivity.this,loginActivity.class );
                    startActivity( intent );
                }
            }
        });
    }

    private void initView() {
        radioGroup_bottom = findViewById(R.id.bottom_menu);
        radioGroup_top = findViewById(R.id.radioGroup_top);
        camera = findViewById(R.id.camera);
        plus = findViewById(R.id.plus);
        home = findViewById(R.id.home);
        video = findViewById(R.id.video);
        find = findViewById(R.id.find);
        news = findViewById(R.id.news);
        mine =  findViewById(R.id.mine);
        home_focus = findViewById(R.id.home_focus);
        home_hot = findViewById(R.id.home_hot);



        vp = findViewById(R.id.mainViewPager);
        home_fgmt = new Home_fgmt();

        hot_fgmt = new Hot_fgmt();

        video_fgmt = new Video_fgmt();
        find_fgmt = new Find_fgmt();
        news_fgmt = new News_fgmt();


        mFragmentList.add(home_fgmt);
        mFragmentList.add(video_fgmt);
        mFragmentList.add(find_fgmt);
        mFragmentList.add(news_fgmt);


    }


//    public void InitList(){
//        MyList apple = new MyList("孤月今心", R.drawable.ic_mine);
//        mlist.add(apple);
//        MyList banana = new MyList("泪依言欣", R.drawable.ic_mine);
//        mlist.add(banana);
//        MyList orange = new MyList("千里追随", R.drawable.ic_mine);
//        mlist.add(orange);
//        MyList watermelon = new MyList("岁月痕迹", R.drawable.ic_mine);
//        mlist.add(watermelon);
//        MyList pear = new MyList("细语凝香", R.drawable.ic_mine);
//        mlist.add(pear);
//        MyList grape = new MyList("浅笑嫣然", R.drawable.ic_mine);
//        mlist.add(grape);
//        MyList pineapple = new MyList("霓裳羽衣", R.drawable.ic_mine);
//        mlist.add(pineapple);
//        MyList strawberry = new MyList("旧时月色 :", R.drawable.ic_mine);
//        mlist.add(strawberry);
//        MyList cherry = new MyList("ˇ故人西辞-", R.drawable.ic_mine);
//        mlist.add(cherry);
//        MyList mango = new MyList("一曲离殇", R.drawable.ic_mine);
//        mlist.add(mango);
//
//    }

//    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
//        getMenuInflater().inflate(R.menu.menu_main,menu);
//        return true;
//    }
}
