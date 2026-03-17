function [anc_idx] = ancidx_generate_anchornum(fea,anchor_num)
num_sample = size(fea{1},2);
r3 = [anchor_num];
% r3 = [floor(size(gt,1) * 0.08)];

for num = 1 : length(r3)
    anch_num = r3(num);
    v = length(fea);
    for i = 1 : v
        stream = RandStream.getGlobalStream;
        reset(stream);
        [label, center, bCon, sumD, D] = litekmeans(fea{i}', anch_num,'MaxIter', 100,'Replicates',5);
        [value,index] = sort(D,1);
        anc_idx{num}(i,:) = index(1,:);
    end
end

end

