% calc_lane_distance_2
% modified version trying to simplify, the old one got somewhat out of hand

df = dir(['F:\Tracking\Erics_detector\SOCAL_N_68\cleaned_tracks\track*']); % directory of folders containing files

% initiate an array to hold mean values
spd = 60*60*24;
depMeans = [];
depMax = [];
depMin = [];
depSlopes = [];
depTNums = [];
depWhl1 = [];
depWhl2 = [];

for i = 1:length(df) % for each track

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    myFile = dir([df(i).folder,'\',df(i).name,'\*distSpd.mat']); % load the folder name
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    epty = [];
    for b = 1:numel(whale) % remove any fields that are 0x0
        if size(whale{b},2) < 15
            whale{b} = [];
            epty = horzcat(epty,b);
            % dist(:,b) = [];
        end
    end
    if ~isempty(epty)
        if size(dist,2) >= max(epty)
            dist(:,epty) = [];
        end
    end
    for b = 1:length(epty)
        bepty = fliplr(epty);
        if bepty(b) <= length(totalDist)
            totalDist(bepty(b)) = [];
        end
    end
    whale(cellfun('isempty',whale)) = []; % remove any empty fields

    if length(whale) > 1 % if we have more than one whale

        laneDist = [];
        laneMeans = [];
        laneMax = [];
        laneMin = [];

        % interpolate
        for wn = 1:numel(whale)

            nandiff = diff(isnan(whale{wn}.wlocSmooth(:,1)));
            nchunk = find(nandiff); % find nonzero indices
            if isnan(whale{wn}.wlocSmooth(1,1)) % if we start with a nan, great
                nchunk = [nchunk; length(whale{wn}.wlocSmooth)];
            elseif isnan(whale{wn}.wlocSmooth(end,1))% if we end with a nan
                nchunk = [0;nchunk];
            else
                nchunk = [0;nchunk;length(whale{wn}.wlocSmooth)];
            end
            itrptot = [];

            for ch = 1:2:length(nchunk)-1
                if size(whale{wn}.wlocSmooth,1)>size(dist,1)
                    chlength = floor(nansum(dist(nchunk(ch)+1:nchunk(ch+1)-1,wn)));
                else
                    chlength = floor(nansum(dist(nchunk(ch)+1:nchunk(ch+1),wn)));
                end
                if size(whale{wn}.wlocSmooth(nchunk(ch)+1:nchunk(ch+1),1),1) > 1
                    itrp = interparc(chlength,whale{wn}.wlocSmooth(nchunk(ch)+1:nchunk(ch+1),1),whale{wn}.wlocSmooth(nchunk(ch)+1:nchunk(ch+1),2),whale{wn}.wlocSmooth(nchunk(ch)+1:nchunk(ch+1),3),whale{wn}.TDet(nchunk(ch)+1:nchunk(ch+1)),'pchip');
                    itrptot = [itrptot;itrp;nan(1,4)];
                end
            end

            if ~isempty(itrptot)
                whaleI{wn}.wlocSmooth = itrptot(:,1:3);
                whaleI{wn}.TDet = itrptot(:,4);
            end
        end

        whaleI(cellfun('isempty',whaleI)) = []; % remove any empty fields

        if numel(whaleI) > 1

            np = nchoosek(1:length(whaleI),2); % find the pair combos

            % find the closest point between each pair combo
            for n = 1:height(np)

                whale1full = whaleI{np(n,1)};
                whale2full = whaleI{np(n,2)};

                % okay, maybe just break into chunks and loop this
                firstnans = find(isnan(whale1full.TDet));
                secondnans = find(isnan(whale2full.TDet));

                % find the one that has the most chunks, if they have the same
                % then go through the first one
                if length(firstnans) == length(secondnans) && length(firstnans) == 1
                    whale1 = whale1full;
                    whale2 = whale2full;
                    if size(whale1.wlocSmooth,1)>3 && size(whale2.wlocSmooth,1)>3
                        [laneDist,laneMeans,laneMax,laneMin,labelstr,timeLag] = lane_dist2(whale1,whale2,np(n,:));

                        if any(laneDist>5000)
                            keyboard
                        end

                        laneDistPair{1} = laneDist;
                        laneMeansPair{1} = laneMeans;
                        laneMaxPair{1} = laneMax;
                        laneMinPair{1} = laneMin;
                        labelstrPair{1} = labelstr;
                        timeLagPair{1} = timeLag;
                    end

                elseif length(firstnans) > length(secondnans)

                    if firstnans(end) ~= length(whale1full.wlocSmooth)
                        firstnans = [0;firstnans;length(whale1full.wlocSmooth)];
                    else
                        firstnans = [0;firstnans];
                    end

                    for k = 1:length(firstnans)-1
                        whale1.wlocSmooth = whale1full.wlocSmooth(firstnans(k)+1:firstnans(k+1)-1,:);
                        whale1.TDet = whale1full.TDet(firstnans(k)+1:firstnans(k+1)-1,:);
                        matchnan = isnan(whale2full.wlocSmooth(:,1));
                        whale2full.wlocSmooth(matchnan,:) = repmat([10000 10000 10000],length(find(matchnan)),1);
                        [c,d] = min(dsearchn(whale2full.wlocSmooth,whale1.wlocSmooth)); % closest point in the second whale that match the first
                        [~,closest] = min(d);
                        closest = c(closest);

                        % now, match this to a specific chunk
                        matchnan = [0; find(matchnan); length(matchnan)];
                        lower_index = matchnan(find(matchnan <= closest, 1, 'last'));
                        upper_index = matchnan(find(matchnan >= closest, 1, 'first'));

                        whale2.wlocSmooth = whale2full.wlocSmooth(lower_index+1:upper_index-1,:);
                        whale2.TDet = whale2full.TDet(lower_index+1:upper_index-1);

                        if size(whale1.wlocSmooth,1)>3 && size(whale2.wlocSmooth,1)>3

                            [laneDist,laneMeans,laneMax,laneMin,labelstr,timeLag] = lane_dist2(whale1,whale2,np(n,:));

                            if any(laneDist>5000)
                                keyboard
                            end

                            laneDistPair{k} = laneDist;
                            laneMeansPair{k} = laneMeans;
                            laneMaxPair{k} = laneMax;
                            laneMinPair{k} = laneMin;
                            labelstrPair{k} = labelstr;
                            timeLagPair{k} = timeLag;

                        end

                    end

                elseif length(secondnans) > length(firstnans)

                    if secondnans(end) ~= length(whale2full.wlocSmooth)
                        secondnans = [0;secondnans;length(whale2full.wlocSmooth)];
                    else
                        secondnans = [0;secondnans];
                    end

                    for k = 1:length(secondnans)-1
                        whale2.wlocSmooth = whale2full.wlocSmooth(secondnans(k)+1:secondnans(k+1)-1,:);
                        whale2.TDet = whale2full.TDet(secondnans(k)+1:secondnans(k+1)-1,:);
                        matchnan = isnan(whale1full.wlocSmooth(:,1));
                        whale1full.wlocSmooth(matchnan,:) = repmat([10000 10000 10000],length(find(matchnan)),1);
                        [c,d] = dsearchn(whale1full.wlocSmooth,whale2.wlocSmooth); % closest point in the second whale that match the first
                        [~,closest] = min(d);
                        closest = c(closest);
                        % now, match this to a specific chunk
                        matchnan = [0; find(matchnan); length(matchnan)];
                        lower_index = matchnan(find(matchnan <= closest, 1, 'last'));
                        upper_index = matchnan(find(matchnan >= closest, 1, 'first'));

                        whale1.wlocSmooth = whale1full.wlocSmooth(lower_index+1:upper_index-1,:);
                        whale1.TDet = whale1full.TDet(lower_index+1:upper_index-1);

                        if size(whale1.wlocSmooth,1)>3 && size(whale2.wlocSmooth,1)>3

                            [laneDist,laneMeans,laneMax,laneMin,labelstr,timeLag] = lane_dist2(whale1,whale2,np(n,:));

                            if any(laneDist>5000)
                                keyboard
                            end
                            
                            laneDistPair{k} = laneDist;
                            laneMeansPair{k} = laneMeans;
                            laneMaxPair{k} = laneMax;
                            laneMinPair{k} = laneMin;
                            labelstrPair{k} = labelstr;
                            timeLagPair{k} = timeLag;

                        end

                    end

                elseif length(firstnans) == length(secondnans) && length(firstnans) > 1
                    if firstnans(end) ~= length(whale1full.wlocSmooth)
                        firstnans = [0;firstnans;length(whale1full.wlocSmooth)];
                    else
                        firstnans = [0;firstnans];
                    end

                    for k = 1:length(firstnans)-1
                        whale1.wlocSmooth = whale1full.wlocSmooth(firstnans(k)+1:firstnans(k+1),:);
                        whale1.TDet = whale1full.TDet(firstnans(k)+1:firstnans(k+1),:);
                        matchnan = isnan(whale2full.wlocSmooth(:,1));
                        [c,d] = min(dsearchn(whale2full.wlocSmooth,whale1.wlocSmooth)); % closest point in the second whale that match the first
                        [~,closest] = min(d);
                        closest = c(closest);

                        % now, match this to a specific chunk
                        matchnan = [0; find(matchnan); length(matchnan)];
                        lower_index = matchnan(find(matchnan <= closest, 1, 'last'));
                        upper_index = matchnan(find(matchnan >= closest, 1, 'first'));

                        whale2.wlocSmooth = whale2full.wlocSmooth(lower_index+1:upper_index-1,:);
                        whale2.TDet = whale2full.TDet(lower_index+1:upper_index-1);

                        if size(whale1.wlocSmooth,1)>1 && size(whale2.wlocSmooth,1)>1

                            [laneDist,laneMeans,laneMax,laneMin,labelstr,timeLag] = lane_dist2(whale1,whale2,np(n,:));

                            if any(laneDist>5000)
                                keyboard
                            end
                            
                            laneDistPair{k} = laneDist;
                            laneMeansPair{k} = laneMeans;
                            laneMaxPair{k} = laneMax;
                            laneMinPair{k} = laneMin;
                            labelstrPair{k} = labelstr;
                            timeLagPair{k} = timeLag;

                        end

                    end
                end

                if exist('laneDistPair','var')
                    laneDistFull{n} = laneDistPair;
                    laneMeansFull{n} = laneMeansPair;
                    laneMaxFull{n} = laneMaxPair;
                    laneMinFull{n} = laneMinPair;
                    labelstrFull{n} = labelstrPair;
                    timeLagFull{n} = timeLagPair;

                    clear laneDistPair; clear laneMeansPair; clear laneMaxPair; clear laneMinPair; clear labelstrPair; clear timeLagPair;
                end
            end

            if exist('laneDistFull','var')
                save([df(i).folder,'\',df(i).name,'\',trackNum,'_laneDist2.mat'],'laneDistFull','laneMeansFull','laneMaxFull','laneMinFull','labelstrFull','timeLagFull');
                clear laneDistFull; clear laneMeansFull; clear laneMaxFull; clear laneMinFull; clear labelstrFull; clear timeLagFull;
                clear whaleI; clear laneDist; clear laneMeans; clear laneMax; clear laneMin; clear labelstr; clear timeLag;
            end
        end

    end

end


%% put theses into large page per deployment
% deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75',...
%     'SOCAL_E_63','SOCAL_N_68',...
%     'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};

deps = {'SOCAL_N_68'};

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',deps{j},'\cleaned_tracks\track*']);

    for i = 1:length(df)

        myFile = dir([df(i).folder,'\',df(i).name,'\*_laneDist2.mat']); % load the folder name
        
        if ~isempty(myFile)
            trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    
            laneDistMaster{i} = laneDistFull;
            laneMeansMaster{i} = laneMeansFull;
            laneMaxMaster{i} = laneMaxFull;
            laneMinMaster{i} = laneMinFull;
            labelstrMaster{i} = labelstrFull;
            timeLagMaster{i} = timeLagFull;
        end

    end

    save(['F:\Tracking\Erics_detector\',deps{j},'\deployment_stats\',deps{j},'_laneDistFullDeployment2.mat'],'laneDistMaster','laneMeansMaster','laneMaxMaster','laneMinMaster','labelstrMaster','timeLagMaster');

end
