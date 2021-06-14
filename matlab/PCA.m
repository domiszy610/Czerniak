function [NowyWektor,WW,DV]=PCA(X, lambda)
% X-wektor cech
%     W kolumnach znajduj� si� kolejne cechy (zmienne)
%     W wierszach znajduj� si� kolejne osoby (obserwacje)
% lambda - pr�g istotno�ci wybranych wektor�w w�asnych

% NowyWektor - nowy wektor cech wyznaczony z u�yciem metody PCA
% WW - wybrane wektory w�asne (wg. instrukcji powinny znajdowa� si� w osobnych wierszach)
% DV - wybrane warto�ci w�asne

% Obliczenie wektora cech pomniejszonego o �redni�
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

% Udzia� procentowy wybranych warto�ci w�asnych
prog=0;
% Wyszukujemy najwa�niejsze komponenty
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

% Obliczamy nowe wsp�czynniki
NowyWektor=WW'*X_sred';
