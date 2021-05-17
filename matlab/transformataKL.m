function zdj = transformataKL(im)

im2=rgb2gray(im(1:fix(size(im,1)/8)*8,1:fix(size(im,2)/8)*8,:));    % convert to gray-scale and fix size
image = double(im2)/255;  %convert to double and normalize to [0,1]

x = im2col(image,[8 8],'distinct'); % convert to 8x8 blocks, each block in column

mx =mean(x'); % calculate mean and save it for further processing
z = x - mx';    % zero-mean variable
%histogram(z(:),'Normalization','pdf')
Cz = cov(z');   % covariance matrix of 
%% Decorrelation - KLT
[V,D] = eig(Cz);    % Eigen-matrix of covariace
y = V'*z;           % Values in y are decorrelated, Cy = diag(D)
% compression: drop dr rows
dr = 20;
y(1:dr,:) = zeros(dr,size(y,2));
%% Restore
z2 = inv(V')*y;
x2 = z2 + mx';

zdj = col2im(x2,[8 8],[fix(size(im,1)/8)*8 fix(size(im,2)/8)*8], 'distinct');

end