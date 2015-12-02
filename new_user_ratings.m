% Add ratings for new user

% Assumes num_movies = number of movies is already populated
fid = fopen('movie_ids.txt');

movieList = cell(num_movies, 1);
for i = 1:num_movies
    % Read line
    line = fgets(fid);
    % Word Index (can ignore since it will be = i)
    [idx, movieName] = strtok(line, ' ');
    % Actual Word
    movieList{i} = strtrim(movieName);
end
fclose(fid);

%  Initialize my ratings
my_ratings = zeros(num_movies, 1);

% Check the file movie_idx.txt for id of each movie in our dataset
% For example, Toy Story (1995) has ID 1, so to rate it "4", you can set
my_ratings(1) = 4;

% Or suppose did not enjoy Silence of the Lambs (1991), you can set
my_ratings(98) = 2;

% We have selected a few movies we liked / did not like and the ratings we
% gave are as follows:
my_ratings(7) = 3;
my_ratings(12)= 5;
my_ratings(54) = 4;
my_ratings(64)= 5;
my_ratings(66)= 3;
my_ratings(69) = 5;
my_ratings(183) = 4;
my_ratings(226) = 5;
my_ratings(355)= 5;

%fprintf('\n\nNew user ratings:\n');
for i = 1:length(my_ratings)
    if my_ratings(i) > 0 
        %fprintf('Rated %d for %s\n', my_ratings(i), ...
        %         movieList{i});
    end
end