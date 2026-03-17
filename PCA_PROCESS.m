function [Xs] = PCA_PROCESS(fea,dim)
view = length(fea);
Xs = cell(1,view);
for i =1:view
    fea{i} = fea{i}';
    coeff = pca(fea{i});
    coeffMx = coeff(:,1:dim);
    Xs{i} = fea{i}*coeffMx;
    Xs{i} = Xs{i}';
end
end