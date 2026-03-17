function  [L_Result,M]=getL(Z,k)
     n = size(Z,2);
     numanchor = size(Z,1);
     Llist = cell(1,1);
     stream = RandStream.getGlobalStream;
     reset(stream);
        
%      rng(1344,'twister');
     for test_iter =1:1

          L =  randi([1,k],n,1);
%          L = mod((0:n-1)', k) + 1;
         INIT_l = L;

         M = ones(numanchor,k)/numanchor;
         iter = 1;
         max_iter = 200;
         epsilon = 1e-6;
         while(iter<max_iter)
         for j=1:k
             ZLT(:,j) = sum(Z(:,L==j), 2);
         end
         MtTEMP = ZLT;
         [MtUt,~,MtVt] = svd(MtTEMP,'econ');
         M= MtUt* MtVt';
%          LLTvec = zeros(k,1);
%          for j=1:k
%              LLTvec(j) = sum(L==j);
%          end
%          LLTplusIinvvec = 1./(LLTvec+eps);
%          tmp = ZLT;
%          M = (repmat(LLTplusIinvvec, 1, numanchor).*tmp')'; %copy n of 1*k
         loss_L = EuDist2(Z',M',0);
         [~, L] = min(loss_L, [], 2);
         obj_sum = norm(Z-M(:,L),"fro")^2;
         obj(iter)=obj_sum; 
%            fprintf('iter:%d obj:%f\n',iter,obj_sum);
         if (iter>9) && (abs((obj(iter-1)-obj(iter))/(obj(iter-1)))<epsilon || iter>max_iter || obj(iter) < 1e-10)
                break;
         end
         
         iter = iter +1;
         end
         obj_sum_test(test_iter) = obj_sum;
         Llist{test_iter} = L;

     end
     [~,INDX] = min(obj_sum_test,[],2);
    L_Result = Llist{INDX};
end