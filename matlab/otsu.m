function thresh = otsu(data,pix_num)
img_var = zeros(256,1);
for i=1:256
     w0 = sum(sum(data<=i-1))./pix_num;
     w1 = 1-w0;
     u0 = sum(sum(data.*double(data<=i-1)))./(w0*pix_num);
     u1 = sum(sum(data.*double(data>i-1)))./(w1*pix_num);
     img_var(i) = w0.*w1.*((u0-u1).^2);
end
[~,I] = max(img_var);
thresh = I-1;
end