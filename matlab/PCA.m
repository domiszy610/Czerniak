function [NowyWektor,WW,DV]=PCA(X, lambda)
% X-wektor cech
%     W kolumnach znajduj¹ siê kolejne cechy (zmienne)
%     W wierszach znajduj¹ siê kolejne osoby (obserwacje)
% lambda - próg istotnoœci wybranych wektorów w³asnych

% NowyWektor - nowy wektor cech wyznaczony z u¿yciem metody PCA
% WW - wybrane wektory w³asne (wg. instrukcji powinny znajdowaæ siê w osobnych wierszach)
% DV - wybrane wartoœci w³asne

% Obliczenie wektora cech pomniejszonego o œredni¹
[n,c] = size(X);
X_sred = X - ones(n,1) * mean(X);

% Obliczenie kowariancji
kowariancja=X_sred'*X_sred/(n-1);

% TO DO
DV=[];
WW=[];

[V D]=eig(kowariancja);
D=diag(D);
cj=sum(D);
ci=0;

% Udzia³ procentowy wybranych wartoœci w³asnych
prog=0;
% Wyszukujemy najwa¿niejsze komponenty
while prog < lambda
    % TO DO
    
    [M I]=max(D);
    temp=V(:, I);
    WW=[WW temp];
    DV=[DV M];
    ci=sum(DV);
    prog=ci/cj;
    
    V(:, I) = [];
    D(I) = [];
end

% Obliczamy nowe wspó³czynniki
NowyWektor=WW'*X_sred';
