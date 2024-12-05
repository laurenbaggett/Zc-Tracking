% calculate_bearing_angle


% dfList = {'SOCAL_N_68'};
dfList = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};
% dfList = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04', 'SOCAL_W_05'};
% dfList = {'SOCAL_E_63'};
spd = 60*60*24;

allbearingmeans = [];

for m = 1:length(dfList)

    df = dir(['F:\Tracking\Erics_detector\',char(dfList(m)),'\cleaned_tracks\track*']); % directory of folders containing files
    spd = 60*60*24;

    for i = 1:length(df) % for each track

        myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
        trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

        for b = 1:numel(whale) % remove any fields that are 0x0
            if height(whale{b}) <= 2
                whale{b} = [];
            end
        end
        whale(cellfun('isempty',whale)) = []; % remove any empty fields

        for wn = 1:numel(whale)

            allbearing = [];
            % just for E since flipped order of instruments
            % whale{wn}.wlocSmooth(:,2) = whale{wn}.wlocSmooth(:,2)*-1;

            if size(whale{wn},2) > 14

            for n = 1:length(whale{wn}.wlocSmooth(:,1))-1
                % differences between iterative points
                delta_x = whale{wn}.wlocSmooth(n+1,1) - whale{wn}.wlocSmooth(n,1);
                delta_y = whale{wn}.wlocSmooth(n+1,2) - whale{wn}.wlocSmooth(n,2);

                % calculate angle in radians
                angle_rad = atan2(delta_y,delta_x);
                % convert to degrees
                bearing = rad2deg(angle_rad);

                % Adjust bearing to have 0° at East
                bearing = mod(bearing, 360); % 0° at east
                % theta_transformed = mod(90-theta, 360);

                allbearing = [allbearing,bearing];

            end

            meanbearing = mean(allbearing);
            allbearingmeans = [allbearingmeans,meanbearing];

            end

        end

    end
end

thisSite = dfList{1}(7);
c = cmocean('dense');
thiscol = c(60,:);

figure
h = polarhistogram(allbearingmeans,10,'FaceColor',thiscol,'facealpha',.9);
ax = gca;
% if we're at site E, since I flipped reclocs initially 0 degrees is west
% all other deployments will be east
if dfList{1} == 'SOCAL_E_63'
    ax.ThetaZeroLocation = 'left';
end
title([thisSite])
% ax.ThetaZeroLocation = 'left';
