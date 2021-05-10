function filtredImage = hairRemoval2(rgbImage)
R =rgbImage(:, :, 1);
G =rgbImage(:, :, 2);
B =rgbImage(:, :, 3);
theta = 0:180;
[~,xpR] = radon(R,theta);
[~,xpG] = radon(G,theta);
[~,xpB] = radon(B,theta);

BWR = edge(R,'prewitt',[],xpR);
BWG = edge(G,'prewitt',[],xpG);
BWB = edge(B,'prewitt',[],xpB);
BW = cat(3,BWR,BWG,BWB);
filtredImage = BW;

end