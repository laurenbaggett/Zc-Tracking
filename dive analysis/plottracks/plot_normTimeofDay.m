%% script to make normalized time of day plots
% LMB 6-2-23
% use Alba's function fn_normTimeofd, modified (commented out Alba's stuff)

close all
clear all

% load in the group size data
% group{1} = load('F:\Erics_detector\SOCAL_H_72\group_size\cleanedTracksTable.mat');
% group{2} = load('F:\Erics_detector\SOCAL_H_73\group_size\cleanedTracksTable.mat');
% group{3} = load('F:\Erics_detector\SOCAL_H_74\group_size\cleanedTracksTable.mat');
% grpS = vertcat(group{1}.cleanedTracksTable.numWhales(1:70,:),group{2}.cleanedTracksTable.numWhales,group{3}.cleanedTracksTable.numWhales);
% grpDates = vertcat(group{1}.cleanedTracksTable.StNum(1:70,:),group{2}.cleanedTracksTable.StNum,group{3}.cleanedTracksTable.StNum) + datenum([2000 0 0 0 0 0]);
group = load('F:\Erics_detector\SOCAL_H_72\group_size\cleanedTracksTable.mat');
% grpS = group.cleanedTracksTable(1:70,:);
grp2 = load('F:\Erics_detector\SOCAL_H_73\group_size\cleanedTracksTable.mat');
grp3 = load('F:\Erics_detector\SOCAL_H_74\group_size\cleanedTracksTable.mat');
grp4 = load('F:\Erics_detector\SOCAL_H_75\group_size\cleanedTracksTable.mat')
grp = vertcat(group.cleanedTracksTable,grp2.cleanedTracksTable,grp3.cleanedTracksTable,grp4.cleanedTracksTable);
grpSz = table2array(grp(:,7));
grpDates = grp.StNum + datenum([2000 0 0 0 0 0]);
grpDates = datetime(grpDates,'convertfrom','datenum');
stDt = group.cleanedTracksTable.StNumstr(1);
edDt = grpDates(end);
dateT = datetime('01-Jul-2021'):caldays(1):datetime('18-Apr-2023');
dateN = datenum(dateT);

% get diel data

% site H coords (use from HW, localized position)
lat = '32.86164';
lon = '-119.14343';
dateStr = datetime(dateN,'convertfrom','datenum');
dateStr = datestr(dateStr,'yyyy-mm-dd');

sriseUTC = NaT(length(dateStr),1);
ssetUTC = NaT(length(dateStr),1);

for i=1:length(dateStr)
    
    % get the url, data
    url = (['https://api.sunrise-sunset.org/json?lat=',lat,'&lng=',lon,'&date=',dateStr(i,:)]);
    sunny = urlread(url);

    % grab sunrise time
    srise = extractBefore(sunny,'","sunset"');
    srise = extractAfter(srise,'sunrise":"');
    srise = datetime([dateStr(i,:),' ',srise],'format','yyyy-MM-dd HH:mm:ss');
    sriseUTC(i,1) = srise;

    % grab sunset time
    sset  = extractBefore(sunny,'","solar_noon');
    sset = extractAfter(sset,'sunset":"');
    sset = datetime([dateStr(i,:),' ',sset],'format','yyyy-MM-dd HH:mm:ss');
    ssetUTC(i,1) = sset;
    
    if i==length(dateStr)
        clear sunny
        clear url
        clear srise
        clear sset
    end

end

% now, calculate normalized time of day
% first need to find what sunrise/sunset the value is between
ntod = NaN(length(grpDates),1); % preallocate

for i = 1:length(grpDates)

    for m = 1:length(sriseUTC)-1
    sriseidx(m) = isbetween(grpDates(i),sriseUTC(m),sriseUTC(m+1));
    ssetidx(m) = isbetween(grpDates(i),ssetUTC(m),ssetUTC(m+1));
    end

    btwnsrise = find(sriseidx==1);
    btwnsset = find(ssetidx==1);

    if isempty(btwnsrise) | isempty(btwnsset)
        % move on to the next track
    elseif ~isempty(btwnsrise) & ~isempty(btwnsset)
        time = grpDates(i);
        sunrise = [sriseUTC(btwnsrise) sriseUTC(btwnsrise+1)];
        sunset = [ssetUTC(btwnsset) ssetUTC(btwnsset+1)];

        ntod(i) = fn_normTimeofd(time,sunrise,sunset);

    end
end

% for ticks
startDate = datenum('Jul-01-2021');
endDate = datenum('May-01-2023');
xData = linspace(startDate,endDate,8);

% large groups
big = find(grpSz>=4);
small = find(grpSz<=3);

% make the figure!
figure
scatter(ntod,datenum(grpDates),25,grpSz,'filled')
xlabel('Sunrise                             Sunset                                  Sunrise')
% colormap(flipud(parula(7)))\
c= colormap(jet(8))
% cmocean('-thermal',7)
a = colorbar;
a.Limits = [1 8];
a.TickLength = 0;
ylabel(a,'Group Size')
ylim([min(datenum(grpDates)) max(datenum(grpDates))])
% ylim([datenum(startDate) max(datenum(grpDates))])
% datetick('y','mmm-yyyy','keeplimits')
set(gca,'YDir','reverse');
% yticks(xData);
datetick('y','mmm-yyyy','keeplimits')
hold on
patch([0 1 1 0], [max(ylim) max(ylim) min(ylim) min(ylim)],[0.8 0.8 0.8],'linestyle','none')
% patch([-1 1 1 -1], [datenum('21-Dec-2021 00:00:00') datenum('21-Dec-2021 00:00:00') datenum('22-Oct-2021 00:00:00') datenum('22-Oct-2021 00:00:00')],[0.6 0.6 0.6],'linestyle','none')
% patch([-1 1 1 -1], [datenum('21-Dec-2021 00:00:00') datenum('21-Dec-2021 00:00:00') datenum('22-Oct-2021 00:00:00') datenum('22-Oct-2021 00:00:00')],[0.6 0.6 0.6],'linestyle','none')
patch([-1 1 1 -1], [datenum('21-Dec-2021 00:00:00') datenum('21-Dec-2021 00:00:00') datenum('22-Oct-2021 00:00:00') datenum('22-Oct-2021 00:00:00')],[0.4 0.4 0.4])
patch([-1 1 1 -1], [datenum('11-Jun-2022 00:00:00') datenum('11-Jun-2022 00:00:00') datenum('22-May-2022 00:00:00') datenum('22-May-2022 00:00:00')],[0.4 0.4 0.4])
patch([-1 1 1 -1], [datenum('15-Oct-2022 00:00:00') datenum('15-Oct-2022 00:00:00') datenum('16-Oct-2022 00:00:00') datenum('16-Oct-2022 00:00:00')],[0.4 0.4 0.4])
scatter(ntod(small),datenum(grpDates(small)),30,grpSz(small),'filled','MarkerEdgeColor','black')
scatter(ntod(big),datenum(grpDates(big)),30,grpSz(big),'filled','MarkerEdgeColor','black')
xticklabels([])
title('Group Size by NTOD Site H')
hold off
% title('Group Size at Normalized Time of Day')

saveas(gcf,'F:\group_size\diel\H73_normTimeofDay.jpg')

%% site W

group = load('F:\Erics_detector\SOCAL_W_01\group_size\cleanedTracksTable.mat');
grp2 = load('F:\Erics_detector\SOCAL_W_02\group_size\cleanedTracksTable.mat');
grp3 = load('F:\Erics_detector\SOCAL_W_03\group_size\cleanedTracksTable.mat');
grp4 = load('F:\Erics_detector\SOCAL_W_04\group_size\cleanedTracksTable.mat');
grp5 = load('F:\Erics_detector\SOCAL_W_05\group_size\cleanedTracksTable.mat');
grp = vertcat(group.cleanedTracksTable,grp2.cleanedTracksTable,grp3.cleanedTracksTable,grp4.cleanedTracksTable,grp5.cleanedTracksTable);
grpSz = table2array(grp(:,7));
grpDates = grp.StNum + datenum([2000 0 0 0 0 0]);
grpDates = datetime(grpDates,'convertfrom','datenum');
stDt = group.cleanedTracksTable.StNumstr(1);
edDt = grpDates(end);
dateT = datetime('05-Jul-2021'):caldays(1):datetime('23-Sep-2023');
dateN = datenum(dateT);

% get diel data

% site W coords
lat = '33.53973';
lon = '-120.25815';
dateStr = datetime(dateN,'convertfrom','datenum');
dateStr = datestr(dateStr,'yyyy-mm-dd');

sriseUTC = NaT(length(dateStr),1);
ssetUTC = NaT(length(dateStr),1);

for i=1:length(dateStr)
    
    % get the url, data
    url = (['https://api.sunrise-sunset.org/json?lat=',lat,'&lng=',lon,'&date=',dateStr(i,:)]);
    sunny = urlread(url);

    % grab sunrise time
    srise = extractBefore(sunny,'","sunset"');
    srise = extractAfter(srise,'sunrise":"');
    srise = datetime([dateStr(i,:),' ',srise],'format','yyyy-MM-dd HH:mm:ss');
    sriseUTC(i,1) = srise;

    % grab sunset time
    sset  = extractBefore(sunny,'","solar_noon');
    sset = extractAfter(sset,'sunset":"');
    sset = datetime([dateStr(i,:),' ',sset],'format','yyyy-MM-dd HH:mm:ss');
    ssetUTC(i,1) = sset;
    
    if i==length(dateStr)
        clear sunny
        clear url
        clear srise
        clear sset
    end

end

% now, calculate normalized time of day
% first need to find what sunrise/sunset the value is between
ntod = NaN(length(grpDates),1); % preallocate

for i = 1:length(grpDates)

    for m = 1:length(sriseUTC)-1
    sriseidx(m) = isbetween(grpDates(i),sriseUTC(m),sriseUTC(m+1));
    ssetidx(m) = isbetween(grpDates(i),ssetUTC(m),ssetUTC(m+1));
    end

    btwnsrise = find(sriseidx==1);
    btwnsset = find(ssetidx==1);

    if isempty(btwnsrise) | isempty(btwnsset)
        % move on to the next track
    elseif ~isempty(btwnsrise) & ~isempty(btwnsset)
        time = grpDates(i);
        sunrise = [sriseUTC(btwnsrise) sriseUTC(btwnsrise+1)];
        sunset = [ssetUTC(btwnsset) ssetUTC(btwnsset+1)];

        ntod(i) = fn_normTimeofd(time,sunrise,sunset);

    end
end

% for ticks
startDate = datenum('Jul-01-2021');
endDate = datenum('Oct-01-2023');
xData = linspace(startDate,endDate,8);

% large groups
big = find(grpSz>=4);
small = find(grpSz<=3);

% make the figure!
figure
scatter(ntod,datenum(grpDates),25,grpSz,'filled')
xlabel('Sunrise                             Sunset                                  Sunrise')
% colormap(flipud(parula(7)))\
% colormap(jet(8))
colormap(e)
% cmocean('-thermal',7)
a = colorbar;
a.Limits = [1 9];
a.TickLength = 0;
ylabel(a,'Group Size')
ylim([min(datenum(grpDates)) max(datenum(grpDates))])
% ylim([datenum(startDate) max(datenum(grpDates))])
% datetick('y','mmm-yyyy','keeplimits')
set(gca,'YDir','reverse');
% yticks(xData);
datetick('y','mmm-yyyy','keeplimits')
hold on
patch([0 1 1 0], [max(ylim) max(ylim) min(ylim) min(ylim)],[0.8 0.8 0.8],'linestyle','none')
patch([-1 1 1 -1], [datenum('16-Jan-2022 00:00:00') datenum('16-Jan-2022 00:00:00') datenum('08-Mar-2022 00:00:00') datenum('08-Mar-2022 00:00:00')],[0.4 0.4 0.4])
patch([-1 1 1 -1], [datenum('27-May-2022 00:00:00') datenum('27-May-2022 00:00:00') datenum('28-May-2022 00:00:00') datenum('28-May-2022 00:00:00')],[0.4 0.4 0.4])
patch([-1 1 1 -1], [datenum('15-Oct-2022 00:00:00') datenum('15-Oct-2022 00:00:00') datenum('17-Oct-2022 00:00:00') datenum('17-Oct-2022 00:00:00')],[0.4 0.4 0.4])
patch([-1 1 1 -1], [datenum('24-Oct-2022 00:00:00') datenum('24-Oct-2022 00:00:00') datenum('16-Apr-2023 00:00:00') datenum('16-Apr-2023 00:00:00')],[0.4 0.4 0.4])
scatter(ntod(small),datenum(grpDates(small)),30,grpSz(small),'filled','MarkerEdgeColor','black')
scatter(ntod(big),datenum(grpDates(big)),30,grpSz(big),'filled','MarkerEdgeColor','black')
xticklabels([])
title('Group Size by NTOD Site W')
hold off


%% site N

group = load('F:\Erics_detector\SOCAL_N_68\Zc\group_size\cleanedTracksTable.mat');
grp = group.cleanedTracksTable;
grpSz = table2array(grp(:,7));
grpDates = grp.StNum + datenum([2000 0 0 0 0 0]);
grpDates = datetime(grpDates,'convertfrom','datenum');
stDt = group.cleanedTracksTable.StNumstr(1);
edDt = grpDates(end);
dateT = datetime('31-May-2020'):caldays(1):datetime('12-Oct-2020');
dateN = datenum(dateT);

% get diel data

% site W coords
lat = '32.36975';
lon = '-118.56458';
dateStr = datetime(dateN,'convertfrom','datenum');
dateStr = datestr(dateStr,'yyyy-mm-dd');

sriseUTC = NaT(length(dateStr),1);
ssetUTC = NaT(length(dateStr),1);

for i=1:length(dateStr)
    
    % get the url, data
    url = (['https://api.sunrise-sunset.org/json?lat=',lat,'&lng=',lon,'&date=',dateStr(i,:)]);
    sunny = urlread(url);

    % grab sunrise time
    srise = extractBefore(sunny,'","sunset"');
    srise = extractAfter(srise,'sunrise":"');
    srise = datetime([dateStr(i,:),' ',srise],'format','yyyy-MM-dd HH:mm:ss');
    sriseUTC(i,1) = srise;

    % grab sunset time
    sset  = extractBefore(sunny,'","solar_noon');
    sset = extractAfter(sset,'sunset":"');
    sset = datetime([dateStr(i,:),' ',sset],'format','yyyy-MM-dd HH:mm:ss');
    ssetUTC(i,1) = sset;
    
    if i==length(dateStr)
        clear sunny
        clear url
        clear srise
        clear sset
    end

end

% now, calculate normalized time of day
% first need to find what sunrise/sunset the value is between
ntod = NaN(length(grpDates),1); % preallocate

for i = 1:length(grpDates)

    for m = 1:length(sriseUTC)-1
    sriseidx(m) = isbetween(grpDates(i),sriseUTC(m),sriseUTC(m+1));
    ssetidx(m) = isbetween(grpDates(i),ssetUTC(m),ssetUTC(m+1));
    end

    btwnsrise = find(sriseidx==1);
    btwnsset = find(ssetidx==1);

    if isempty(btwnsrise) | isempty(btwnsset)
        % move on to the next track
    elseif ~isempty(btwnsrise) & ~isempty(btwnsset)
        time = grpDates(i);
        sunrise = [sriseUTC(btwnsrise) sriseUTC(btwnsrise+1)];
        sunset = [ssetUTC(btwnsset) ssetUTC(btwnsset+1)];

        ntod(i) = fn_normTimeofd(time,sunrise,sunset);

    end
end

% for ticks
startDate = datenum('Jun-01-2020');
endDate = datenum('Nov-01-2020');
xData = linspace(startDate,endDate,8);

% large groups
big = find(grpSz>=4);
small = find(grpSz<=3);

% get the colormap sorted
e = colormap(jet(8));
e = e(1:4,:);

% make the figure!
figure
scatter(ntod,datenum(grpDates),25,grpSz,'filled')
xlabel('Sunrise                             Sunset                                  Sunrise')
% colormap(flipud(parula(7)))\
colormap(e)
% cmocean('-thermal',7)
a = colorbar;
a.Limits = [1 4];
a.TickLength = 0;
ylabel(a,'Group Size')
ylim([min(datenum(grpDates)) max(datenum(grpDates))])
% ylim([datenum(startDate) max(datenum(grpDates))])
% datetick('y','mmm-yyyy','keeplimits')
set(gca,'YDir','reverse');
% yticks(xData);
datetick('y','mmm-yyyy','keeplimits')
hold on
patch([0 1 1 0], [max(ylim) max(ylim) min(ylim) min(ylim)],[0.8 0.8 0.8],'linestyle','none')
patch([-1 1 1 -1], [datenum('16-Jan-2022 00:00:00') datenum('16-Jan-2022 00:00:00') datenum('08-Mar-2022 00:00:00') datenum('08-Mar-2022 00:00:00')],[0.4 0.4 0.4])
patch([-1 1 1 -1], [datenum('27-May-2022 00:00:00') datenum('27-May-2022 00:00:00') datenum('28-May-2022 00:00:00') datenum('28-May-2022 00:00:00')],[0.4 0.4 0.4])
patch([-1 1 1 -1], [datenum('15-Oct-2022 00:00:00') datenum('15-Oct-2022 00:00:00') datenum('17-Oct-2022 00:00:00') datenum('17-Oct-2022 00:00:00')],[0.4 0.4 0.4])
patch([-1 1 1 -1], [datenum('24-Oct-2022 00:00:00') datenum('24-Oct-2022 00:00:00') datenum('16-Apr-2023 00:00:00') datenum('16-Apr-2023 00:00:00')],[0.4 0.4 0.4])
scatter(ntod(small),datenum(grpDates(small)),30,grpSz(small),'filled','MarkerEdgeColor','black')
scatter(ntod(big),datenum(grpDates(big)),30,grpSz(big),'filled','MarkerEdgeColor','black')
xticklabels([])
title('Group Size by NTOD Site N')


%% make bar plot showing distribution

dayIdx = find(ntod<0);
nightIdx = find(ntod>0);

% for results sections
large = find(grp.numWhales>=4);
mnths = month(grp.StNum(large));
yrs = year(grp.StNum(large));

% find number of each group size during day
grpDay = grpSz(dayIdx);
grpD = [length(find(grpDay==1)),length(find(grpDay==2)),length(find(grpDay==3)),length(find(grpDay==4)),length(find(grpDay==5)),length(find(grpDay==6)),length(find(grpDay==7))];

% find number of each group size during night
grpNight = grpSz(nightIdx);
grpN = [length(find(grpNight==1)),length(find(grpNight==2)),length(find(grpNight==3)),length(find(grpNight==4)),length(find(grpNight==5)),length(find(grpNight==6)),length(find(grpNight==7))];

grpDiel = vertcat(grpD,grpN);

figure
c = colormap(jet(7))
patch([1.5 3 3 1.5], [0 0 150 150],[0.8 0.8 0.8],'edgecolor','none')
hold on
b = bar(grpDiel,'stacked','facecolor','flat');
b(1).CData = c(1,:);
b(2).CData = c(2,:);
b(3).CData = c(3,:);
b(4).CData = c(4,:);
b(5).CData = c(5,:);
b(6).CData = c(6,:);
b(7).CData = c(7,:);
xticks([])
xlabel("Day                                               Night")
xlim([0.5 2.5])
patch([1.5 3 3 1.5], [0 0 150 150],[0.8 0.8 0.8],'edgecolor','none')
bar(grpDiel,'stacked','facecolor','flat');




%% norm time of day, dive class

close all
clear all

% find the times of each track
df = dir('F:\Erics_detector\SOCAL_H_74\cleaned_tracks\track*');
dtafrm = nan(length(df),10);

for i = 1:length(df)
    
   myFile = dir([df(i).folder,'\',df(i).name,'\*brushDOA.mat']); % load the folder name
   trackNum = extractAfter(myFile.folder,'cleaned_tracks\track'); % grab the track num for naming later
   trackNum = str2num(trackNum);
   trackDate = extractAfter(myFile.name,'track');
   trackDate = extractAfter(trackDate,'_');
   trackDate = extractBefore(trackDate,'_detections');
   trackDate = str2num(erase(trackDate,'_'));
   dtafrm(i,1) = trackNum;
   dtafrm(i,2) = trackDate;
   load(fullfile([myFile.folder,'\z_stats'])); % load the file 
   
   [r,c] = size(z_stats);
   for wn = 1:c
      dtafrm(i,wn+2) = z_stats(6,wn); 
   end 
end

% convert the dates to the correct format
dt = num2str(dtafrm(:,2));
ndt = char();
for i = 1:length(dt)
n = insertAfter(dt(i,:),2,'-');
n = insertAfter(n,5,'-');
n = insertAfter(n,8,' ');
n = insertAfter(n,11,':');
n = insertAfter(n,14,':');
ndt(i,:) = n;
end
ndt = datenum(ndt)+ datenum([2000 0 0 0 0 0]);
ndt = datetime(ndt,'convertfrom','datenum');

% get diel data
% site H 72 coords (use from HW, localized position)
lat = '32.86030';
lon = '-119.13785';
dateStr = [datetime('2022-06-11'):days(1):datetime('2022-10-14')];
dateStr = datestr(dateStr,'yyyy-mm-dd');

sriseUTC = NaT(length(dateStr),1);
ssetUTC = NaT(length(dateStr),1);

for i=1:length(dateStr)
    
    % get the url, data
    url = (['https://api.sunrise-sunset.org/json?lat=',lat,'&lng=',lon,'&date=',dateStr(i,:)]);
    sunny = urlread(url);

    % grab sunrise time
    srise = extractBefore(sunny,'","sunset"');
    srise = extractAfter(srise,'sunrise":"');
    srise = datetime([dateStr(i,:),' ',srise],'format','yyyy-MM-dd HH:mm:ss');
    sriseUTC(i,1) = srise;

    % grab sunset time
    sset  = extractBefore(sunny,'","solar_noon');
    sset = extractAfter(sset,'sunset":"');
    sset = datetime([dateStr(i,:),' ',sset],'format','yyyy-MM-dd HH:mm:ss');
    ssetUTC(i,1) = sset;
    
    if i==length(dateStr)
        clear sunny
        clear url
        clear srise
        clear sset
    end

end

% now, calculate normalized time of day
% first need to find what sunrise/sunset the value is between
ntod = NaN(length(dtafrm),1); % preallocate

for i = 1:length(dtafrm)

    for m = 1:length(sriseUTC)-1
    sriseidx(m) = isbetween(ndt(i),sriseUTC(m),sriseUTC(m+1));
    ssetidx(m) = isbetween(ndt(i),ssetUTC(m),ssetUTC(m+1));
    end

    btwnsrise = find(sriseidx==1);
    btwnsset = find(ssetidx==1);

    if isempty(btwnsrise) | isempty(btwnsset)
        % move on to the next track
    elseif ~isempty(btwnsrise) & ~isempty(btwnsset)
        time = ndt(i);
        sunrise = [sriseUTC(btwnsrise) sriseUTC(btwnsrise+1)];
        sunset = [ssetUTC(btwnsset) ssetUTC(btwnsset+1)];

        ntod(i) = fn_normTimeofd(time,sunrise,sunset);

    end
end

% create vectors for greying out background
grayX = ntod;
grayY = repelem(between(min(ndt), max(ndt)),length(ntod));

% grab the dive class data, average it
dc = dtafrm(:,3:end);
d = [];
i=1;
for i = 1:length(dc)
    nums = ~isnan(dc(i,:));
    vec = dc(i,nums);
    vec = mean(vec);
    d(i,1) = vec
end

% make the figure!
ndt = datenum(ndt);
figure
scatter(ntod,ndt,20,d,'filled')
set(gca,'YDir','reverse')

xlabel('Sunrise                             Sunset                                  Sunrise')
colormap(flipud(parula(6)))
a = colorbar;
a.TickLength = 0;
ylabel(a,'Avg Dive Class Per Enc')
% datetick('y','mmm-yyyy')
ylim([min(ndt) max(ndt)]);
set(gca,'YDir','reverse')
ylims = [max(ndt) min(ndt)];
datetick('y','mmm-yyyy','keeplimits')
hold on
% patch([0 1 1 0], [min(ylim) max(ylim) max(ylim) min(ylim)],[0.8 0.8 0.8],'gray')
patch([0 0 1 1], [ylims(1) ylims(2) ylims(2) ylims(1)],[0.8 0.8 0.8],'linestyle','none')
% patch([0 1 1 0], [ylim(1) ylim(2) ylim(2) ylim(1)],[0 0 0],'linestyle','none')
scatter(ntod,ndt,50,d,'filled','MarkerEdgeColor','black')
hold off
title('H 74 Dive Class at Normalized Time of Day')

saveas(gcf,'F:\Erics_detector\SOCAL_H_74\H74_diveClass_normTimeofDay.jpg')

