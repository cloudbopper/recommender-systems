% Collaborative filtering using iterative SVD
clear all;
close all;
clc;

% load data
% load 'toy.mat';
load 'ratings.mat';

% R: boolean matrix with 1 where rating is available
% Y: matrix containing ratings
% R, Y: matrices containing training data
% R_test, Y_test: matrices containing test data
[num_movies, num_users] = size(Y);

% Add ratings for a new user to the data matrix
% Play with ratings in my_ratings.m to see difference in recommendations
new_user_ratings;
Y = [my_ratings Y];
R = [(my_ratings ~= 0) R];
Y_test = [zeros(num_movies, 1) Y_test];
R_test = [zeros(num_movies, 1) R_test];
[num_movies, num_users] = size(Y);

%  Normalized ratings
[Ynorm, Ymean] = normalizeRatings(Y, R);

% Truncation parameter
k = 10;
% Threshold difference between old/new SVD, after which we stop iterating
threshold = 1e-5;
M = Y;

for i = 1:num_movies
    M(M(i,:) == 0) = Ymean(i);
end

M_old = Inf * ones(num_movies, num_users);
count = 0;

while (norm(M - M_old, 'fro') > threshold && count < 100)
    fprintf('Now at iteration: %d\n', count);
    count = count + 1;
    M_old = M;
    [U,S,V] = svd(M);
    % truncate SVD
    M = U(:,1:k) * S(1:k,1:k) * V(:,1:k)';
    % generate new rating matrix Y from truncated SVD
    for i = 1:num_movies
        for j = 1:num_users
            if R(i,j)
                M(i,j) = Y(i,j);
            end
        end
    end
end

% predict ratings for new user
my_predictions = M(:,1) + Ymean;

[r, ix] = sort(my_predictions, 'descend');
fprintf('\nTop recommendations for you:\n');
for i=1:10
    j = ix(i);
    fprintf('Predicting rating %.1f for movie %s\n', my_predictions(j), ...
            movieList{j});
end

fprintf('\n\nOriginal ratings provided (change these in new_user_ratings.m):\n');
for i = 1:length(my_ratings)
    if my_ratings(i) > 0 
        fprintf('Rated %d for %s\n', my_ratings(i), ...
                 movieList{i});
    end
end

% Evaluate performance on test set
error = norm(M .* R_test - Y_test, 'fro');
fprintf('\nSquared error on test set: %f\n\n', error);