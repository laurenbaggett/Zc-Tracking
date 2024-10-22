%% bin_groupSize
% move group size into bins! choose 20 minutes because that's about the
% mean from the track duration histograms

bw1 = load('F:\Tracking\Erics_detector\SOCAL_W_01\group_size\cleanedTracksTable.mat');
bw2 = load('F:\Tracking\Erics_detector\SOCAL_W_02\group_size\cleanedTracksTable.mat');
bw3 = load('F:\Tracking\Erics_detector\SOCAL_W_03\group_size\cleanedTracksTable.mat');
bw4 = load('F:\Tracking\Erics_detector\SOCAL_W_04\group_size\cleanedTracksTable.mat');
bw5 = load('F:\Tracking\Erics_detector\SOCAL_W_05\group_size\cleanedTracksTable.mat');
logs = vertcat(bw1.cleanedTracksTable,bw2.cleanedTracksTable,bw3.cleanedTracksTable,bw4.cleanedTracksTable);
% bw1 = load('F:\Tracking\Erics_detector\SOCAL_H_72\group_size\cleanedTracksTable.mat');
% bw2 = load('F:\Tracking\Erics_detector\SOCAL_H_73\group_size\cleanedTracksTable.mat');
% bw3 = load('F:\Tracking\Erics_detector\SOCAL_H_74\group_size\cleanedTracksTable.mat');
% bw4 = load('F:\Tracking\Erics_detector\SOCAL_H_75\group_size\cleanedTracksTable.mat');
% bw1 = bw1.cleanedTracksTable; bw2 = bw2.cleanedTracksTable; 
% bw3 = bw3.cleanedTracksTable; bw4 = bw4.cleanedTracksTable;
% logs = vertcat(bw1,bw2,bw3,bw4);

% logs = load('F:\Tracking\Erics_detector\SOCAL_E_63\group_size\cleanedTracksTable.mat');
% logs = logs.cleanedTracksTable;

filePrefix = 'SOCAL_W';

% define effort
spd = 60*60*24; % seconds per day for datetime conversion
fs = 100000; % sample rate (Hz)
% % SOCAL N 68
% effort.Start = datetime('27-May-2020 19:30:00');
% effort.End = datetime('15-Oct-2020 17:17:55');
% % SOCAL E 63
% effort.Start = datetime('15-Mar-2018 06:00:00');
% effort.End = datetime('05-Jul-2018 03:26:31');
% SOCAL W
effort.Start = datetime('30-Jul-2021 04:29:59');
effort.End = datetime('25-Sep-2023 19:45:00');
% % SOCAL H
% effort.Start = datetime('01-Jul-2021 21:29:59');
% effort.End = datetime('18-Apr-2023 00:02:17');

% connect to Tethys for diel data
q=dbInit('Server','breach.ucsd.edu','Port',9779);
% lat lon of san diego for diel data
lat = 32 + 42/60 + 52.9/3600;
lon = 360 - (117 + 09/60 + 21.6/3600);
night = dbDiel(q,lat, lon,  effort.Start, effort.End); %get sunrise sunset data

% define time bin duration
p.binDur = 275; % 20 minutes

%% group effort in bins
effort.diffSec = seconds(effort.End-effort.Start) ;
effort.bins = effort.diffSec/(60*p.binDur);
effort.roundbin = round(effort.diffSec/(60*p.binDur));

% convert intervals in bins 
binEffort = intervalToBinTimetable_hr(effort.Start,effort.End,p); 
binEffort.Properties.VariableNames{1} = 'bin';
binEffort.Properties.VariableNames{2} = 'sec';

%% group logs in bins

binData = zeros(size(binEffort.tbin,1),1); % preallocate
numtbins = datenum(binEffort.tbin);

for i = 1:size(logs,1)
    
    % start times
    stTime = logs.StNum(i) + datenum([2000 0 0 0 0 0]); % grab this starting datetime
    [~, closeStIdx] = min(abs(numtbins-stTime)); % find the closest time bin
    if numtbins(closeStIdx) > stTime % if the time bin starts after the log start
        closeStIdx = closeStIdx - 1; % move back 1 bin
    end
    
    % end times
    edTime = logs.EdNum(i) + datenum([2000 0 0 0 0 0]); % grab this ending datetime
    [~, closeEdIdx] = min(abs(numtbins-edTime)); % find the closest time bin
    if numtbins(closeEdIdx) < edTime % if the time bin starts after the log end
        closeEdIdx = closeEdIdx + 1; % move up 1 bin
    end

    % log bin durations
    if closeStIdx == closeEdIdx % if log occurs within one time bin
        logIdx = closeStIdx;
    else % if log occurs within multiple time bins
        logIdx = closeStIdx:1:closeEdIdx;
    end

    % % add in other parameters!
    % % day or night?
    % % tethys data gives sunset to sunrise times
    % % find index of where this value falls during nighttime
    % idx = find(stTime > night(:,1) & stTime < night(:,2));
    % if isempty(idx) % if the start time doesn't fall during nighttime
    %     dt(i) = 1; % this happened during the day
    % elseif ~isempty(idx) % if the start time does fall during nighttime
    %     dt(i) = 0; % this happened during the night
    % end
    % 
    % % find julian day
    % jd(i) = day(datetime(stTime,'convertfrom','datenum'),'dayofyear');

    
    for n = 1:length(logIdx)
        if logIdx(n)~=0
            binData(logIdx(n)) = binData(logIdx(n))+logs.numWhales(i); % plug these values in
        end
    end

end

%% add in other parameters!

for i = 1:length(binData)

    stTime = datenum(binEffort.tbin(i)); % grab this starting datetime

    % add in other parameters!
    % day or night?
    % tethys data gives sunset to sunrise times
    % find index of where this value falls during nighttime
    idx = find(stTime > night(:,1) & stTime < night(:,2));
    if isempty(idx) % if the start time doesn't fall during nighttime
        dt(i) = 1; % this happened during the day
    elseif ~isempty(idx) % if the start time does fall during nighttime
        dt(i) = 0; % this happened during the night
    end

    % find julian day
    jd(i) = day(datetime(stTime,'convertfrom','datenum'),'dayofyear');

end

% create site letter vector
binData = table(binEffort.tbin,binEffort.sec,binData,dt',jd');
binData.Properties.VariableNames = {'tbin','binSec','groupSize','dayNight','jd'};

% writetable(binData, 'F:\Tracking\groups\SOCAL_W_binned_groups.csv')
% save('F:\Tracking\groups\SOCAL_W_binned_groups.mat','binData');


%% replace no effort time bins with nans
% replace the zeros with nans
% % site H
% noEffort = [datetime('19-Dec-2021 00:11:15'), datetime('21-Dec-2021 01:00:00');
%     datetime('23-May-2022 00:38:45'), datetime('10-Jun-2022 22:00:00');
%     datetime('15-Oct-2022 23:28:45'), datetime('17-Oct-2022 00:00:00')];

% site W
noEffort = [datetime('15-Jan-2022 13:51:24'), datetime('09-Mar-2022 19:00:00');
    datetime('27-May-2022 15:46:58'), datetime('27-May-2022 20:02:00');
    datetime('14-Oct-2022 18:49:30'), datetime('19-Oct-2022 02:00:00');
    datetime('15-Apr-2023 18:10:11'), datetime('16-Apr-2023 19:00:00')];

for i = 1:size(noEffort,1)
    
    % start times
    stTime = datenum(noEffort(i,1)); % grab this starting datetime
    [~, closeStIdx] = min(abs(numtbins-stTime)); % find the closest time bin
    if numtbins(closeStIdx) > stTime % if the time bin starts after the log start
        closeStIdx = closeStIdx - 1; % move back 1 bin
    end
    
    % end times
    edTime = datenum(noEffort(i,2)); % grab this ending datetime
    [~, closeEdIdx] = min(abs(numtbins-edTime)); % find the closest time bin
    if numtbins(closeEdIdx) < edTime % if the time bin starts after the log end
        closeEdIdx = closeEdIdx + 1; % move up 1 bin
    end

    % log bin durations
    if closeStIdx == closeEdIdx % if log occurs within one time bin
        logIdx = closeStIdx;
    else % if log occurs within multiple time bins
        logIdx = closeStIdx:1:closeEdIdx;
    end
    
    for n = 1:length(logIdx)
        if logIdx(n)~=0 && binData.groupSize(logIdx(n))==0
            binData.groupSize(logIdx(n)) = NaN; % plug these values in
        end
    end

end

writetable(binData, 'F:\Tracking\groups\siteWmod\SOCAL_W_binned_275min_groups.csv')
% save('F:\Tracking\groups\SOCAL_W_binned_260min_groups.mat','binData');

%% stick in the binned presence metric

df = readtable('F:\Tracking\groups\siteWmod\SOCAL_W_binned_275min_groups.csv');
load('F:\Tracking\groups\siteWmod\SiteW_275min_presBins.mat');
df(:,6) = array2table(a.Var1);
df.Properties.VariableNames = {'tbin','binSec','groupSize','dayNight','jd','presBins'};
writetable(df,'F:\Tracking\groups\siteWmod\SOCAL_W_binned_275min_groups.csv')