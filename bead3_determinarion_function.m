% BEAD DETERMINATION FUNCTION %

% Determine which bead was the sensor and which was the identator 

function [output_force_bead, output_sensor_bead, output_nucleolo_bead] = bead3_determination_function(input_direction_force)

rango1 = range(input_direction_force(:,1));
rango2 = range(input_direction_force(:,2));
rango3 = range(input_direction_force(:,3));

if rango1 > rango2 && rango2 > rango3
    output_force_bead = input_direction_force(:,1);
    output_sensor_bead = input_direction_force(:,2);
    output_nucleolo_bead = input_direction_force(:,3);
    
elseif rango1 > rango3 && rango3 > rango2
    output_force_bead = input_direction_force(:,1);
    output_sensor_bead = input_direction_force(:,3);
    output_nucleolo_bead = input_direction_force(:,2);
    
elseif rango2 > rango1 && rango1 > rango3
    output_force_bead = input_direction_force(:,2);
    output_sensor_bead = input_direction_force(:,1);
    output_nucleolo_bead = input_direction_force(:,3);
 
elseif rango2 > rango3 && rango3 > rango1
    output_force_bead = input_direction_force(:,2);
    output_sensor_bead = input_direction_force(:,3);
    output_nucleolo_bead = input_direction_force(:,1);
    
elseif rango3 > rango1 && rango1 > rango2
    output_force_bead = input_direction_force(:,3);
    output_sensor_bead = input_direction_force(:,1);
    output_nucleolo_bead = input_direction_force(:,2);
    
elseif rango3 > rango2 && rango2 > rango1
    output_force_bead = input_direction_force(:,3);
    output_sensor_bead = input_direction_force(:,2);
    output_nucleolo_bead = input_direction_force(:,1);
end

end

