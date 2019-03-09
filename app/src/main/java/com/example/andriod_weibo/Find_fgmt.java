package com.example.andriod_weibo;


import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.util.ArrayList;


public class Find_fgmt extends Fragment implements ViewPager.OnPageChangeListener{
    private ViewPager viewPager;
    private ArrayList<ImageView> imageList;

    private LinearLayout pointGroup;

    private TextView iamgeDesc;

    /**
     * 上一个页面的位置
     */
    protected int lastPosition;

    // 图片资源ID
    private final int[] imageIds = { R.drawable.a, R.drawable.b, R.drawable.c,
            R.drawable.d, R.drawable.e };

    // 图片标题集合
    private final String[] imageDescriptions = {
            "3.8女王节来了",
            "vivo IQOO 新款牛逼手机",
            "娱乐新闻头条",
            "关于啃老的争议",
            "极致润滑 京东19.9抢购"
    };

    public Find_fgmt(){

    }


    @Override
    public View onCreateView( LayoutInflater inflater,  ViewGroup container,  Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.find, container,false);

        viewPager = (ViewPager) view.findViewById(R.id.viewpager);
        pointGroup = (LinearLayout) view.findViewById(R.id.point_group);
        iamgeDesc = (TextView) view.findViewById(R.id.image_desc);
        iamgeDesc.setText(imageDescriptions[0]);

        imageList = new ArrayList<>();
        for (int i = 0; i < imageIds.length; i++) {

            // 初始化图片资源
            ImageView image = new ImageView(getActivity().getApplicationContext());
            image.setBackgroundResource(imageIds[i]);
            imageList.add(image);

            // 添加指示点
            ImageView point = new ImageView(getActivity().getApplicationContext());
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT);

            params.rightMargin = 20;
            point.setLayoutParams(params);
            if (i == 0) {
                point.setEnabled(true);
            } else {
                point.setEnabled(false);
            }
            pointGroup.addView(point);
        }

        viewPager.setAdapter(new MyPagerAdapter());
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {

            @Override
            /**
             * 页面切换后调用
             * position  新的页面位置
             */
            public void onPageSelected(int position) {

                position = position % imageList.size();

                // 设置文字描述内容
                iamgeDesc.setText(imageDescriptions[position]);

                // 改变指示点的状态
                // 把当前点enbale 为true
                pointGroup.getChildAt(position).setEnabled(true);
                // 把上一个点设为false
                pointGroup.getChildAt(lastPosition).setEnabled(false);
                lastPosition = position;

            }

            @Override
            /**
             * 页面正在滑动的时候，回调
             */
            public void onPageScrolled(int position, float positionOffset,
                                       int positionOffsetPixels) {
            }

            @Override
            /**
             * 当页面状态发生变化的时候，回调
             */
            public void onPageScrollStateChanged(int state) {

            }
        });

        /*
         * 自动循环： 1、定时器：Timer 2、开子线程 while true 循环 3、ColckManager 4、 用handler
         * 发送延时信息，实现循环
         */
        isRunning = true;
        // 设置图片的自动滑动
        handler.sendEmptyMessageDelayed(0, 3000);



        return  view;

    }

    /**
     * 判断是否自动滚动
     */
    private boolean isRunning = false;

    private Handler handler = new Handler() {
        public void handleMessage(android.os.Message msg) {

            // 让viewPager 滑动到下一页
            viewPager.setCurrentItem(viewPager.getCurrentItem() + 1);
            if (isRunning) {
                handler.sendEmptyMessageDelayed(0, 3000);
            }
        };
    };

    public void onDestroy() {
        super.onDestroy();
        isRunning = false;
    };

    @Override
    public void onPageScrolled(int i, float v, int i1) {

    }

    @Override
    public void onPageSelected(int i) {

    }

    @Override
    public void onPageScrollStateChanged(int i) {

    }

    public class MyPagerAdapter extends PagerAdapter {

        @Override
        /**
         * 获得页面的总数
         */
        public int getCount() {
            return Integer.MAX_VALUE; // 使得图片可以循环
        }

        @Override
        /**
         * 获得相应位置上的view
         * container  view的容器，其实就是viewpager自身
         * position    相应的位置
         */
        public Object instantiateItem(ViewGroup container, int position) {
            // 给 container 添加一个view
            container.addView(imageList.get(position % imageList.size()));
            // 返回一个和该view相对的object
            return imageList.get(position % imageList.size());
        }

        @Override
        /**
         * 判断 view和object的对应关系
         */
        public boolean isViewFromObject(View view, Object object) {
            if (view == object) {
                return true;
            } else {
                return false;
            }
        }

        @Override
        /**
         * 销毁对应位置上的object
         */
        public void destroyItem(ViewGroup container, int position, Object object) {

            container.removeView((View) object);

        }
    }

}
