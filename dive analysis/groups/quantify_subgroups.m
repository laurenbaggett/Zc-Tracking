%% quantify_subgroups
% LMB 3/25/24 2023a

df = dir(['F:\Tracking\Erics_detector\SOCAL_W_03\cleaned_tracks\track*']); % directory of folders containing files
spd = 60*60*24;

subgrp = []; % initialize to store

for i = 1:length(df) % for each track

    myFile = dir([df(i).folder,'\',df(i).name,'\*distBtwnWhales.mat']); % load the folder name

    if size(myFile,1)>0

        trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
        myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

        for ns = 1:length(encSep)
            if ~isempty(encSep{ns})
                distMin = min(encSep{ns}(:,1)); % find the minimum distance between the pair
                distSt = encSep{ns}(1,1); % how far apart are they when they start

                for b = 1:numel(whale) % remove any fields that are 0x0
                    if height(whale{b}) == 0
                        whale{b} = [];
                    end
                end
                whale(cellfun('isempty',whale)) = []; % remove any empty fields

                np = nchoosek(1:length(whale),2); % find the pair combos

                for n = 1:height(np) % for each possible pair
                    firstEd = whale{np(n,1)}.TDet(end);
                    secondEd = whale{np(n,2)}.TDet(end);
                    firstSt = whale{np(n,1)}.TDet(1);
                    secondSt = whale{np(n,2)}.TDet(1);

                    % check to see if there is no time overlap
                    if firstEd < secondSt | secondEd < firstSt
                        subgrp = vertcat(subgrp,[cellstr(['whale pair ', num2str(np(n,:))]),trackNum,length(whale),'time']);
                    % elseif secondEd <firstSt
                    %     subgrp = vertcat(subgrp,[cellstr(['whale pair ', num2str(np(n,:))]),trackNum,length(whale),'time']);
                    end

                end

                % remove things due to space
                if distMin > 1000 % || distSt > 500 % if whales are always more than 1 km apart
                    subgrp = vertcat(subgrp,[labelstr{ns},trackNum,length(whale),'space']); % save those pairs that are far apart
                end

            end
        end
    end
end

% ['whale pair ', num2str(np(n,:))]
subgrp = sortrows(subgrp,2);
[~,~,idx] = unique(string(subgrp(:,[1:4])),'rows');
tally = accumarray(idx,(1:numel(idx)).',[],@(x){idx(x)});
subgrp2 = subgrp(cellfun(@(x)numel(x)==1,tally),:);

tracks = unique(subgrp2(:,2));

for i = 1:height(tracks)
   
    % find matching tracks
    sameTrack = find(matches(subgrp2(:,2),tracks(i))==1);
    whaleNums = [];
    for j = 1:length(sameTrack)
        thisName = char(subgrp2(sameTrack(j),1));
        whaleNumsIdx = find(isletter(thisName));
        whaleNums = vertcat(whaleNums,str2double(strsplit(strtrim(char(thisName(whaleNumsIdx(end)+1:end))))));
        totWhales = cell2mat(subgrp2(sameTrack(j),3));
    end

    % sort into groups from here
    % find what is different from whale 1
    whaleDiffs = [];
    for j = 1:totWhales
        firstWhaleDiffs = find(whaleNums(:,1)==j);
        whaleDiffs = vertcat(whaleDiffs,whaleNums(firstWhaleDiffs,:));
    end



end

% save('')

%% problem here--seems to have lots of repeats, can't really remove the identical rows 
% need to do some thinking here on how to proceed, how to divide up into
% subgroups
