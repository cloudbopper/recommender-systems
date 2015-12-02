% Collaborative filtering using latent factor optimization
clear all;
close all;
clc;

% Rating matrix of movies vs users
load('ratings.mat');

% R: boolean matrix with 1 where rating is available
% Y: matrix containing ratings
% R, Y: matrices containing training data
% R_test, Y_test: matrices containing test data
[num_movies, num_users] = size(Y);

% fprintf('Number of ratings in training set: %d\n', sum(sum(R)));
% fprintf('Number of ratings in test set: %d\n', sum(sum(R_test)));

% Add ratings for a new user to the data matrix
% Play with ratings in my_ratings.m to see difference in recommendations
new_user_ratings;
Y = [my_ratings Y];
R = [(my_ratings ~= 0) R];
Y_test = [zeros(num_movies, 1) Y_test];
R_test = [zeros(num_movies, 1) R_test];
[num_movies, num_users] = size(Y);

%  Normalize ratings
[Ynorm, Ymean] = normalizeRatings(Y, R);

% number of features (number of columns in P/Q)
num_features = 10;
% regularization parameter
lambda = 1.5;

% We want to find P, Q s.t. Y is close to Q . P'
% Initialize P,Q with small random values
P = randn(num_users, num_features);
Q = randn(num_movies, num_features);
% Initialize P,Q with SVD of Y
% with unrated values replaced by means
% M = Y;
% for i = 1:num_movies
%     M(M(i,:) == 0) = Ymean(i);
% end
% [U,S,V] = svd(M);
% sqrt_S = sqrtm(S(1:num_features, 1:num_features));
% Q = U(:, 1:num_features) * sqrt_S;
% P = V(:, 1:num_features) * sqrt_S;

initial_params = [Q(:); P(:)];

% options for optimization function fmincg
options = optimset('GradObj', 'on', 'MaxIter', 100);

fprintf('\nTraining recommender system...\n');

theta = fmincg (@(t)(latentFactorsCostFunction(t, Y, R, num_users, ...
                                num_movies, num_features, lambda)), ...
                                initial_params, options);

fprintf('Recommender system learning completed.\n');

% Unfold the returned theta back into Q and P
Q = reshape(theta(1:num_movies*num_features), num_movies, num_features);
P = reshape(theta(num_movies*num_features+1:end), ...
                num_users, num_features);

% predictions            
predictions = Q * P';

% predict ratings for new user
my_predictions = predictions(:,1) + Ymean;

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
error = norm(predictions .* R_test - Y_test, 'fro');
fprintf('\nSquared error on test set: %f\n\n', error);