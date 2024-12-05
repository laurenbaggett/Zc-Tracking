%% calc_dist_btwn_whaleGrps
% LMB 02/23/2024 in 2023a

% this script will calculate the distance between whales swimming
% simultaneously
% estimate from smoothed positions and then using the confidence intervals

df = dir(['F:\Tracking\Erics_detector\SOCAL_H_75\cleaned_tracks\track*']); % directory of folders containing files

% initiate an array to hold mean values
grpDistVals = [];
grpDistMeans = [];
grpDistSlopes = [];
labs = [];
spd = 60*60*24;

for i = 1:length(df) % for each track

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    for b = 1:numel(whale) % remove any fields that are 0x0
        if height(whale{b}) < 3
            whale{b} = [];
        elseif size(whale{b},2)<15
            whale{b} = [];
        end
    end
    whale(cellfun('isempty',whale)) = []; % remove any empty fields

    if length(whale) > 1 % if we have more than one whale

        % interpolate
        for wn = 1:numel(whale)
            tstart = whale{wn}.TDet(1);
            tend = whale{wn}.TDet(end);
            ti = tstart:1/spd:tend; % interpolate by 1 s interval
            lngth(wn) = length(whale{wn}.TDet);
            whaleI{wn}.TInterp = ti;
            for dim = 1:3
                whaleI{wn}.wlocSmooth(:, dim) = interp1(whale{wn}.TDet, whale{wn}.wlocSmooth(:, dim), ti);
            end
        end

        % initialize values for storing
        time = zeros(max(lngth),length(whale));
        x = zeros(max(lngth),length(whale));
        y = zeros(max(lngth),length(whale));
        z = zeros(max(lngth),length(whale));

        for wn = 1:length(whaleI) % for each whale

            time(1:length(whaleI{wn}.TInterp),wn) = whaleI{wn}.TInterp; % grab time
            x(1:length(whaleI{wn}.wlocSmooth(:,1)),wn) = whaleI{wn}.wlocSmooth(:,1); % grab x position
            y(1:length(whaleI{wn}.wlocSmooth(:,2)),wn) = whaleI{wn}.wlocSmooth(:,2); % grab y position
            z(1:length(whaleI{wn}.wlocSmooth(:,3)),wn) = whaleI{wn}.wlocSmooth(:,3); % grab z position

        end % close wn for loop

        % okay, now we should have grabbed interpolated values for each whale
        np = nchoosek(1:length(whaleI),2); % find the pair combos

        for n = 1:height(np) % for each possible pair

            % align the times
            timePair = datetime(time(:,np(n,:)),'convertfrom','datenum');
            timePair = dateshift(timePair,'start','second');
            for p = 1:2 % remove any zeros that have now been converted to a weird datetime
                blanks = find(timePair(:,p)=='31-Dec--0001 00:00:00');
                timePair(blanks,p) = NaT;
            end
            xPair = x(:,np(n,:));
            yPair = y(:,np(n,:));
            zPair = z(:,np(n,:));

            % remove early values
            tDiff = seconds(timePair(1,1) - timePair(1,2));
            [~,isct1,isct2] = intersect(timePair(:,1),timePair(:,2));

            if ~isempty(isct1)
                timePair = [timePair(isct1,1), timePair(isct2,2)];
                xPair = [x(isct1,1), x(isct2,2)];
                yPair = [y(isct1,1), y(isct2,2)];
                zPair = [z(isct1,1), z(isct2,2)];

                % whew, okay after all of that we have the smoothed positions
                % only at overlapping times between these pairs

                % calculate the (euclidian) distance between pairs
                clear d
                if height(timePair) >= 2
                    for j = 1:length(timePair)
                        d(j) = sqrt(((xPair(j,1)-xPair(j,2))^2) + ((yPair(j,1)-yPair(j,2))^2) + ((zPair(j,1)-zPair(j,2))^2));
                    end
                    % fit a line
                    mdl = polyfit(1:length(d),d,1);

                    encSep{1,n} = horzcat(d',datenum(timePair(:,1)));
                    labelstr{1,n} = {['whale pair ', num2str(np(n,:))]};
                    mns{1,n} = mean(abs(d));
                    slope{1,n} = mdl(1);
                end

            end % close idx if statement
        end % close pairs for loop

        if exist('encSep','var')    % if we have data
            % save these values for referencing later! only if there are
            % multiple whales in this encounter
            save([char(myFile.folder),'\',char(trackNum),'_distBtwnWhales.mat'],'encSep','mns','slope','labelstr'); % save the whale struct

            % save min pairs dist, max pairs dist, number of whales in the
            % encounter
            minPair(i) = min(abs(cell2mat(mns)));
            maxPair(i) = max(abs(cell2mat(mns)));
            numW(i) = size(whale,2);

            % also, make a plot
            figure(1)
            hold on
            for k = 1:length(encSep)
                if height(encSep{k}) ~= 0
                    plot(encSep{k}(:,2),encSep{k}(:,1))
                end
            end
            datetick('x')
            ylabel('meters')
            legend(char(vertcat(labelstr{:})))

            % save the plot
            saveas(gcf,[myFile.folder,'\',trackNum,'_distBtwnWhalesFig.fig']); % save the fig

            grpDistVals{i} = encSep;
            grpDistMeans{i} = mns;
            labs{i} = labelstr;
            grpDistSlopes{i} = slope;

        end % close if statement for encSep

        clear timePair; clear timePair1; clear timePair2
        clear trueEnd1; clear trueEnd2; clear whale; clear whaleI
        clear xPair; clear xPair1; clear xPair2; clear x
        clear yPair; clear yPair1; clear yPair2; clear y
        clear zPair; clear zPair1; clear zPair2; clear z
        clear encSep; clear labelstr; clear b; clear mns;
        clear slope; close all

    end % close if statement for multiple whales

end % close for loop for each encounter

% save('F:\Tracking\Erics_detector\SOCAL_W_04\deployment_stats\SOCAL_W_04_maxminPairs.mat', 'minPair','maxPair','numW');
save('F:\Tracking\Erics_detector\SOCAL_H_75\deployment_stats\SOCAL_H_75_distBtwnGrps.mat','grpDistVals','grpDistMeans','grpDistSlopes','numW','labs');