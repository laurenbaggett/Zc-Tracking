% calc_grp_area.m
% LMB 3/6/24 2023a
% this script calculates the distance between the whales in the group that
% are furthest apart

%% something is weird with the indexing in here methinks, everything is the same value when it gets saved.
% go through it line by line and figure out what is going on

df = dir(['F:\Tracking\Erics_detector\SOCAL_W_02\cleaned_tracks\track*']); % directory of folders containing files

% initiate an array to hold mean values
grpAreas = [];
spd = 60*60*24;

for i = 1:length(df) % for each track

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    for b = 1:numel(whale) % remove any fields that are 0x0
        if height(whale{b}) < 2
            whale{b} = [];
        end
    end
    whale(cellfun('isempty',whale)) = []; % remove any empty fields

    if length(whale) ~= 1 % if we have more than one whale

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

            % align the times
            timePair = datetime(time,'convertfrom','datenum');
            timePair = dateshift(timePair,'start','second');
            firstblank = repelem(length(timePair)+1,numel(whale));

            for p = 1:numel(whale) % remove any zeros that have now been converted to a weird datetime
                blanks = find(timePair(:,p)=='31-Dec--0001 00:00:00');
                timePair(blanks,p) = NaT;
                x(blanks,p) = NaN;
                y(blanks,p) = NaN;
                z(blanks,p) = NaN;
                if ~isempty(blanks)
                firstblank(1,p) = blanks(1); % save these indices for later
                end
            end

            % find the latest start time
            [late, lateidx] = max(timePair(1,:));
            % find the earliest end time
            for s = 1:numel(firstblank)
                eds(1,s) = timePair(firstblank(s)-1,s);
            end
            [early, earlyidx] = min(eds(1,:));

            for p = 1:numel(whale)
                matchSt = find(timePair(:,p)==late);
                if matchSt ~=1
                    timePair(1:matchSt-1,p) = NaT;
                    x(1:matchSt-1,p) = NaN;
                    y(1:matchSt-1,p) = NaN;
                    z(1:matchSt-1,p) = NaN;
                end
                matchEd = find(timePair(:,p)==early);
                if matchEd ~= length(timePair(:,p))
                    timePair(matchEd+1:end,p) = NaT;
                    x(matchEd+1:end,p) = NaN;
                    y(matchEd+1:end,p) = NaN;
                    z(matchEd+1:end,p) = NaN;
                end
            end

            % check if there is overlap between all whales
            for wn = 1:length(whale)
                sz(wn) = length(rmmissing(timePair(:,wn)));
            end

            if range(sz) == 0 % if there is time overlap
                tOvrlp = []; xOvrlp = []; yOvrlp = []; zOvrlp = [];
                for d = 1:size(timePair,2)
                    tOvrlp = horzcat(tOvrlp,rmmissing(timePair(:,d)));
                    xOvrlp = horzcat(xOvrlp,rmmissing(x(:,d)));
                    yOvrlp = horzcat(yOvrlp,rmmissing(y(:,d)));
                    zOvrlp = horzcat(zOvrlp,rmmissing(z(:,d)));
                end
                
                np = nchoosek(1:size(tOvrlp,2),2); % find the pair combos
                % calculate the (euclidian) distance between pairs
                clear d
                firstPos = zeros(length(tOvrlp),3);
                secondPos = zeros(length(tOvrlp),3);
                if height(tOvrlp) >= 2
                    for j = 1:length(tOvrlp) % for each time interval
                        cand = zeros(1,height(np));
                        for n = 1:height(np) % for each possible pair
                        cand(n) = sqrt(((xOvrlp(j,np(n,1))-xOvrlp(j,np(n,2)))^2) + ((yOvrlp(j,np(n,1))-yOvrlp(j,np(n,2)))^2) + ((zOvrlp(j,np(n,1))-zOvrlp(j,np(n,2)))^2));
                        end
                    d(j) = max(abs(cand));
                    maxIdx = np(find(max(abs(cand))),:);
                    firstPos(j,:) = [xOvrlp(j,maxIdx(1)), yOvrlp(j,maxIdx(1)), zOvrlp(j,maxIdx(1))];
                    secondPos(j,:) = [xOvrlp(j,maxIdx(2)), yOvrlp(j,maxIdx(2)), zOvrlp(j,maxIdx(2))];
                    end
                    grpMaxDist = horzcat(d',datenum(tOvrlp(:,1)));
                    farPos{1} = firstPos;
                    farPos{2} = secondPos;
                end

            end % close idx if statement
        end

        if exist('grpMaxDist')    % if we have data
            % save these values for referencing later! only if there are
            % multiple whales in this encounter
            save([char(myFile.folder),'\',char(trackNum),'_grpMaxDist.mat'],'grpMaxDist', 'farPos'); % save the whale struct
            
            mstGrpMaxDist{i} = grpMaxDist;
            mstFarPos{i} = farPos;
        
        end 

        clear whaleI; clear grpMaxDist

end % close for loop for each encounter

% save('F:\Tracking\Erics_detector\SOCAL_W_01\deployment_stats\SOCAL_W_01_grpArea.mat','mstGrpMaxDist','mstFarPos');