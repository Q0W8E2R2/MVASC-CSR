function [final_avg,final_std]= ComputeResult(U,Y)

stream = RandStream.getGlobalStream;
reset(stream);
result(1,:) = Clustering8Measure(Y,U);
final_avg= result(1,:);
final_std=result(1,:);
final_max = result(1,:);
final_min = result(1,:);
for cnt=1:8
    final_avg(cnt)=mean(result(:,cnt),1)';
    final_max(cnt)=max(result(:,cnt))';
    final_min(cnt)=min(result(:,cnt))';
    final_std(cnt)=std(result(:,cnt),1)';
end
fprintf('ACC_result:\t ACC:%.4f, NMI:%.4f, Purity:%.4f, Fsocre:%.4f, Precision:%.4f,  Recall:%.4f  AR:%.4f  Entropytimes:%.4f \n',final_avg);
fprintf('ACC_result:\t ACC:%.6f, NMI:%.6f, Purity:%.6f, Fsocre:%.6f, Precision:%.4f,  Recall:%.4f  AR:%.4f  Entropytimes:%.4f \n',final_avg);
% fprintf('std_result:\t ACC:%f, NMI:%f, Purity:%f, Fsocre:%f, Precision:%f,  Recall:%f  AR:%f  Entropytimes:%f \n',final_std);
% fprintf('ACC_MAX_result:\t ACC:%f, NMI:%f, Purity:%f, Fsocre:%f, Precision:%f,  Recall:%f  AR:%f  Entropytimes:%f \n',final_max);
% fprintf('ACC_min_result:\t ACC:%f, NMI:%f, Purity:%f, Fsocre:%f, Precision:%f,  Recall:%f  AR:%f  Entropytimes:%f \n',final_min);
% sumiter = sum(timeList);
% meaniter = mean( timeList);
% fprintf('总聚类时间:%f \t 平均聚类时间:%f \t \n ',sumiter,meaniter)
% rng(4396,'twister');
% predY=litekmeans(U, numclass, 'MaxIter', 100,'Replicates',30);
% result_new = Clustering8Measure(Y,predY);
% fprintf('4396result:\t ACC:%f, NMI:%f, Purity:%f, Fsocre:%f, Precision:%f,  Recall:%f  AR:%f  Entropytimes:%f \n',result_new);