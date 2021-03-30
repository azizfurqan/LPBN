# Multimorbidity prediction using link prediction

## Furqan Aziz, Victor Roth Cardoso, Laura Bravo-Merodio, Dominic Russ, SamanthaC. Pendleton, John A. Williams, Animesh Acharje, and Georgios V. Gkoutos

This repository contains the code to implement link prediction in a bipartite temporal network discussed in the above paper.

## Code
There are three different scripts in this repository.

### function [scores] = Compute_PRA(A)
This scripts accepts the adjacency matrix of a bipartite graph as an input. It returns the similarity score between non-adjacent nodes computed using path-based resource allocation (PRA) similarity index discussed in the paper. The output is a matrix with same dimensions as that of A.

### function [scores] = Compute_PROP(A)
This scripts accepts the labelled adjacency matrix of a bipartite graph as an input. Each entry of the matrix represents the time at which the link was formed. This script returns the similarity score between non-adjacent nodes computed using probabilistic path-based resource allocation (PROP) similarity index discussed in the paper. The output is a matrix with same dimensions as that of A.

### function [PRA,PROP] = Compute_Prop_Indices(A)
This scripts accepts the labelled adjacency matrix of a bipartite graph as an input. Each entry of the matrix represents the time at which the link was formed. This script returns both the PRA and PROP matrices as discussed above. For PRA simility index, it ignores the labels on the edge of the graph and treats the graph as simple, unweighted, and unlabelled bipartite graph.
