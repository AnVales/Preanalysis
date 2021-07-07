% SEARCH PATTERN FUNCTION %
% AUTHOR: ANVALES : https://github.com/AnVales
% DATE: 21/05/2021

% Some data of the path is saved

function [output_nucleus_number, output_frecuency, output_position] = search_pattern_function(input_path)

% Split path of /
path_split = strsplit(input_path, '/');

% Nucleus number
pattern_nucleus = '\d';
nucleus_number_cell = regexp(path_split(2), pattern_nucleus, 'match');
output_nucleus_number = cell2mat(nucleus_number_cell{1});

% Frecuency
pattern_frecuency = '\d(\d)?';
frecuency_cell = regexp(path_split(4), pattern_frecuency, 'match');
frecuency = cell2mat(frecuency_cell{1});
output_frecuency = str2double(frecuency);

% Position
pattern_position = 'North|South|West|East';
position_cell = regexp(path_split(3), pattern_position, 'match');
output_position = cell2mat(position_cell{1});

end

