function [ ratings, users, movies ] = load_data( ratings_file, users_file, movies_file )
% Populates utility matrix for collaborative filtering
% Data must be formatted as: user_id::movie_id::rating::rating_timestamp
% For more details, see: https://github.com/sidooms/MovieTweetings
%
% Generates matrix A of users vs movies
% with non-zero values for available ratings

% minimum of movies a user must have rated, for his ratings to be included
num_min_ratings = 1;

fid1 = fopen(ratings_file, 'r');
ratings = textscan(fid1, '%u16 %u %u8 %*u', 'delimiter', '\t');

fid2 = fopen(users_file, 'r');
users = textscan(fid2, '%u16 %u', 'delimiter', '\t');

fid3 = fopen(movies_file, 'r');
movies = textscan(fid3, '%u %s %s', 'delimiter', '\t');

fclose(fid1);
fclose(fid2);
fclose(fid3);

end