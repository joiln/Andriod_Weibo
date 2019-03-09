package com.example.andriod_weibo;

public class MyList {
    private String name;
    private int imgId;
    private String publish;
    private String content;
    private int content_img;

    public MyList(String name, int imgId,String publish,String content,int content_img){
        super();
        this.name = name;
        this.imgId = imgId;
        this.publish = publish;
        this.content = content;
        this.content_img = content_img;
    }

//    public MyList(String name2, int p1, String string, String string2,
//                  String string3, String string4){
//
//    }

    public int getContent_img() {
        return content_img;
    }

    public void setContent_img(int content_img) {
        this.content_img = content_img;
    }
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPublish() {
        return publish;
    }

    public void setPublish(String publish) {
        this.publish = publish;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getImgId() {
        return imgId;
    }

    public void setImgId(int imgId) {
        this.imgId = imgId;
    }

    public void put(String string,String string2){

    }
}
