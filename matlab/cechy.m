function [kontrast, energia, jednorodnosc, korelacja, RGBmean, RGBmedian, RGBstd, circularity, eccentricity, areaDifference, compactness, FractalDimension, mask] = cechy(zdj)
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
% imshow(ram);


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
% figure,imshow(img2);
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

%figure; imshow(img2);

imgB= imbinarize(rgb2gray(img2));
%% otwarcie zamkniêcie ¿eby wyczyœciæ œmieci
imgB = imclearborder(imgB, 26);
imgB = imfill(imgB,'holes');
imgB = bwareaopen(imgB,1000);
%figure;imshow(imgB);

%% krawedz


se = strel('disk',4, 6);
imgE= imerode(imgB, se);
edges = imgB-imgE;
%figure;imshow(edges);


%% textura

mask = imgB;
[height, width] = size(mask);
imageGS = rgb2gray(img2);
imageGS(~imgB) = 0; 

glcms = graycomatrix(imageGS);
glcms(1,:) = 0;
glcms(:,1) = 0;
stats = graycoprops(glcms,'Contrast Correlation');
stats1 = graycoprops(glcms,{'energy','homogeneity'});
kontrast=stats.Contrast;
energia=stats1.Energy;
jednorodnosc=stats1.Homogeneity;
korelacja=stats.Correlation;

%% œrednie wartoœci RGB
mask = imgB;
k=5;
imageRBG = img2;
imageRBG = bsxfun(@times, imageRBG, cast(mask, 'like', imageRBG));
% imshow(imageRBG);
[height, width] = size(mask);
R=[];
G=[];
B=[];
for i=1:height
    for j=1:width
    if(mask(i,j)==1)
        R= [R;imageRBG(i,j,1)];
        G= [G;imageRBG(i,j,2)];
        B= [B;imageRBG(i,j,3)];
    end
    end
end

RGBmean = [round(mean(R)),round(mean(G)), round(mean(B))];
RGBmedian = [median(R),median(G), median(B)];
RGBstd = [std(double(R)),std(double(G)),std(double(B))];
% Rclust = kmeans(R,k);
% Gclust = kmeans(G,k);
% Bclust = kmeans(B,k);
% RGBmeanClust = [Rclust, Gclust, Bclust];
%% regionprops - cechy maski 

circularity = regionprops(mask, 'Circularity');
eccentricity = regionprops(mask, 'Eccentricity');


%% asymetria
props = regionprops(mask, 'Centroid', 'Orientation');
xCentroid = props.Centroid(1);
yCentroid = props.Centroid(2);
middlex = width/2;
middley = height/2;
deltax = middlex - xCentroid;
deltay = middley - yCentroid;
binaryImage = imtranslate(mask,  [deltax, deltay]);

angle = -props.Orientation;
rotatedImage = imrotate(binaryImage, angle, 'crop');

topArea = sum(sum(binaryImage(1:height/2,:)));
bottomArea = sum(sum(binaryImage(height/2+1:end,:)));
areaDifference = abs(topArea - bottomArea);

% imshow(rotatedImage);
% axis on;
% % caption = sprintf('Image Rotated by %f Degrees', angle);
% % title(caption, 'fontSize', fontSize);
% % Plot a + at the center of the blob and center of the image.
% hold on;
% line([middlex, middlex], [1, height], 'Color', 'm', 'LineWidth', 2);
% line([1, width], [middley, middley], 'Color', 'm', 'LineWidth', 2);
% drawnow;

%% Border irregularity

% [B,L,n,A] = bwboundaries(rotatedImage);

area= regionprops(mask, 'Area');
perimeter = regionprops(mask, 'Perimeter');
compactness = (perimeter.Perimeter(1,1)^2)/(4*pi*area.Area(1,1));
% figure,plot(B{1,1}(:,2), B{1,1}(:,1), 'r*');

FractalDimension = hausDim(edges);

end