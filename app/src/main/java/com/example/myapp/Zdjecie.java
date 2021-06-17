package com.example.myapp;

class Zdjecie {

    private String imageUrl;

    public Zdjecie(){

    }

    public Zdjecie(String imageUrl){
        this.imageUrl = imageUrl;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
