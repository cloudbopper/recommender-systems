% recommender system using nearest neighbor collaborative filtering

clear all;
close all;
clc;

ratings_file = 'data/ratings.dat';
users_file = 'data/users.dat';
movies_file = 'data/movies.dat';

fprintf('Loading data...\n');
[rating_data, user_data, movie_data] = load_data(ratings_file, users_file, movies_file);

fprintf('Pre-processing data...\n');
tic;
% number of nearest neighbors to select
k = 10;
% percentage of data to use in training set
training_fraction = 0.8;

% data counts
num_ratings = size(rating_data{1}, 1);
num_users = size(user_data{1}, 1);
num_movies = size(movie_data{1}, 1);

% divide data into training/test sets
training_size = floor(training_fraction * num_ratings);
test_size = num_ratings - training_size;

idx = randperm(num_ratings);
training_idx = idx(1:training_size);
test_idx = idx(training_size+1:end);

training_users = rating_data{1}(training_idx);
training_movies = rating_data{2}(training_idx);
training_ratings = rating_data{3}(training_idx);

test_users = rating_data{1}(test_idx);
test_movies = rating_data{2}(test_idx);
test_ratings = rating_data{3}(test_idx);

% identify indices of users by movie, and movies by user, for efficiency
movies_to_idx = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
users_to_idx = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
for i = 1:training_size
    movie = training_movies(i);
    if isKey(movies_to_idx, movie)
        idx = movies_to_idx(movie);
        idx(end+1) = i;
        movies_to_idx(movie) = idx;
    else
        movies_to_idx(movie) = i;
    end

    user = training_users(i);
    if isKey(users_to_idx, user)
        idx = users_to_idx(user);
        idx(end+1) = i;
        users_to_idx(user) = idx;
    else
        users_to_idx(user) = i;
    end
end
t = toc;
fprintf('Time required to pre-process data: %f seconds\n', t);

% test
fprintf('Testing...\n');
tic;
for i = 1:test_size
    % the (user, movie) pair that we want a prediction for
    user = test_users(i);
    movie = test_movies(i);
    actual_rating = test_ratings(i);
    
    idx_i = users_to_idx(user);
    ratings_i = training_ratings(idx_i);
    %normalized_ratings_i = 
    for j = 1:size(idx_i)
        ratings_i = training_ratings(users_to_idx(j));
    end
    ratings_i = ratings_i/mean(ratings_i);

    if ~isKey(movies_to_idx, movie)
        % movie not rated by any user in the training set
        % skip
        continue
    end
    % identify users who have rated this movie
    idx = movies_to_idx(movie);
    correlation_vector = zeros(size(idx, 1));
    for j = 1:size(idx)
        k = idx(j);
        user_k = training_users(k);
        rating_k = training_ratings(k);
    end
end
t = toc;
fprintf('Time required to test: %f seconds\n', t);