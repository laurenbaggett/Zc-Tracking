% grp_dayNight_jd
% LMB 3/21/24 2023a

% directory of files
df = dir('F:\Tracking\Erics_detector\SOCAL_W_01\cleaned_tracks\track*');

% define effort period for this deployment
% % SOCAL_E_63
% effStart = datetime('15-March-2018');
% effEnd = datetime('11-Jul-2018');
% % SOCAL_N_68
% effStart = datetime('29-Apr-2020');
% effEnd = datetime('15-Dec-2020');
% % SOCAL_H_72
% effStart = datetime('06-Jun-2021');
% effEnd = datetime('19-Dec-2021');
% % SOCAL_H_73
% effStart = datetime('21-Dec-2021');
% effEnd = datetime('23-May-2022');
% % SOCAL_H_74
% effStart = datetime('23-May-2022');
% effEnd = datetime('15-Oct-2022');
% % SOCAL_H_75
% effStart = datetime('16-Oct-2022');
% effEnd = datetime('18-Apr-2023');
% SOCAL_W_01
effStart = datetime('29-Jul-2021');
effEnd = datetime('22-Jan-2022');
% % SOCAL_W_02
% effStart = datetime('10-Mar-2022');
% effEnd = datetime('27-May-2022');
% % SOCAL_W_03
% effStart = datetime('27-May-2022');
% effEnd = datetime('14-Oct-2022');
% % SOCAL_W_04
% effStart = datetime('17-Oct-2022');
% effEnd = datetime('15-Apr-2023');
% % SOCAL_W_05
% effStart = datetime('16-Apr-2023');
% effEnd = datetime('25-Sep-2023');

% connect to Tethys for diel data
q=dbInit('Server','breach.ucsd.edu','Port',9779);
% lat lon of san diego for diel data
lat = 32 + 42/60 + 52.9/3600;
lon = 360 - (117 + 09/60 + 21.6/3600);
night = dbDiel(q,lat, lon,  effStart, effEnd); %get sunrise sunset data

% start loopin
for i = 1:length(df)
    
    myFile = dir([df(i).folder,'\',df(i).name,'\*brushDOA.mat']); % load the folder name
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

    % did this encounter happen during the daytime or the nighttime?
    % tethys data gives sunset to sunrise times
    % find index of where this value falls during nighttime
    idx = find(StNum+datenum([2000 0 0 0 0 0]) > night(:,1) & StNum+datenum([2000 0 0 0 0 0]) < night(:,2));
    if isempty(idx) % if the start time doesn't fall during nighttime
        dt = 1; % this happened during the day
    elseif ~isempty(idx) % if the start time does fall during nighttime
        dt = 0; % this happened during the night
    end

    % find julian day
    jd = day(datetime(StNum,'convertfrom','datenum'),'dayofyear');
    
    % make the table!
    grpDayJDTable(i,:) = table(StNumstr,EdNumstr,encDur,StNum,EdNum,trackNum,numWhales,dt,jd);


end

% writetable(grpDayJDTable,'F:\Tracking\Erics_detector\SOCAL_W_05\deployment_stats\SOCAL_W_05_night_jd.csv');

clear all