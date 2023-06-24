% Analyzing GPS puck data from ROS bag files in MATLAB

% Load the ROS bag files containing GPS data
bag1 = rosbag("gps_stationary_2_2_8_2022.bag");
bag2 = rosbag("gps_linear_motion_2_8_2022.bag");

% Select the specific topic containing the GPS data
bsel1 = select(bag1, "Topic", "custom_message");
bsel2 = select(bag2, "Topic", "custom_message");

% Read the selected messages into MATLAB structures
msgStruct1 = readMessages(bsel1, 'DataFormat', 'struct');
msgStruct2 = readMessages(bsel2, 'DataFormat', 'struct');

% Extract UTM easting, UTM northing, and altitude data from the message structures
utm_easting_stat = cellfun(@(m) double(m.UtmEasting), msgStruct1);
utm_easting_lin = cellfun(@(m) double(m.UtmEasting), msgStruct2);
utm_northing_stat = cellfun(@(m) double(m.UtmNorthing), msgStruct1);
utm_northing_lin = cellfun(@(m) double(m.UtmNorthing), msgStruct2);
alt1 = cellfun(@(m) double(m.Altitude), msgStruct1);
alt2 = cellfun(@(m) double(m.Altitude), msgStruct2);

% Plot GPS data for stationary point reading
subplot(2, 1, 1)
plot(utm_easting_stat - min(utm_easting_stat), utm_northing_stat - min(utm_northing_stat), 'r+')
title("GPS Data Plot for a stationary point reading")
xlabel("UTM Easting (metres)")
ylabel("UTM Northing (metres)")

% Plot GPS data for straight line motion reading with best fit line
subplot(2, 1, 2)
plot(utm_easting_lin - min(utm_easting_lin), utm_northing_lin - min(utm_northing_lin), 'r+')
title("GPS Data Plot for a straight line motion reading")
xlabel("UTM Easting (metres)")
ylabel("UTM Northing (metres)")
hold on
p = polyfit(utm_easting_lin - min(utm_easting_lin), utm_northing_lin - min(utm_northing_lin), 1);
f = polyval(p, utm_easting_lin - min(utm_easting_lin));
plot(utm_easting_lin - min(utm_easting_lin), f, 'b-')
legend("Linear motion data", "Best fit line for linear motion data")
hold off

% Plot UTM easting and UTM northing readings for stationary point and straight line motion
figure
subplot(2, 2, 1)
plot(utm_easting_stat - min(utm_easting_stat), 'r+')
p = polyfit([1:length(utm_easting_stat)], utm_easting_stat - min(utm_easting_stat), 1);
f_utm_east_stat = polyval(p, [1:length(utm_easting_stat)]);
title("Stationary point UTM Easting Readings")
xlabel("Time (seconds)")
ylabel("UTM Easting (metres)")

subplot(2, 2, 2)
plot(utm_easting_lin - min(utm_easting_lin), 'r+')
title("Straight line motion UTM Easting Readings")
xlabel("Time (seconds)")
ylabel("UTM Easting (metres)")
hold on
p = polyfit([1:length(utm_easting_lin)], utm_easting_lin - min(utm_easting_lin), 1);
f = polyval(p, [1:length(utm_easting_lin)]);
plot(f, 'b')
legend("UTM Easting for straight line motion data", "Best fit line for UTM Easting for straight line motion data")
hold off

subplot(2, 2, 3)
plot(utm_northing_stat - min(utm_northing_stat), 'r+')
p = polyfit([1:length(utm_northing_stat)], utm_easting_stat - min(utm_northing_stat), 1);
f_utm_north_stat = polyval(p, [1:length(utm_northing_stat)]);
title("Stationary point UTM Northing Readings")
xlabel("Time (seconds)")
ylabel("UTM Northing (metres)")

subplot(2, 2, 4)
plot(utm_northing_lin - min(utm_northing_lin), 'r+')
title("Straight line motion UTM Northing Readings")
xlabel("Time (seconds)")
ylabel("UTM Northing (metres)")
hold on
p = polyfit([1:length(utm_northing_lin)], utm_northing_lin - min(utm_northing_lin), 1);
f = polyval(p, [1:length(utm_northing_lin)]);
plot(f, 'b')
legend("UTM Northing for Linear motion data", "Best fit line for UTM northing for Linear motion data")
hold off

% Plot altitude readings for stationary point and linear motion
figure
subplot(2, 1, 1)
plot(alt1, 'r+')
title("Stationary point altitude readings")
xlabel("Time (seconds)")
ylabel("Altitude (metres)")
hold on
p = polyfit([1:length(alt1)], alt1, 1);
f = polyval(p, [1:length(alt1)]);
plot(f, 'b')
legend("Stationary point altitude data", "Best fit line for Stationary point altitude data")
hold off

subplot(2, 1, 2)
plot(alt2, 'r+')
title("Linear motion altitude readings")
xlabel("Time (seconds)")
ylabel("Altitude (metres)")
hold on
p = polyfit([1:length(alt2)], alt2, 1);
f = polyval(p, [1:length(alt2)]);
plot(f, 'b')
legend("Linear motion altitude data", "Best fit line for Linear motion altitude data")
hold off

% Calculate and plot the error in UTM easting and UTM northing for stationary point readings
utm_east_stat_err = f_utm_east_stat - utm_easting_stat;
utm_north_stat_err = f_utm_north_stat - utm_northing_stat;
figure
subplot(2, 1, 1)
plot(abs(utm_east_stat_err - min(utm_east_stat_err)), 'o')
title('Absolute values of UTM Easting stationary point error values from best fit line values')
xlabel('Time (seconds)')
ylabel('Absolute value of error (metres)')

subplot(2, 1, 2)
plot(abs(utm_north_stat_err - min(utm_north_stat_err)), 'o')
title('Absolute values of UTM Northing stationary point error values from best fit line values')
xlabel('Time (seconds)')
ylabel('Absolute value of error (metres)')

% Calculate the mean altitude for stationary point and linear motion data
mean_alt_stat = mean(alt1);
fprintf("Mean of stationary point data altitude: %f\n", mean_alt_stat);

mean_alt_lin = mean(alt2);
fprintf("Mean of linear motion data altitude: %f\n", mean_alt_lin);

% Calculate the mean, standard deviation, minimum, maximum, and range of UTM Easting for the stationary point data
mean_utm_easting_stat = mean(utm_easting_stat);
std_utm_easting_stat = std(utm_easting_stat);
min_utm_easting_stat = min(utm_easting_stat);
max_utm_easting_stat = max(utm_easting_stat);
range_utm_easting_stat = max(utm_easting_stat) - min(utm_easting_stat);

% Calculate the mean, standard deviation, minimum, maximum, and range of UTM Easting for the linear motion data
mean_utm_easting_lin = mean(utm_easting_lin);
std_utm_easting_lin = std(utm_easting_lin);
min_utm_easting_lin = min(utm_easting_lin);
max_utm_easting_lin = max(utm_easting_lin);
range_utm_easting_lin = max(utm_easting_lin) - min(utm_easting_lin);

% Calculate the mean, standard deviation, minimum, maximum, and range of UTM Northing for the stationary point data
mean_utm_northing_stat = mean(utm_northing_stat);
std_utm_northing_stat = std(utm_northing_stat);
min_utm_northing_stat = min(utm_northing_stat);
max_utm_northing_stat = max(utm_northing_stat);
range_utm_northing_stat = max(utm_northing_stat) - min(utm_northing_stat);

% Calculate the mean, standard deviation, minimum, maximum, and range of UTM Northing for the linear motion data
mean_utm_northing_lin = mean(utm_northing_lin);
std_utm_northing_lin = std(utm_northing_lin);
min_utm_northing_lin = min(utm_northing_lin);
max_utm_northing_lin = max(utm_northing_lin);
range_utm_northing_lin = max(utm_northing_lin) - min(utm_northing_lin);

% Display the calculated statistics for UTM Easting and UTM Northing
fprintf("Statistics for UTM Easting (Stationary Point):\n");
fprintf("Mean: %f\n", mean_utm_easting_stat);
fprintf("Standard Deviation: %f\n", std_utm_easting_stat);
fprintf("Minimum Value: %f\n", min_utm_easting_stat);
fprintf("Maximum Value: %f\n", max_utm_easting_stat);
fprintf("Range: %f\n", range_utm_easting_stat);

fprintf("Statistics for UTM Easting (Linear Motion):\n");
fprintf("Mean: %f\n", mean_utm_easting_lin);
fprintf("Standard Deviation: %f\n", std_utm_easting_lin);
fprintf("Minimum Value: %f\n", min_utm_easting_lin);
fprintf("Maximum Value: %f\n", max_utm_easting_lin);
fprintf("Range: %f\n", range_utm_easting_lin);

fprintf("Statistics for UTM Northing (Stationary Point):\n");
fprintf("Mean: %f\n", mean_utm_northing_stat);
fprintf("Standard Deviation: %f\n", std_utm_northing_stat);
fprintf("Minimum Value: %f\n", min_utm_northing_stat);
fprintf("Maximum Value: %f\n", max_utm_northing_stat);
fprintf("Range: %f\n", range_utm_northing_stat);

fprintf("Statistics for UTM Northing (Linear Motion):\n");
fprintf("Mean: %f\n", mean_utm_northing_lin);
fprintf("Standard Deviation: %f\n", std_utm_northing_lin);
fprintf("Minimum Value: %f\n", min_utm_northing_lin);
fprintf("Maximum Value: %f\n", max_utm_northing_lin);
fprintf("Range: %f\n", range_utm_northing_lin);

%{
figure
plot(alt1)
hold on
plot(alt2)
legend("Stationary point altitude data","Linear motion altitude data")
title("Stationary point and linear motion altitude data plot")
xlabel("Time")
ylabel("Altitude")
hold off
%}