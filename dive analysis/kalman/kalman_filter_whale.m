function [whaleOut] = kalman_filter_whale(whaleIn,k,min_velocity,max_velocity,min_azimuth,max_azimuth,min_elevation,max_elevation,win,maxtimegap)

% kalman_filter_whale
% Take localized points from Where's Whaledo loc3D_DOA_intersect and smooth
% them by applying a Kalman filter and moving average smoothing.
% LMB Oct 2024
% lbaggett@ucsd.edu
%
% Inputs:
% whale: the whale struct that is outputted from your loc3D intersect step
% k: the number of nearest neighbors to consider for removing outlier
%       points from your position estimate
% min_velocity: the minimum velocity (a negative number) that you allow
%       your whale to swim in m/s
% max_velocity: the maximum velocity (a positive number) that you allow
%       your whale to swim in m/s
% min_azimuth: the minimum azimuth that you allow your whale to move
%       between time steps in radians
% max_azimuth: the maximum azimuth that you allow your whale to move
%       between time steps in radians
% min_elevation: the minimum elevation that you allow your whale to move
%       between time steps in radians
% max_elevation: the maximum elevation that you allow your whale to move
%       between time steps in radians
% win: the number of detections that you would like to consider in your
%       moving average. This step further smooths your detections. If you would
%       not like to calculate a moving average, set this value at 1.
% maxtimegap: the maximum time gap allowed between points that you are
%       interpolating through. If you encounter a time gap larger than this
%       threshold, no smoothed position for that period will be generated.
%
% Example input:
% whale = kalman_filter_whale(whale,10,-10,10,-pi/4,pi/4,-pi/4,pi/4,20,60);
%   ** these are the settings that I typically use for beaked whales (Zc).
%       Modify as necessary for your species of interest.

whaleOut = whaleIn; % save input whale for output
spd = 60*60*24; % seconds per day for datetime to seconds conversion

for wn = 1:numel(whaleIn) % for each whale in this encounter

    if height(whaleIn{wn}) > 10 % if we have more than 10 clicks for this whale

        measurements = whaleIn{1,wn}.wloc; % localized positions
        time = whaleIn{wn}.TDet; % time stamps
        error = [(whaleIn{wn}.CIx(:,2)-whaleIn{wn}.CIx(:,1))/2, ...
            (whaleIn{wn}.CIy(:,2)-whaleIn{wn}.CIy(:,1))/2, ...
            (whaleIn{wn}.CIz(:,2)-whaleIn{wn}.CIz(:,1))/2]; % position error

        % calculate distances to k nearest neighbors
        distances = pdist2(measurements, measurements); % pairwise distance matrix
        sorted_distances = sort(distances, 2); % sort for each point (rows)
        nearest_distances = sorted_distances(:, 2:k+1); % retain distances to k nearest neighbors

        % mean and standard deviation for outlier calculations
        mean_distances = mean(nearest_distances, 2);
        std_distances = std(nearest_distances, 0, 2);

        % define a threshold for the outliers (here if the value is more
        % than 2 standard deviations out)
        outlier_threshold = mean_distances + 2 * std_distances;

        % remove the outliers
        measurements(any(nearest_distances > outlier_threshold, 2), :) = nan;
        error(any(nearest_distances > outlier_threshold, 2), :) = nan;

        N = size(measurements, 1); % total number of clicks for this whale

        H = [1 0 0 0 0 0 0 0; % x measurement
            0 1 0 0 0 0 0 0; % y measurement
            0 0 1 0 0 0 0 0]; % z measurement

        % here we could incorporate a correlated random walk to better
        % model this noise; could learn the correlation in each dimension
        % to update the model with
        Q = [0.1 0 0 0 0 0 0 0; % process noise x
            0 0.1 0 0 0 0 0 0; % process noise y
            0 0 0.1 0 0 0 0 0; % process noise z
            0 0 0 0.1 0 0 0 0; % process noise vx
            0 0 0 0 0.1 0 0 0; % process noise vy
            0 0 0 0 0 0.1 0 0; % process noise vz
            0 0 0 0 0 0 0.01 0; % process noise azimuth
            0 0 0 0 0 0 0 0.01]; % process noise elevation

        x_interpolated = zeros(8, N); % store estimates

        for i = 1:N-1 % skip the first and last measurements

            dt = time(i+1)-time(i); % time difference btwn measurements for this pair

            if dt < maxtimegap/spd; % if this time step is smaller than our max allowed

                % initial estimate is the measured position
                x_est = [measurements(i,1); measurements(i,2); measurements(i,3); 0; 0; 0; 0; 0];
                P_est = eye(8); % identity matrix for initial covariance (again here we could incorporate
                % the correlated random walk idea, we know something about the
                % correlation instead of modeling it as identity)

                % state transition matrix
                F = [1 0 0 dt 0 0 0 0; % x position
                    0 1 0 0 dt 0 0 0; % y position
                    0 0 1 0 0 dt 0 0; % z position
                    0 0 0 1 0 0 0 0; % x velocity
                    0 0 0 0 1 0 0 0; % y velocity
                    0 0 0 0 0 1 0 0; % z velocity
                    0 0 0 0 0 0 1 0; % azimuth
                    0 0 0 0 0 0 0 1]; % elevation

                % predict the state based on transition matrix, model noise
                x_pred = F * x_est; % predicted state
                P_pred = F * P_est * F' + Q; % predicted covariance

                % constrain the velocities
                x_pred(4) = max(min(x_pred(4), max_velocity), min_velocity); % vx
                x_pred(5) = max(min(x_pred(5), max_velocity), min_velocity); % vy
                x_pred(6) = max(min(x_pred(6), max_velocity), min_velocity); % vz

                % constrain azimuths and elevations
                x_pred(7) = mod(x_pred(7), 2*pi); % normalize az btwn 0 and 2pi
                if x_pred(7) < min_azimuth % if the prediction is below the min az
                    x_pred(7) = min_azimuth; % make it the min
                elseif x_pred(7) > max_azimuth % if the prediction is above the max az
                    x_pred(7) = max_azimuth; % make it the max
                end

                if x_pred(8) < min_elevation % if the prediction is below the min el
                    x_pred(8) = min_elevation; % make it the min
                elseif x_pred(8) > max_elevation % if the prediction is above the max el
                    x_pred(8) = max_elevation; % make it the max el
                end

                % measurement error
                % use the error calculated for this click in the earlier
                % jackknife approach
                R = diag([error(i,1), error(i,2), error(i,3)]);

                if ~isnan(measurements(i, 1)) % if we have a value here
                    z = measurements(i, :)'; % make a vector with x,y,z position
                    y = z - H * x_pred; % residual (measurement)
                    S = H * P_pred * H' + R; % residual (covariance)
                    K = P_pred * H' / S; % calculate the Kalman gain

                    x_est = x_pred + K * y; % update the state estimate
                    P_est = (eye(size(K,1)) - K * H) * P_pred; % update the covariance

                    % store our estimated state
                    x_interpolated(:, i) = x_est;

                else
                    % in the case that we're missing a value, just store the
                    % predicted number (this should retain nans throughout)
                    x_est = x_pred;
                    P_est = P_pred;

                    x_interpolated(:, i) = x_est;
                end

            else % if our timestamp is greater than the max allowed
                x_interpolated(:,i) = nan; % just insert a nan
            end

        end

        % grab our estimated positions
        positions_estimated = x_interpolated(1:3, :); % x, y, z
        azimuth_estimated = x_interpolated(7, :);
        elevation_estimated = x_interpolated(8, :);

        window_size = win; % window size for the moving average

        % apply moving average smoothing
        positions_estimated = positions_estimated';
        % if the window size is larger than the number of points we have
        % (happens around the endpoints), shrink to fit to the smaller
        % window
        smoothed_walk_x = movmean(positions_estimated(:, 1), window_size,'endpoints','shrink');
        smoothed_walk_y = movmean(positions_estimated(:, 2), window_size,'endpoints','shrink');
        smoothed_walk_z = movmean(positions_estimated(:, 3), window_size,'endpoints','shrink');

        % combine smoothed coordinates
        whaleOut{wn}.wlocSmooth = [smoothed_walk_x, smoothed_walk_y, smoothed_walk_z];

    end

end