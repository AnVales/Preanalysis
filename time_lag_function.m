% TITLE: TIME LAG FUNCTION
% AUTHOR: ÁNGELA VALES 
% DATE: 21/05/2021
% It looks for the time lag between the sensor bead and force bead

function [output_time_lag, output_time_lag_list] = time_lag_function(input_force_bead, input_sensor_bead, input_time, input_cycle_data)

[force_pks, force_loc] = findpeaks(input_force_bead(5*input_cycle_data:end)); % find peaks and its location
[sensor_pks, sensor_loc] = findpeaks(input_sensor_bead(5*input_cycle_data:end)); % find peaks and its location

time_short = input_time((5*input_cycle_data:end));

force_pks_t = time_short(force_loc); % find the time of the peaks
sensor_pks_t = time_short(sensor_loc); % find the time of the peaks

times_sensor = length(sensor_loc);
times_force = length(force_loc);

times = 0;

if times_sensor < times_force
    times = times_sensor;
elseif times_force < times_sensor
    times = times_force;
elseif times_sensor == times_force
    times = times_force;
end
    
output_time_lag_list = zeros(1, times);

for i = 1: times
    lag = sensor_pks_t(i) - force_pks_t(i);
    output_time_lag_list(i) = abs(lag);
end

output_time_lag = mean(output_time_lag_list);

end

