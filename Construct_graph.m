function [Gs,ancidx,tocSelectS,tocConctructG] = Construct_graph(X,savenameGraph,savenameIndx,knn_init,numSample,isLarge)
    if (~exist(savenameGraph, 'dir')) &&  (~exist(savenameIndx, 'file'))
          

           if isLarge
               ticSelectS=tic;
               view = length(X);Gs = cell(1,view);anchorlist = cell(1,view);
               [ancidx] = ancidx_generate_anchornum(X,numSample);
               index = ancidx{1};
               for i = 1 : view
                   anchorlist{i} = X{i}(:,index(i,:));
               end
               tocSelectS = toc(ticSelectS);
               ticConctructG=tic;
               for i = 1:view
                   Gs{i} = getZ(X{i}',anchorlist{i}',knn_init)';
               end
               tocConctructG = toc(ticConctructG);
           else
               ticConctructG=tic;
               view = length(X);Gs = cell(1,view);
               for i = 1:view
                   Gs{i} = getZ(X{i}',X{i}',knn_init)';
               end
               tocConctructG = toc(ticConctructG);
               ancidx = [];tocSelectS=0;
           end
    else
        load(savenameGraph);
        load(savenameIndx);
    end
end


