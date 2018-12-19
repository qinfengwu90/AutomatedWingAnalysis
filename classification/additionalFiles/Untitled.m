load('FeatureMain.mat')
X = FeatureMain';
Y = pdist(X);
Z = linkage(Y);
dendrogram(Z,100)