%% LMB 3/23/23
% look for patterns in my data! when are we seeing large group sizes?

deployment = 'SOCAL_W_05';
deploymentName = 'SOCAL W 05';

df = dir('F:\Tracking\Erics_detector\SOCAL_W_05\cleaned_tracks\*track*'); % cleaned tracks dir
savedir = 'F:\Tracking\Erics_detector\SOCAL_W_05\group_size\' % where you want the results to be saved
numTracks = length(df);

for i = 1:length(df) % for each track
    
    myFile = dir([df(i).folder,'\',df(i).name,'\SOCAL*.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load the file
    
    trackNum = sscanf(df(i).name,'track%d'); % grab the track number
    
    num4ch1 = length(unique(DET{1}.Label)); % how many whale nums in 4ch 1
    num4ch2 = length(unique(DET{2}.Label)); % how many whale nums in 4ch 2
    
    numWhales = max(num4ch1,num4ch2); % how many whales total for this track
    
    % if there are detections on both 4 channels
    if ~isempty(DET{1}.TDet) & ~isempty(DET{2}.TDet)
        % grab time stamps
        tSt1 = DET{1}.TDet(1); % from array 1
        tEd1 = DET{1}.TDet(end);
        tSt2 = DET{2}.TDet(1); % from array 2
        tEd2 = DET{2}.TDet(2);
        
        % keep the earlier first time datenum
        if tSt1 > tSt2
            StNum = tSt2;
        else if tSt2 > tSt1
                StNum = tSt1;
            end
        end
        % keep the later last time datenum
        if tEd1 > tEd2
            EdNum = tEd1;
        else if tEd2 > tEd1
                EdNum = tEd2;
            end
        end
        
    elseif isempty(DET{1}.TDet)
        % grab time stamps
        tSt2 = DET{2}.TDet(1); % from array 2
        tEd2 = DET{2}.TDet(2);
        
        % keep the earlier first time datenum
        StNum = tSt2;
        % keep the later last time datenum
        EdNum = tEd2;
        
    elseif isempty(DET{2}.TDet)
        % grab time stamps
        tSt1 = DET{1}.TDet(1); % from array 1
        tEd1 = DET{1}.TDet(2);
        
        StNum = tSt1;
        EdNum = tEd1;
    end
    
    
    % convert datenum to datetime
    StNumstr = datetime(StNum,'ConvertFrom','datenum','Format','dd-MMM-20yy HH:mm:ss');
    EdNumstr = datetime(EdNum,'ConvertFrom','datenum','Format','dd-MMM-20yy HH:mm:ss');
    
    % find encounter duration
    encDur = EdNumstr-StNumstr;
    
    % make the table!
    cleanedTracksTable(i,:) = table(StNumstr,EdNumstr,encDur,StNum,EdNum,trackNum,numWhales);
    
end

% sort table by time
cleanedTracksTable = sortrows(cleanedTracksTable,'StNumstr','ascend');

save([savedir,'cleanedTracksTable2.mat'],'cleanedTracksTable');