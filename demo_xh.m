clear;clc;
addpath('ClusteringMeasure','Datasets','Tools','graph');
data_path = 'Datasets\';
data_name = 'BDGP';
diary_name = "20251125_XH_"+data_name +".txt";


%% 开始运行
diary(diary_name);

%% 加载数据、获得固定值
[X,gt] = load_dataset_my(data_name);
view = length(X);
k = length(unique(gt));
n = size(X{1},2);
md = mindim(X);
knn_init = 20;


savename = "./result/"+data_name +"/Result_"+ data_name + "_numanchor_"+num2str(numanchor)+"alpha_"+num2str(alpha)+"beta_"+num2str(beta)+".mat";
savenameIndx = "./graph/"+data_name +"/Indx_"+ data_name + "_numanchor_"+num2str(numanchor)+"alpha_"+num2str(alpha)+"beta_"+num2str(beta)+".mat";
savenameGraph = "./graph/"+data_name +"/Graph_"+ data_name + "_numanchor_"+num2str(numanchor)+"alpha_"+num2str(alpha)+"beta_"+num2str(beta)+".mat";
alphas =[1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1e1,1e2,1e3,1e4,1e5];
betas = [1e-5,1e-4,1e-3,1e-2,1e-1,1e0,1e1,1e2,1e3,1e4,1e5];
ms = [k,2*k,3*k,4*k,5*k,6*k,7*k,8*k,9*k,10*k];
for alpha_idx = 1:11
    for beta_idx = 1:11
        for m_idx = 1:10
            alpha = alphas(alpha_idx);
             beta = betas(beta_idx);
              numanchor = ms(m_idx);
tictotal=tic;
fprintf("-----------------------------------Running-----------------------------------\n");
savenameGraph = "./graph/"+data_name +"/Graph_"+ data_name + "_numanchor_"+num2str(numanchor)+"alpha_"+num2str(alpha)+"beta_"+num2str(beta)+"_20251123.mat";
savenameIndx = "./graph/"+data_name +"/Indx_"+ data_name + "_numanchor_"+num2str(numanchor)+"alpha_"+num2str(alpha)+"beta_"+num2str(beta)+"_20251123.mat";

fprintf('Parameters: numanchor:%f alpha:%f  beta:%f\n',numanchor,alpha,beta );

if n>=10000
    fprintf('scale: Large\n');
    isLarge = 1;

    fprintf('Start Reducing Dim  --------------------\n');
    ticpca=tic;
    pcadim = min(md,10*k);
    X = PCA_PROCESS(X,pcadim);
    tocpca = toc(ticpca);
    fprintf('RD Time:%f\n',tocpca);
else
    tocpca=0;isLarge=0;
end

% fprintf('Start Selecting Samples and Constructing Graphs  --------------------\n');
[Gs,ancidx,tocSelectS,tocConctructG]=Construct_graph(X,savenameGraph,savenameIndx,knn_init,10*k,isLarge);
% fprintf('Select Samples Time:%f\n',tocSelectS);
% fprintf('Construct Graphs Time:%f\n',tocConctructG);


% fprintf('Start Learning  --------------------\n');
tic_GetZ = tic;
[Z,H,SVD_Z_normalized] = HAZ(X,Gs,k,numanchor,alpha,beta );
toc_GetZ = toc(tic_GetZ);
% fprintf('Learning  Time:%f\n',toc_GetZ);

% fprintf('Starting Get Indx  --------------------\n');
tic_GetL = tic;
[L,M] = outputL(SVD_Z_normalized',k);
toc_GetL = toc(tic_GetL);
% fprintf('Get Indx  Time:%f\n',toc_GetL);

toctotal = toc(tictotal);

TotalTimeNK = tocpca + tocSelectS + tocConctructG + toc_GetZ + toc_GetL;
% fprintf('Total Time NoKmeans  Time:%f\n',TotalTimeNK);

% fprintf('Total Time NoDivide  Time:%f\n',toctotal);

%% 计算指标
[Avg,Std] = ComputeResult(L,gt);

        end
    end
end



% if ~exist("./graph/"+data_name+'/', 'dir')
%     fprintf("dir : ./graph/"+data_name +"/, NOT EXIST，Save...\n");
%     mkdir("./graph/"+data_name+'/');
% end
% 
% if ~exist("./result/"+data_name+'/', 'dir')
%     fprintf("dir : ./result/"+data_name +"/, NOT EXIST，Save...\n");
%     mkdir("./result/"+data_name+'/');
% end
% fprintf("File :  "+savename +"     NOT EXIST，Save...\n");
% save(savename);
% if ~exist(savenameIndx, 'file')
%     fprintf("File :  "+savenameIndx +"     NOT EXIST，Save...\n");
%     save(savenameIndx,"ancidx");
% end
% if ~exist(savenameGraph, 'file')
%     fprintf("File :  "+savenameGraph +"     NOT EXIST，Save...\n");
%     save(savenameGraph,"Gs");
% end
diary off;