close all;
zdj=imread("3.jpg");

%Robienie ramki

imshow(zdj);

% zdj = imresize(zdj, [400, 400]);
zdj_gray=rgb2gray(zdj);

%filtracja przed clusterami
%zdj_gray_flt = 
% img1=zdj;
% R = img1(:,:,1);
% G = img1(:,:,2);
% B = img1(:,:,3);
% imgg=img1;
% imgg(:,:,1) = imgaussfilt(R,4);
% imgg(:,:,2) = imgaussfilt(G,4);
% imgg(:,:,3) = imgaussfilt(B,4);

FilteredImage1= hairRemoval(zdj);

figure,imshow(FilteredImage1);
% FilteredImage2 = FilteredImage1 - zdj ;
%figure,imshow(FilteredImage1);

img=FilteredImage1;
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
FilteredImage2=FilteredImage1;
FilteredImage2(:,:,1) = medfilt2(R);
FilteredImage2(:,:,2) = medfilt2(G);
FilteredImage2(:,:,3) = medfilt2(B);
figure,imshow(FilteredImage2);
% w�osy -> cienkie d�ugie, maska, regionprops (szeroko�� nie wi�ksza ni�)
%czyszczenie brzeg�w!
%%

zdj_gray = rgb2gray(FilteredImage2);
[C,U,LUT,H]=FastFCMeans(zdj_gray,2, 1.6);


 

figure('color','w')  
subplot(1,2,1), imshow(zdj_gray)
set(get(gca,'Title'),'String','ORIGINAL')
 
L=LUT2label(zdj_gray,LUT);
Lrgb=zeros([numel(L) 2],'uint8');
for i=1:3
    Lrgb(L(:)==i,i)=255;
end
Lrgb=reshape(Lrgb,[size(zdj_gray) 3]);
subplot(1,2,2), imshow(Lrgb,[])
set(get(gca,'Title'),'String','FUZZY C-MEANS (C=2)')