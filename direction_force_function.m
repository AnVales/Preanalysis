% TITLE: DIRECTION FORCE FUNCTION
% AUTHOR: ANVALES : https://github.com/AnVales
% DATE: 01/06/2021

% Determine in which direction the identation took place

function [output_direction] = direction_force_function(input_direction, force_x, force_y)

if strcmp(input_direction,'West')|strcmp(input_direction,'East')
    output_direction = force_x;
else
    output_direction = force_y;
end

end

