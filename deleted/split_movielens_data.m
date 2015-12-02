% Loads MovieLens 100k ratings
% http://grouplens.org/datasets/movielens/
% and divides them into training and test sets

clear all;
close all;
clc;

load 'movielens100k.mat';

% loads R (boolean matrix indicating rating presence)
% and Y (rating matrix with valid ratings corresponding to each 1 in R)
[m,n] = size(R);
training_fraction = 0.95;
y = zeros(m,1);
count = 0;
R_train = R;
Y_train = Y;
R_test = zeros(m,n);
Y_test = zeros(m,n);

while (sum(y == 0) ~= 0)
    % split into training/test sets
    R_test = zeros(m,n);
    Y_test = zeros(m,n);
    R_train = R;
    Y_train = Y;

    for i = 1:m
        for j = 1:n
            if (R(i,j) && rand() > training_fraction)
                R_test(i,j) = R(i,j);
                Y_test(i,j) = Y(i,j);
                R_train(i,j) = 0;
                Y_train(i,j) = 0;
            end
        end
    end

    % Verify that no movie is unrated by all users in the training set
    y = sum(R_train, 2);
    count = count + 1;
end

R = R_train;
Y = Y_train;
save ratings.mat R Y R_test Y_test;