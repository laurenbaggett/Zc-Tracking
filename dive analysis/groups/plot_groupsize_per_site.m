% plot group size from each deployment at a single site!
% add a spline

group{1} = load('F:\Tracking\Erics_detector\SOCAL_W_05\group_size\cleanedTracksTable.mat');
% group{1,1}.cleanedTracksTable(71:77,:) = [];
% group{2} = load('F:\Erics_detector\SOCAL_H_73\group_size\cleanedTracksTable.mat');
% group{3} = load('F:\Erics_detector\SOCAL_H_74\group_size\cleanedTracksTable.mat');

% fullTable = vertcat(group{1,1}.cleanedTracksTable,group{1,2}.cleanedTracksTable,group{1,3}.cleanedTracksTable);
fullTable = group{1}.cleanedTracksTable;

timeVec = table2array(fullTable(:,1));
timeVec(173,:) = []; % delete the 180th index, diplicate
timeVec2 = table2array(fullTable(:,4));
timeVec2(173,:) = [];
% timeVec = datetime(timeVec);
whaleNumVec = table2array(fullTable(:,end));
whaleNumVec(173,:) = []; % delete the duplicate
% fit a sixth order polynomial
f6 = fit(timeVec2,whaleNumVec,'poly5');
% fit a spline
f6 = fit(timeVec2,whaleNumVec,'smoothingspline','smoothingparam',0.01);


figure
% bar(timeVec2,whaleNumVec)
% scatter(timeVec,whaleNumVec)
plot(f6,timeVec2,whaleNumVec)
title(['Zc Group Size W 01'])
ylabel('Number of Whales Per Track')
xlabel('2021 - 2022')
datetick('x','dd-mmm')

figure
bar(timeVec2,whaleNumVec,'EdgeColor',[0 0 0],'FaceColor',[0 0 0])
title(['Zc Group Size W 01'])
ylabel('Number of Whales Per Track')
xlabel('2021 - 2022')
datetick('x','dd-mmm')

%% Daily averages

% load in the data
group{1} = load('F:\Tracking\Erics_detector\SOCAL_E_63\group_size\cleanedTracksTable.mat');
% group{1,1}.cleanedTracksTable(71:77,:) = [];
% group{2} = load('F:\Erics_detector\SOCAL_W_02\group_size\cleanedTracksTable.mat');
% group{3} = load('F:\Erics_detector\SOCAL_W_03\group_size\cleanedTracksTable.mat');
% group{4} = load('F:\Erics_detector\SOCAL_W_04\group_size\cleanedTracksTable.mat');
% group{5} = load('F:\Erics_detector\SOCAL_W_05\group_size\cleanedTracksTable.mat');

% fullTable = vertcat(group{1,1}.cleanedTracksTable, ...
%     group{1,2}.cleanedTracksTable, ...
%     group{1,3}.cleanedTracksTable, ...
%     group{1,4}.cleanedTracksTable, ...
%     group{1,5}.cleanedTracksTable);

fullTable = group{1}.cleanedTracksTable;

% create a vector from the start date to end date, seq by 1 day
dateSt = table2array(fullTable(1,1)); % grab the start date
dateEd = table2array(fullTable(end,1)); % grab the end date
t = dateSt:caldays(1):dateEd; % vector from start to end, by 1 day
t = dateshift(t,'start','day'); % shift to 00:00:00
grpMeans = NaN(1,length(t)); % vector for group sizes of matching size

tableTimes = table2array(fullTable(:,1)); % grab start times
tableTimes = dateshift(tableTimes,'start','day'); % shift to 00:00:00
groupVec = table2array(fullTable(:,end)); % grab the group sizes

for i = 1:length(t)
    
    thisDate = t(i); % grab the date from t
    matchDate = dateshift(thisDate,'start','day'); % shift to 00:00:00
    dateMatchIdx = datefind(matchDate,tableTimes); % find indices of matching dates
    
    if ~isempty(dateMatchIdx) % if there is a track on this date
        grpSizeVals = groupVec(dateMatchIdx); % if more than one, average the group size values
        meanGrpSize = mean(grpSizeVals); % calculate the average
        grpMeans(i) = meanGrpSize; % put the mean at appropriate index
    else % if there is no track for this date
        grpMeans(i) = 0; % assign a zero
        
    end
end

% assign times where hydrophones weren't recording to NaN
% % for site H
% hydOff(1,1) = datetime('22-Oct-0021 00:00:00');
% hydOff(1,2) = datetime('21-Dec-0021 00:00:00');
% hydOff(2,1) = datetime('22-May-0022 00:00:00');
% hydOff(2,2) = datetime('11-Jun-0022 00:00:00');
% hydOff(3,1) = datetime('15-Oct-0022 00:00:00');
% hydOff(3,2) = datetime('16-Oct-0022 00:00:00');
% for site W
% hydOff(1,1) = datetime('16-Jan-0022 00:00:00');
% hydOff(1,2) = datetime('08-Mar-0022 00:00:00');
% hydOff(2,1) = datetime('27-May-0022 00:00:00');
% hydOff(2,2) = datetime('28-May-0022 00:00:00');
% hydOff(3,1) = datetime('15-Oct-0022 00:00:00');
% hydOff(3,2) = datetime('17-Oct-0022 00:00:00');
% hydOff(4,1) = datetime('24-Oct-0022 00:00:00');
% hydOff(4,2) = datetime('16-Apr-0023 00:00:00');

hydOff.Format = 'dd-MMM-20yy HH:mm:ss';
offDates = [hydOff(1,1):caldays(1):hydOff(1,2),hydOff(2,1):caldays(1):hydOff(2,2),hydOff(3,1):caldays(1):hydOff(3,2),hydOff(4,1):caldays(1):hydOff(4,2)];
offDatesIdx = datefind(offDates,t);

for i = 1:length(offDates)
    
   matchOffDate = datefind(offDates(i),t); % find the matching date index
   grpMeans(matchOffDate) = 10; % assign that group size to NaN
    
end

% % rug plot!
% tTable{1} = load('G:\Shared drives\Lauren Baggett MS\AI_Classification\Time_Tables\SOCAL_H_72_HE\SOCAL_H_72_HE_encounterTimes');
% tTable{2} = load('G:\Shared drives\Lauren Baggett MS\AI_Classification\Time_Tables\SOCAL_H_73_HE\SOCAL_H_73_HE_encounterTimes');
% tTable{3} = load('G:\Shared drives\Lauren Baggett MS\AI_Classification\Time_Tables\SOCAL_H_74_HE\SOCAL_H_74_HE_encounterTimes');
% fullDetTable = vertcat(tTable{1, 1}.bwEnc,tTable{1, 2}.bwEnc,tTable{1, 3}.bwEnc);
% 
% tableTimesRug = table2array(fullDetTable(:,1)); % grab start times
% tableTimesRug = dateshift(tableTimesRug,'start','day'); % shift to 00:00:00
% tableTimesRug = tableTimesRug-years(2000);
% trackRug = NaN(1,length(t));

% for i = 1:length(t)
% 
%     thisDate = t(i); % grab the date from t
%     matchDate = dateshift(thisDate,'start','day'); % shift to 00:00:00
%     dateMatchIdx = datefind(matchDate,tableTimesRug); % find indices of matching dates
% 
%     if ~isempty(dateMatchIdx) % if there is a track on this date
%         trackRug(i) = sum(length(dateMatchIdx)); % put the mean at appropriate index
%     else % if there is no track for this date
%         trackRug(i) = 0; % assign a zero
% 
%     end
% end

for i = 1:length(offDates)
    
   matchOffDate = datefind(offDates(i),t); % find the matching date index
   % trackRug(matchOffDate) = 10; % assign that group size to NaN
    
end

% % fit a spline
% k = 4 % 4 knots?
% % x = datenum(t);
noData = find(grpMeans==10);
spMeans = grpMeans;
spMeans(noData) = NaN;
nanIdx = isnan(spMeans);
% endPts = [113 173 325 345];
% spMeans1 = spMeans(1:nanIdx(1))
% % y = grpMeans;
% % sp = spapi(optknt(datenum(t),k), datenum(t), spMeans);
% splinetool(datenum(t),spMeans)

% % fit a higher order polynomial
% endPts = [112 174 324 346]; % pts beginning/end of no effort
% f6a = fit(datenum(t(1:endPts(1))'),grpMeans(1:endPts(1))','poly5');
% f6b = fit(datenum(t(endPts(2):endPts(3))'),grpMeans(endPts(2):endPts(3))','poly5');
% f6c= fit(datenum(t(endPts(4):470)'),grpMeans(endPts(4):470)','poly5');

% % plot it all!
% tiledlayout(15,6,'tilespacing','tight')
% % tiledlayout(6,6)
% nexttile([13,6]);
bar(t,grpMeans,'edgecolor','none','barwidth',1)
hold on
bar(offDates,grpMeans(offDatesIdx),'facecolor','#AFAFAF','edgecolor','none','barwidth',1)
legend('Daily Mean','No Effort')
title('Zc Group Size Site E, Daily Average')
ylabel('Daily Mean Group Size')
ylim([0 8])
% xticklabels([])
% xlabel([])
% datetick('x','mmm-20YY')
% plot(f6a,datenum(t(1:endPts(1))'),grpMeans(1:endPts(1))')
% plot(f6b,datenum(t(endPts(2):endPts(3))'),grpMeans(endPts(2):endPts(3))')
% plot(f6c,datenum(t(endPts(4):470)'),grpMeans(endPts(4):470)')

% nexttile([2,6]);
% bar(t,trackRug,'edgecolor','none','facecolor','black')
% hold on
% bar(offDates,trackRug(offDatesIdx),'facecolor','#AFAFAF','edgecolor','none','barwidth',1)
% yticks([0 10])
% xlim(['02-Jul-2021 00:00:00' '14-Oct-2022 00:00:00'])
% datetick('x','mmm-20YY')

% change the ticks back to datetime
% remove blue data points
% fix the legend

% savefig('F:\Erics_detector\group_size_site_H_daily.fig')
% save('F:\Erics_detector\group_size_site_H_daily.mat','t','grpMeans')

%% Weekly Averages

% load in the data
group{1} = load('F:\Erics_detector\SOCAL_H_72\group_size\cleanedTracksTable.mat');
group{1,1}.cleanedTracksTable(71:77,:) = [];
group{2} = load('F:\Erics_detector\SOCAL_H_73\group_size\cleanedTracksTable.mat');
group{3} = load('F:\Erics_detector\SOCAL_H_74\group_size\cleanedTracksTable.mat');

fullTable = vertcat(group{1,1}.cleanedTracksTable,group{1,2}.cleanedTracksTable,group{1,3}.cleanedTracksTable);

% create a vector from the start date to end date, seq by 1 week
dateSt = table2array(fullTable(1,1)); % grab the start date
dateEd = table2array(fullTable(end,1)); % grab the end date
t = dateSt:calweeks(1):dateEd; % vector from start to end, by 1 week
t = dateshift(t,'start','day'); % shift to 00:00:00
grpMeans = NaN(1,length(t)); % vector for group sizes of matching size

tableTimes = table2array(fullTable(:,1)); % grab start times
tableTimes = dateshift(tableTimes,'start','day'); % shift to 00:00:00
groupVec = table2array(fullTable(:,end)); % grab the group sizes

for i = 1:length(t)
    
    thisDate = t(i); % grab the date from t
    matchDate = dateshift(thisDate,'start','day'); % shift to 00:00:00
    matchDate = matchDate:caldays(1):matchDate+caldays(6); % grab the entire week
    dateMatchIdx = datefind(matchDate,tableTimes); % find indices of matching dates
    
    if ~isempty(dateMatchIdx) % if there are tracks in this week
        grpSizeVals = groupVec(dateMatchIdx); % if more than one, average the group size values
        meanGrpSize = mean(grpSizeVals); % calculate the average
        grpMeans(i) = meanGrpSize; % put the mean at appropriate index
    else % if there is no track for this week
        grpMeans(i) = 0; % assign a zero
        
    end
end

% assign times where hydrophones weren't recording to NaN
hydOff(1,1) = datetime('22-Oct-0021 00:00:00');
hydOff(1,2) = datetime('17-Dec-0021 00:00:00');
hydOff(2,1) = datetime('20-May-0022 00:00:00');
hydOff(2,2) = datetime('10-Jun-0022 00:00:00');
hydOff.Format = 'dd-MMM-20yy HH:mm:ss';
offDates = [hydOff(1,1):calweeks(1):hydOff(1,2),hydOff(2,1):calweeks(1):hydOff(2,2)];
offDatesIdx = datefind(offDates,t);

grpMeans(offDatesIdx) = 6;

% rug plot!
tTable{1} = load('G:\Shared drives\Lauren Baggett MS\AI_Classification\Time_Tables\SOCAL_H_72_HE\SOCAL_H_72_HE_encounterTimes');
tTable{2} = load('G:\Shared drives\Lauren Baggett MS\AI_Classification\Time_Tables\SOCAL_H_73_HE\SOCAL_H_73_HE_encounterTimes.mat');
tTable{3} = load('G:\Shared drives\Lauren Baggett MS\AI_Classification\Time_Tables\SOCAL_H_74_HE\SOCAL_H_74_HE_encounterTimes');
fullDetTable = vertcat(tTable{1, 1}.bwEnc,tTable{1, 2}.bwEnc,tTable{1, 3}.bwEnc);

tableTimesRug = table2array(fullDetTable(:,1)); % grab start times
tableTimesRug = dateshift(tableTimesRug,'start','day'); % shift to 00:00:00
tableTimesRug = tableTimesRug-years(2000);
trackRug = NaN(1,length(t));

for i = 1:length(t)

    thisDate = t(i); % grab the date from t
    matchDate = dateshift(thisDate,'start','day'); % shift to 00:00:00
    matchDate = matchDate:caldays(1):matchDate+caldays(6); % grab the entire week
    dateMatchIdx = datefind(matchDate,tableTimesRug); % find indices of matching dates
    
    if ~isempty(dateMatchIdx) % if there are tracks in this week
       trackRug(i) = sum(length(dateMatchIdx));
    else % if there is no track for this week
        trackRug(i) = 0; % assign a zero
        
    end
    
end

trackRug(offDatesIdx) = 25;

tiledlayout(15,6,'tilespacing','tight')
% tiledlayout(6,6)
nexttile([14,6]);
bar(t,grpMeans)
hold on
bar(offDates,grpMeans(offDatesIdx),'facecolor','#AFAFAF','edgecolor','none','barwidth',1)
legend('Weekly Mean','No Effort')
title('Zc Group Size Site H, Weekly Average')
ylabel('Mean Group Size')
xticklabels([])

nexttile([1,6]);
bar(t,trackRug,'edgecolor','none','facecolor','black')
hold on
bar(offDates,trackRug(offDatesIdx),'facecolor','#AFAFAF','edgecolor','none','barwidth',1)
yticks([0 26])

savefig('F:\Erics_detector\group_size_site_H_weekly.fig')
save('F:\Erics_detector\group_size_site_H_weekly.mat','t','grpMeans')

