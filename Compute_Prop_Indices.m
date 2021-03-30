function [PRA,PROP] = Compute_Prop_Indices(A)

%A is the labelled adjacency matrix. Each label represents a time-stamp.
%PRA is the similairity matrix for path-based resorce allocation index
%PROP is the similairity matrix for probabilistic index

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
PROP = zeros(x,y);
PRA = zeros(x,y);

%Paralellized for loop
parfor i=1:x
    for j=1:y        
        s_n = adj_list_s{i};
        d_n = adj_list_d{j};
        rr = mat(s_n,j);
        rr = rr';
        if(isempty(rr))
            PROP(i,j) = 0;
            continue;
        end
        part_mat = A(d_n,s_n);
        part_degs = ((1./s_degs(d_n))*(1./d_degs(s_n))).*part_mat;
        PRA(i,j) = sum(sum(part_degs));

        part_mat = part_mat.*repmat(rr, [length(part_mat(:,1)),1]);
        part_degs = ((1./s_degs(d_n))*(1./d_degs(s_n))).*part_mat;
        PROP(i,j) = sum(sum(part_degs));
    end
end

PRA(isnan(PRA)) = 0;
PRA = PRA.*(1-A);
PROP(isnan(PROP)) = 0;
PROP = PROP.*(1-A);
