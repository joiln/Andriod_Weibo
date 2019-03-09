package com.example.andriod_weibo;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.List;

public class Hot_fgmt extends Fragment {
    private ListView listView;
    private ListAdapterImprove_2 listAdapter;


    private List<MyList> mlist = new ArrayList<>();
    public Hot_fgmt(){

    }


    @Override
    public View onCreateView( LayoutInflater inflater,ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.hot_fgmt, container,false);
        listView  = (ListView) view.findViewById(R.id.Hot_ListView);
        listAdapter = new ListAdapterImprove_2 (getActivity().getApplicationContext(),R.layout.home_listview_item);
        listView.setAdapter(listAdapter);

        InitList();
//        ArrayAdapter<String> arrayAdapter = new ArrayAdapter<String>(getActivity(),
//         android.R.layout.simple_list_item_1,getData());
        listView.setAdapter(listAdapter);

        return  view;
    }

    private void InitList() {
//        MyList apple = new MyList("热门页面", R.drawable.ic_mine);
////        mlist.add(apple);
////        MyList banana = new MyList("泪依言欣", R.drawable.ic_mine);
////        mlist.add(banana);
////        MyList orange = new MyList("千里追随", R.drawable.ic_mine);
////        mlist.add(orange);
////        MyList watermelon = new MyList("岁月痕迹", R.drawable.ic_mine);
////        mlist.add(watermelon);
////        MyList pear = new MyList("细语凝香", R.drawable.ic_mine);
////        mlist.add(pear);
////        MyList grape = new MyList("浅笑嫣然", R.drawable.ic_mine);
////        mlist.add(grape);
////        MyList pineapple = new MyList("霓裳羽衣", R.drawable.ic_mine);
////        mlist.add(pineapple);
////        MyList strawberry = new MyList("旧时月色 :", R.drawable.ic_mine);
////        mlist.add(strawberry);
////        MyList cherry = new MyList("ˇ故人西辞-", R.drawable.ic_mine);
////        mlist.add(cherry);
////        MyList mango = new MyList("一曲离殇", R.drawable.ic_mine);
////        mlist.add(mango);
    }
}
