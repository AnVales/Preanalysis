% BEAD DETERMINATION FUNCTION %

% Determine which bead was the sensor and which was the identator 

function [force_bead,sensor_bead] = bead2_determination_function(input_direction_force)

rango1 = range(input_direction_force(:,1));
rango2 = range(input_direction_force(:,2));

if rango1 > rango2
    force_bead = input_direction_force(:,1);
    sensor_bead = input_direction_force(:,2);
else
    force_bead = input_direction_force(:,2);
    sensor_bead = input_direction_force(:,1);
end

end

