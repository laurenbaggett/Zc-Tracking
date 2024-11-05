function [speedStruct] = whale_spd(whale)

% this function will calculate speed from the smoothed positions of each
% whale in the encounter
% input: 
%   - whale struct, this is generated after you intersect DOA points using
%      the function loc3D_DOAintersect_includeCI
% output:
%   - speedStruct, this contains information about speed between points as
%       well as mean and median speeds for each tracked whale
%
% how does this work?
% calculate the distance between successive clicks using the
% distance formula
% sum all the distances to get the total distance
% divide each distance by time interval to get speed
% divide total distance by total time to get the average speed

speedStruct = []; % preallocate for saving later

for wn = 1:numel(whale) % for each whale in this encounter

    dist = []; % preallocate to hold distances
    tms = []; % preallocate for time durations
    spd = []; % preallocate to hold speed in m/s
    t = []; % preallocate to hold time vectors for each whale
    
    totalDist = nan(1,numel(whale)); % preallocate for total distance
    totalSpd = nan(1,numel(whale)); % preallocate for total speed
    meanSpd = nan(1,numel(whale)); % preallocate for mean speed
    medianSpd = nan(1,numel(whale)); % preallocate for median speeds
    deltaSpd = nan(1,numel(whale)); % preallocate for change in speed over course of track

    if size(whale{wn},2)>14 && size(whale{wn},1)>2 % if we generated a smooth for this whale
        
        for j = 1:length(whale{wn}.wlocSmooth)-1
            
            % distance calculations
            % define the points you're using
            x1 = whale{wn}.wlocSmooth(j,1);
            x2 = whale{wn}.wlocSmooth(j+1,1);
            y1 = whale{wn}.wlocSmooth(j,2);
            y2 = whale{wn}.wlocSmooth(j+1,2);
            z1 = whale{wn}.wlocSmooth(j,3);
            z2 = whale{wn}.wlocSmooth(j+1,3);
            % distance formula
            d = sqrt(((x2-x1)^2) + ((y2-y1)^2) + ((z2-z1)^2));
            % save the distance data
            dist(j) = d;

            % time calculations
            % define the times to use, should match above
            t1 = whale{wn}.TDet(j);
            t2 = whale{wn}.TDet(j+1);
            % find duration in seconds
            tDur = (t2-t1)*(60*60*24); % if you have datetimes, seconds(t2-t1);
            % save the time data
            tms(j) = tDur;
            
            % speed calculations
            spd(j) = d/tDur;

        end
        
        % remove outliers
        outlrs = isoutlier(spd,'mean'); % 'percentiles',[10 90]); % by z score
        spd(outlrs) = nan;

        totalDist = nansum(dist(:)); % keep in mind, this has breaks with nans for some whales
        trackedTimes = nansum(tms(~isnan(dist(:)))); % duration that we tracked during
        totalT = (whale{wn}.TDet(end) - whale{wn}.TDet(1))*(60*60*24);
        meanSpd = nanmean(spd(:));
        medianSpd = nanmedian(spd(:));
        stdSpd = nanstd(spd(:));

        summary = array2table([totalDist,totalT,trackedTimes,meanSpd,medianSpd,stdSpd],'VariableNames', ...
            {'totalDist','totalT','trackedTimes','meanSpd','medianSpd','stdSpd'});
        values = array2table([dist',tms',spd'],'VariableNames',{'dist','tms','spd'});

        wnStruct = struct('summary',summary,'values',values);
        speedStruct{wn} = wnStruct;

    else
        speedStruct{wn}=[]; 
    end % close if statement

end % close loop for whale numbers