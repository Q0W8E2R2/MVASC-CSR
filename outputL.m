function  [L_Result,M]=outputL(Z,k)
n = size(Z,2);
numanchor = size(Z,1);
stream = RandStream.getGlobalStream;
reset(stream);

M = ones(numanchor,k)/numanchor;
indices = round(linspace(1, n, k)); % 创建均匀间隔的索引
M = Z(:, indices); % 选择对应索引的数据点作为质心


iter = 1;
max_iter = 200;
epsilon = 1e-6;
while(iter<max_iter)

    loss_L = EuDist2(Z',M',0);
    [~, L] = min(loss_L, [], 2);

    for j=1:k
        ZLT(:,j) = sum(Z(:,L==j), 2);
    end
    MtTEMP = ZLT;
    [MtUt,~,MtVt] = svd(MtTEMP,'econ');
    M= MtUt* MtVt';
    obj_sum = norm(Z-M(:,L),"fro")^2;
    obj(iter)=obj_sum;
     fprintf('iter:%d obj:%f\n',iter,obj_sum);
    if (iter>9) && (abs((obj(iter-1)-obj(iter))/(obj(iter-1)))<epsilon || iter>max_iter || obj(iter) < 1e-10)
        break;
    end

    iter = iter +1;
end
L_Result =L;
end