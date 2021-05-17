close all;
zdj=imread("4.jpg");

newW = 620;
newH = 620;


[x,y,z] = size(zdj); %x - wysokosc, y - szerokosc
%resize je¿eli zdj za male
if (450<y && y<500 && 450<x && x<500)
    y =y+10;
    x =x+10;
    zdj = imresize(zdj,[x y]);
end
if(y<450 && x<450)
    y =y+20;
    x =x+20;
    zdj = imresize(zdj,[x y]);
end

wH= round((620 - x)/2);
wW= round((620 - y)/2);
%Robienie ramki
%usrednianie kolorow

ram = generowanieRamki(zdj, 1);

%wrzucanie obrazka na ramke
% try
    ram(wH:wH+x-1, wW:wW+y-1,:)= zdj;
% catch
%     ram(wH:wH+x-1, wW:wW+y-1,:)= zdj(;
% end
imshow(ram);


%% usuwanie w³osów i filtr medianowy
ram = hairRemoval(ram);
img=ram; 
R = img(:,:,1); 
G = img(:,:,2); 
B = img(:,:,3);
img2 = img;
img2(:,:,1) = medfilt2(R,[5,5], 'symmetric');
img2(:,:,2) = medfilt2(G,[5,5], 'symmetric'); 
img2(:,:,3) = medfilt2(B,[5,5], 'symmetric');
figure,imshow(img2);
%%

zdj_gray = uint8(rgb2gray(img2));
[C,U,LUT,H]=FastFCMeans(zdj_gray,2, 1.6);


L=LUT2label(zdj_gray,LUT);
Lrgb=zeros([numel(L) 2],'uint8');
for i=1:3
    Lrgb(L(:)==i,i)=255;
end

Lrgb=reshape(Lrgb,[size(zdj_gray) 3]);
for i=1:3
    for j=1:1:620
        for z=1:1:620
            if(Lrgb(z,j,1)~=255)
                img2(z,j,:)=0;
            end
        end
    end
end

figure; imshow(img2);


