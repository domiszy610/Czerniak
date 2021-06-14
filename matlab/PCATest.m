folder = 'C:\Users\User\Desktop\Czerniak\matlab\piep';
I = dir(fullfile(folder,'*.jpg'));
for k=1:numel(I)
  u = [];
  filename=fullfile(folder,I(k).name);
  Ip{k}=imread(filename);
  [kontrast, energia, jednorodnosc, korelacja, RGBmean, RGBmedian, RGBstd, circularity, eccentricity, areaDifference, compactness, FractalDimension, mask]=cechy(Ip{k});
  s = struct('Kontrast',kontrast, 'Energia', energia, 'Jednorodnosc', jednorodnosc, 'Korelacja', korelacja,'RGBmean', RGBmean,'RGBmedian', RGBmedian,'RGBstd', RGBstd, 'Circularity',  circularity, 'Eccentricity', eccentricity, 'AreaDifference', areaDifference,'Compactness', compactness,'FractalDimension', FractalDimension, 'Mask', mask);
  CechyP{k,1}=s;
end
%%
folder = 'C:\Users\User\Desktop\Czerniak\matlab\czer';
I = dir(fullfile(folder,'*.jpg'));
for k=1:numel(I)
  filename=fullfile(folder,I(k).name);
  Ic{k}=imread(filename);
  [kontrast, energia, jednorodnosc, korelacja, RGBmean, RGBmedian, RGBstd, circularity, eccentricity, areaDifference, compactness, FractalDimension, mask]=cechy(Ic{k});
  s = struct('Kontrast',kontrast, 'Energia', energia, 'Jednorodnosc', jednorodnosc, 'Korelacja', korelacja,'RGBmean', RGBmean,'RGBmedian', RGBmedian,'RGBstd', RGBstd, 'Circularity',  circularity, 'Eccentricity', eccentricity, 'AreaDifference', areaDifference,'Compactness', compactness,'FractalDimension', FractalDimension, 'Mask', mask);
  CechyC{k,1}=s;
end

%%
dane =[];

for k=1:length(CechyP)
    dane = [dane; CechyP{k,1}.Kontrast, CechyP{k,1}.Energia, CechyP{k,1}.Jednorodnosc, CechyP{k,1}.Korelacja, CechyP{k,1}.RGBmean(1,1),CechyP{k,1}.RGBmean(1,2),CechyP{k,1}.RGBmean(1,3), CechyP{k,1}.RGBmedian(1,1),CechyP{k,1}.RGBmedian(1,2),CechyP{k,1}.RGBmedian(1,3), CechyP{k,1}.RGBstd(1,1),CechyP{k,1}.RGBstd(1,2),CechyP{k,1}.RGBstd(1,3),...
        CechyP{k,1}.Circularity.Circularity, CechyP{k,1}.Eccentricity.Eccentricity, CechyP{k,1}.AreaDifference, CechyP{k,1}.Compactness, CechyP{k,1}.FractalDimension];
end

for k=1:length(CechyC)
    dane = [dane; CechyC{k,1}.Kontrast, CechyC{k,1}.Energia, CechyC{k,1}.Jednorodnosc, CechyC{k,1}.Korelacja,  CechyC{k,1}.RGBmean(1,1),CechyC{k,1}.RGBmean(1,2),CechyC{k,1}.RGBmean(1,3), CechyC{k,1}.RGBmedian(1,1),CechyC{k,1}.RGBmedian(1,2),CechyC{k,1}.RGBmedian(1,3), CechyC{k,1}.RGBstd(1,1),CechyC{k,1}.RGBstd(1,2),CechyC{k,1}.RGBstd(1,3),...
        CechyC{k,1}.Circularity.Circularity, CechyC{k,1}.Eccentricity.Eccentricity, CechyC{k,1}.AreaDifference, CechyC{k,1}.Compactness, CechyC{k,1}.FractalDimension];
end

%%
% lambda = 0.9;
dane1 = single(dane);
[coeff,score,latent] = pca(dane1);

%%

train_set = [score(1:10,:);score(21:30,:)];
train_type = zeros(20,1);
train_type(11:20,1) =1;
test_set = [score(11:20,:);score(31:40,:)];
test_type = zeros(20,1);
test_type(11:20,1) =1;

%% UWAGA ALTERNATYWA
% 
% train_set = [dane1(1:10,:);dane1(21:30,:)];
% train_type = zeros(20,1);
% train_type(11:20,1) =1;
% test_set = [dane1(11:20,:);dane1(31:40,:)];
% test_type = zeros(20,1);
% test_type(11:20,1) =1;

%% CV - partition
c = cvpartition(train_type,'k',15);

opts = statset('display','iter');
classf = @(train_data, train_labels, test_data, test_labels)...
    sum(predict(fitcsvm(train_data, train_labels,'KernelFunction','rbf'), test_data) ~= test_labels);

[fs, history] = sequentialfs(classf, train_set, train_type, 'cv', c, 'options', opts,'nfeatures',2);
%% Best hyperparameter

X_train_w_best_feature = train_set(:,fs);

Md1 = fitcsvm(X_train_w_best_feature,train_type,'KernelFunction','rbf','OptimizeHyperparameters','auto',...
      'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
      'expected-improvement-plus','ShowPlots',true)); % Bayes' Optimization .


%% Final test with test set
X_test_w_best_feature = test_set(:,fs);
test_accuracy_for_iter = sum((predict(Md1,X_test_w_best_feature) == test_type))/length(train_type)*100

%% hyperplane

figure;
hgscatter = gscatter(X_train_w_best_feature(:,1),X_train_w_best_feature(:,2),train_type);
hold on;
h_sv=plot(Md1.SupportVectors(:,1),Md1.SupportVectors(:,2),'ko','markersize',8);


% test set

gscatter(X_test_w_best_feature(:,1),X_test_w_best_feature(:,2),test_type,'rb','xx')

% decision plane
XLIMs = get(gca,'xlim');
YLIMs = get(gca,'ylim');
[xi,yi] = meshgrid([XLIMs(1):0.01:XLIMs(2)],[YLIMs(1):0.01:YLIMs(2)]);
dd = [xi(:), yi(:)];
pred_mesh = predict(Md1, dd);
redcolor = [1, 0.8, 0.8];
bluecolor = [0.8, 0.8, 1];
pos = find(pred_mesh == 1);
h1 = plot(dd(pos,1), dd(pos,2),'s','color',redcolor,'Markersize',5,'MarkerEdgeColor',redcolor,'MarkerFaceColor',redcolor);
pos = find(pred_mesh == 2);
h2 = plot(dd(pos,1), dd(pos,2),'s','color',bluecolor,'Markersize',5,'MarkerEdgeColor',bluecolor,'MarkerFaceColor',bluecolor);
uistack(h1,'bottom');
uistack(h2,'bottom');
legend([hgscatter;h_sv],{'pieprzyki','czerniaki','support vectors'})
