function filtredImage = hairRemoval(Image)
% clear;
% clc;
r=20;
se1_para = 4;
se2_para = 3;
figure(1),imshow(Image);
[x,y,z] = size(Image);
img = rgb2gray(Image);
se1 = strel('disk',se1_para);
img_c = imclose(img,se1)
figure(2), imshow(img_c,[]);
img_fur = double(img_c) - double(img);
figure(3),imshow(img_fur,[]);
[X Y]=meshgrid(1:x);
tt=(X-280).^2+(Y-280).^2<280^2;
thresh = otsu(img_fur(tt),sum(tt(:)));
img_b = (img_fur>thresh);
figure(4),imshow(img_b);
se2 = strel('disk',se2_para);
img_b =imdilate(img_b,se2);
figure(5),imshow(img_b);

img_new = uint8(zeros(x,y,z));
for i = 1:x 
  for j = 1:y        
      if img_b(i,j) == false  
          img_new(i,j,:) = Image(i,j,:);
      else           
          ttt = Image(max(1,i-r):min(i+r,x),max(j-r,1):min(j+r,y),:);
          no_efficient_pix = cat(3,img_b(max(1,i-r):min(i+r,x),max(j-r,1):min(j+r,y)),not(tt(max(1,i-r):min(i+r,x),max(j-r,1):min(j+r,y))));
          no_efficient_pix = any(no_efficient_pix,3);
          ttt = ttt.*repmat(uint8(not(no_efficient_pix)),[1,1,3]);
          efficient_pix_num = (2*r+1)^2-sum(no_efficient_pix(:));
          img_new(i,j,:) = uint8(sum(sum(ttt))./efficient_pix_num);           
      end       
  end   
end

filtredImage= img_new

end
