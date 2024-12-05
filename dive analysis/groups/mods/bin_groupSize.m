%% bin_groupSize
% move group size into bins! choose 20 minutes because that's about the
% mean from the track duration histograms

logs = readtable('F:\Tracking\groups\siteW_cleanedTracksTable.csv');
% logs = readtable('F:\Tracking\groups\siteH_cleanedTracksTable.csv');
% logs = readtable('F:\Tracking\groups\siteE_cleanedTracksTable.csv');
% logs = readtable('F:\Tracking\groups\siteN_cleanedTracksTable.csv');

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
% % SOCAL W
effort.Start = datetime('30-Jul-2021 04:29:59');
effort.End = datetime('25-Sep-2023 19:45:00');
% % SOCAL H
% effort.Start = datetime('01-Jul-2021 21:29:59');
% effort.End = datetime('18-Apr-2023 00:02:17');

% % SOCAL_H
% effort.Start = [datetime('01-Jul-2021 21:29:59') datetime('21-Dec-2021 01:00:00') datetime('10-Jun-2022 22:00:00') datetime('17-Oct-2022 00:00:00')];
% effort.End = [datetime('23-Oct-2021 01:10:03') datetime('22-May-2022 21:59:27') datetime('15-Oct-2022 21:05:36') datetime('17-Apr-2023 20:41:06')];

% SOCAL_W
effort.Start = [datetime('30-Jul-2021 04:29:59') datetime('10-Mar-2022 03:15:00') datetime('27-May-2022 20:02:00') datetime('19-Oct-2022 02:00:00') datetime('16-Apr-2023 19:00:00')];
effort.End = [datetime('15-Jan-2022 13:51:24') datetime('27-May-2022 17:23:34') datetime('14-Oct-2022 18:49:30') datetime('23-Oct-2022 00:45:12') datetime('25-Sep-2023 19:45:00')];

% connect to Tethys for diel data
q=dbInit('Server','breach.ucsd.edu','Port',9779);
% lat lon of san diego for diel data
lat = 32 + 42/60 + 52.9/3600;
lon = 360 - (117 + 09/60 + 21.6/3600);
night = dbDiel(q,lat, lon,  effort.Start, effort.End); %get sunrise sunset data

% define time bin duration
p.binDur = 320; % 25 minutes

%% group effort in bins
effort.diffSec = seconds(effort.End-effort.Start) ;
effort.bins = effort.diffSec/(60*p.binDur);
effort.roundbin = round(effort.diffSec/(60*p.binDur));

% convert intervals in bins 
binEffort = intervalToBinTimetable_LMB(effort.Start,effort.End,p); 
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

for i = 1:height(binData)

    stTime = datenum(binEffort.tbin(i)); % grab this starting datetime

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
    % add in other parameters!
    % day or night?
    % tethys data gives sunset to sunrise times
    % find index of where this value falls during nighttime
    dt(i) = fn_normTimeofd_ASB(stTime,night(:,1),night(:,2));
    
    % find julian day
    jd(i) = day(datetime(stTime,'convertfrom','datenum'),'dayofyear');

end

% create site letter vector
binData = table(binEffort.tbin,binEffort.sec,binData,dt',jd');
binData.Properties.VariableNames = {'tbin','binSec','groupSize','dayNight','jd'};

% writetable(binData, ['F:\Tracking\groups\',filePrefix,'_binned_320min_groups_allVars_plotting.csv'])
% save('F:\Tracking\groups\SOCAL_W_binned_groups.mat','binData');


%% stick in the binned presence metric

df = load('F:\Tracking\groups\siteHmod\SiteH_120min_presBins.mat');
presBins = array2table(df.a.Var1);
binData(:,6) = presBins;
binData.Properties.VariableNames = {'tbin','binSec','groupSize','dayNight','jd','presBins'};
writetable(binData,['F:\Tracking\groups\',filePrefix,'_binned_120min_groups_allVars_plotting.csv'])

%% plot a time series of the binned group sizes

% site H
df = readtable('F:\Tracking\groups\SOCAL_H_binned_120min_groups_allVars_plotting.csv');
df = table2timetable(df);
df.groupSize(df.groupSize==0) = NaN;


dfweek = retime(df,'weekly','mean');
offEffort = dfweek(isnan(dfweek.binSec),:);

figure(1)
colororder({'[0.3 0.3 0.3]','k'})
yyaxis left
hold on
bar(offEffort.tbin,repelem(7,size(offEffort,1)),'barwidth',1,'facecolor', [0.8 0.8 0.8],'edgecolor','none')
bar(dfweek.tbin,dfweek.groupSize,'barwidth',1,'edgecolor','none')
hold on
ylabel('Mean Group Size/Week')
% ylim([0 5])
yyaxis right
scatter(dfweek.tbin(dfweek.binSec>0&dfweek.binSec<7200),(dfweek.binSec(dfweek.binSec>0&dfweek.binSec<7200)/7200)*100,10,'o','filled')
ylim([0 100])
ylabel("% of Effort/Week")

% site W