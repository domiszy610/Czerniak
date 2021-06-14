function wynik = Klasyfikacja(zdj, model)

Md1 = load('CompactSVMModel.mat');
fs1= load('fs.mat');
latent1 = load('latent.mat');

Md2 = load('CompactSVMModel2.mat');
fs2= load('fs2.mat');
latent2 = load('latent2.mat');
wynik = ' ';
try
[kontrast, energia, jednorodnosc, korelacja, RGBmean, RGBmedian, RGBstd, circularity, eccentricity, areaDifference, compactness, FractalDimension, mask]=cechy(zdj);
s = struct('Kontrast',kontrast, 'Energia', energia, 'Jednorodnosc', jednorodnosc, 'Korelacja', korelacja,'RGBmean', RGBmean,'RGBmedian', RGBmedian,'RGBstd', RGBstd, 'Circularity',  circularity, 'Eccentricity', eccentricity, 'AreaDifference', areaDifference,'Compactness', compactness,'FractalDimension', FractalDimension, 'Mask', mask);
dane = [s.Kontrast, s.Energia, s.Jednorodnosc, s.Korelacja, s.RGBmean(1,1),s.RGBmean(1,2),s.RGBmean(1,3), s.RGBmedian(1,1),s.RGBmedian(1,2),s.RGBmedian(1,3), s.RGBstd(1,1),s.RGBstd(1,2),s.RGBstd(1,3),...
        s.Circularity.Circularity, s.Eccentricity.Eccentricity, s.AreaDifference, s.Compactness, s.FractalDimension];
dane1 = single(dane);
catch
    wynik = 'Nie uda�o si� przeprowadzi� przetwarzania';
end

wiad = [];
switch model
    case 1 
        danePCA = dane1.*latent1';
        X= danePCA(:,fs1);
        wiad = predict(Md1,X);
    case 2
        danePCA = dane1.*latent2';
        X= danePCA(:,fs2);
        wiad = predict(Md2,X);
end

if wiad == 0
    wynik = 'Niegrozna zmiana';
end
if wiad == 1
    wynik = 'Czerniak';
end

end