function [scores] = Compute_PRA(A)

%A is the adjacency matrix
%scores is the similairity matrix

%Find the dimensions of the matrix and its degree distributions
[x,y] = size(A);
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
        part_mat = A(d_n,s_n);
        part_degs = ((1./s_degs(d_n))*(1./d_degs(s_n))).*part_mat;
        scores(i,j) = sum(sum(part_degs));
    end
end

scores(isnan(scores)) = 0;
scores = scores.*(1-A);
