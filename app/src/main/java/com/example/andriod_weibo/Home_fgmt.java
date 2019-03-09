package com.example.andriod_weibo;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.List;

public class Home_fgmt extends Fragment {
    private ListView listView;
    private ListAdapter listAdapter;


    private List<MyList> mlist = new ArrayList<>();

    public Home_fgmt(){

    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.home_fgmt, container,false);
        listView  = (ListView) view.findViewById(R.id.Home_ListView);
        listAdapter = new ListAdapter (getActivity().getApplicationContext(),R.layout.home_listview_item,mlist);
        listView.setAdapter(listAdapter);

        InitList();
//        ArrayAdapter<String> arrayAdapter = new ArrayAdapter<String>(getActivity(),
//         android.R.layout.simple_list_item_1,getData());


        return  view;

    }

//    private List<String> getData() {
//        List<String> data = new ArrayList<String>();
//        for(int i =0;i<20;i++){
//            data.add(i+"");
//        }
//        return  data;
//    }



        /*
        写入数据对应到Item中
         */
    public void InitList(){

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
              if(position==0){

                  Intent intent = new Intent(getActivity(), Weibo_Content.class);
                  startActivity(intent);
              }
              if(position==1){
                    Intent intent_1 = new Intent(getActivity(), Weibo_Content_1.class);
                    startActivity(intent_1);
              }
              if(position==2){
                      Intent intent_2 = new Intent(getActivity(), Weibo_Content_2.class);
                      startActivity(intent_2);

              }
            }
        });

        MyList apple = new MyList("重科小智",R.drawable.ic_people1,"今天 15:31",
                "   距离开学已经有一段时间了，想必大家也制定好了本学期的目标吧，" +
                        "有梦想就要努力去实现。愿大家的未来都能像今天的太阳般熠熠生辉!",R.mipmap.content_img_1);
        mlist.add(apple);
        MyList banana = new MyList("幽默段王爷", R.drawable.ic_people2,"今天 14:12",
                "   正在加班，老板娘走来把一杯冒着热气的奶茶放我桌上。 我心头飘过一丝暖意，小公司工资不高，" +
                        "人情味还是挺足的。然后她甩了甩手：“烫死我了。“又拿起来走了",R.mipmap.content_img_2);
        mlist.add(banana);
        MyList grape = new MyList("浅笑嫣然", R.drawable.ic_people2,"今天 14:02","   你要储蓄你的可爱 眷顾你的善良 变得勇敢 ",R.mipmap.content_img_6);
        mlist.add(grape);
        MyList orange = new MyList("隔壁老王", R.drawable.ic_people3,"今天 13:48",
                "   有次牙痛去看医生，医生说我的牙有点磨损，问我晚上睡觉磨不磨牙？我说不知道啊，" +
                        "睡着了怎么能知道自己是不是磨牙啊。医生说，噢，单身啊。",R.mipmap.content_img_3);
        mlist.add(orange);
        MyList watermelon = new MyList("岁月痕迹", R.drawable.ic_people4,"今天 13:21","   “你要跟猫学一下，保持冷漠，适度撒娇，几乎不动心。”.",R.mipmap.content_img_4);
        mlist.add(watermelon);
        MyList pear = new MyList("中国新闻周刊", R.drawable.ic_people5,"今天 12:16","   【何立峰：八大举措促进形成强大国内市场】#周刊君带你看两会#国家发改委主任何立峰：" +
                "中央经济工作会议之后，国家发改委会同相关部门出台八大举措。中国形成强大国内市场有必要也有可能，只要认真落实好巩固、增强、提升、" +
                "畅通八字方针，深入推进供给侧结构性改革，不断提供更多优质产品和服务，国内市场会越来越庞大，必将促进经济平稳健康可持续发展。口人民网的秒拍视频",R.mipmap.content_img_5);
        mlist.add(pear);
        MyList pineapple = new MyList("霓裳羽衣", R.drawable.ic_people7,"今天 11:46","   经常说你傻的人，不会嫌弃你傻，经常说你笨的人，不会在意你笨，经常说你丑的人不会介意你丑，" +
                "经常说你胖的人……你就削他，往死削，臭不要脸的，吃你家大米了？（#）/【搞笑】",R.mipmap.content_img_7);
        mlist.add(pineapple);
//        MyList strawberry = new MyList("旧时月色 :", R.drawable.ic_people8);
//        mlist.add(strawberry);
//        MyList cherry = new MyList("ˇ故人西辞-", R.drawable.ic_people9);
//        mlist.add(cherry);
//        MyList mango = new MyList("一曲离殇", R.drawable.ic_people10);
//        mlist.add(mango);

    }
}
