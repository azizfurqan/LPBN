function [predict_links,scores] = Compute_PRA(A)

%For upload on Github

%A is the adjacency matrix
%score: Path-based RA scores


[r,c]=find(A==0); % R:row indices, c:column indices)
predict_links=[r c];
clear r c

num_lnks = size(predict_links,1); % number of links to be predicted

% Initialize variables
scores=zeros(num_lnks,1);



% Neighbours list for each row and column
ne_r = cellfun(@(x) find(x),num2cell(A,1),'un',0);
ne_r = ne_r';
ne_c = cellfun(@(x) find(x),num2cell(A,2),'un',0);

deg_r_all=sum(A,2); % Degrees of all the row nodes
deg_c_all=sum(A,1); % Degrees of all the column nodes


parfor i=1:num_lnks
    % Parallized loop for each link in links
    % Take submatrix of neighbours of nodes involved in the link
    n_r=ne_r{predict_links(i,2)};
    n_c=ne_c{predict_links(i,1)};
    sub_mat=A(n_r,n_c);
    

    sub_mat = ((deg_r_all(n_r))*deg_c_all(n_c)).*sub_mat;
    sub_mat = 1./sub_mat;
    sub_mat(isinf(sub_mat))=0;
    scores(i) = sum(sum(sub_mat));
    
end
