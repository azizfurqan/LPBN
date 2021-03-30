function [predict_links,scores] = Compute_PRA(A)


%Code to compute Path-based Resource Allocation (PRA) index for Bipartite networks

%A is the adjacency matrix
%score: Path-based RA scores


[r,c]=find(A==0); % R:row indices, c:column indices)
predict_links=[r c];
clear r c

num_lnks = size(predict_links,1); % number of links to be predicted

% Initialize variables
scores=zeros(num_lnks,1);

% Empty cells for storing neighbours of row/col nodes
ne_r=cell(size(A,2),1); 
ne_c=cell(size(A,1),1); 

% compute neighbours (only for nodes in links)
nodes_r=unique(predict_links(:,1));
nodes_c=unique(predict_links(:,2));

parfor i=1:size(A,1)
    if any(i==nodes_r)
        ne_c{i}=find(A(i,:));
    end
end

parfor i=1:size(A,2)
    if any(i==nodes_c)
        ne_r{i}=find(A(:,i));
    end
end

deg_r_all=sum(A,2); % Degrees of all the row nodes
deg_c_all=sum(A,1); % Degrees of all the column nodes




parfor i=1:num_lnks
    % Parallized loop for each link in links
    % Take submatrix of neighbours of nodes involved in the link
    n_r=ne_r{predict_links(i,2)};
    n_c=ne_c{predict_links(i,1)};
    part_mat=A(n_r,n_c);
    
%     deg_r=deg_r_all(predict_links(i,1));
%     deg_c=deg_c_all(predict_links(i,2));
    
%     scores(i) = sum(sum(((1./deg_r(n_r))*(1./deg_c(n_c))).*part_mat));
    part_mat = ((deg_r_all(n_r))*deg_c_all(n_c)).*part_mat;
    part_mat = 1./part_mat;
    part_mat(isinf(part_mat))=0;
    scores(i) = sum(sum(part_mat));
    
end
