function [scores] = Compute_PROP(A)

%A is the weighted adjacency matrix
%scores is the similairity matrix

%Find the dimensions of the matrix and its degree distributions
wts = A;
A = double(A~=0);
[x,y] = size(A);

% wts = zeros(cols);
mat = zeros(y);
for i=1:y
    s_dis = wts(:,i);
    indx = s_dis>0;
    tot_num = sum(indx);
    if(tot_num==0)
        continue;
    end
    tot_dis = wts(indx,i);
    parfor j=1:y
        frac = sum(tot_dis<wts(indx,j));
        mat(i,j) = frac/tot_num;
    end
end



s_degs = sum(A,2);
d_degs= sum(A,1);

%Find Neighbours
adj_list_s = cellfun(@(x) find(x),num2cell(A,2),'un',0);
adj_list_d = cellfun(@(x) find(x),num2cell(A,1),'un',0);

%Intialize variables
scores = zeros(x,y);

%Paralellized for loop
parfor i=1:x
    for j=1:y        
        s_n = adj_list_s{i};
        d_n = adj_list_d{j};
        rr = mat(s_n,j);
        rr = rr';
        if(isempty(rr))
            scores(i,j) = 0;
            continue;
        end
        part_mat = A(d_n,s_n);

        part_mat = part_mat.*repmat(rr, [length(part_mat(:,1)),1]);
        part_degs = ((1./s_degs(d_n))*(1./d_degs(s_n))).*part_mat;
        scores(i,j) = sum(sum(part_degs));
    end
end

scores(isnan(scores)) = 0;
scores = scores.*(1-A);
