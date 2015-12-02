function [J, grad] = latentFactorsCostFunction(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
% latentFactorsCostFunction: Collaborative filtering cost function
%   [J, grad] = latentFactorsCostFunction(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.

% Unfold the P and Q matrices from params
Q = reshape(params(1:num_movies*num_features), num_movies, num_features);
P = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

% Notes: Q - num_movies  x num_features matrix of movie features
%        P - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%
%        P_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Q_grad - num_users x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of Theta
%

H = Q * P';
M = R .* (H - Y);
J = (1/2) * (sum(sum(M .^ 2)) + lambda * (sum(sum(P .^ 2)) + sum(sum(Q .^ 2))));

Q_grad = M * P + lambda * Q;
P_grad = M' * Q + lambda * P;

grad = [Q_grad(:); P_grad(:)];

end
