function ramka = generowanieRamki(zdj,n)

newH = 620;
newW =620;

[x,y,z] = size(zdj);

colors= zeros(10,10,3);

for o=1:1:10
     for g=1:1:10
            A= impixel(zdj, o, g);
            colors(o,g,1)=A(1);
            colors(o,g,2)=A(2);
            colors(o,g,3)=A(3);
     end
end

ram = zeros(newH,newW,3);
ramka = zeros(newH,newW,3);
[rx,ry,rz] = size(ram);
switch n
    case 1 %srednia
    r= mean(mean(colors(:,:,1)));
    g= mean(mean(colors(:,:,2)));
    b= mean(mean(colors(:,:,3)));
    color = [r,g,b];
    ram(:,:,1)= color(1);
    ram(:,:,2)= color(2);
    ram(:,:,3)= color(3);
    ramka = cat(3, ram(:,:,1), ram(:,:,2), ram(:,:,3));
    ramka = uint8(ramka);
    
    case 0 %losowe
    for t=1:1:rx
         for h=1:1:ry
            idx=randperm(length(colors),1);
            idy=randperm(length(colors),1);
            ram(t,h,1)= colors(idx,idy,1);
            ram(t,h,2)= colors(idx,idy,2);
            ram(t,h,3)= colors(idx,idy,3);
         end
    end
    ramka = cat(3, ram(:,:,1), ram(:,:,2), ram(:,:,3));
    ramka = uint8(ramka);       
end   

end