%% figures_for_thesis.m

% here is where I will make the figures for my thesis!

clear all
close all

%% map of site H
load('F:\bathymetry\socal_new.mat');
v = [0,0];
l = 0:10:max(Z,[],'all');
H = [32.86117  -119.13516 -1282.5282];

% define the colormap
a = m_colmap('blues');
a = vertcat(a,[0.8020    0.8020    0.8020]);

figure
contourf(X,Y,Z,50,'edgecolor','none')
colormap(a)
caxis([-4500 0])
hold on
contourf(X,Y,Z,v,'k')
% c = colorbar
% ylabel(c,'Depth (m)')
scatter(H(2),H(1),150,'o','filled','red')
yticks([32 33 34 35])
yticklabels({'32캮', '33캮','34캮','35캮'})
ytickangle(90)
xticks([-120, -119, -118])
xticklabels({'120캷','119캷','118캷'})
% legend(b,{'SOCAL H'})
% add a point for landmarks
scatter(-118.2437,34.0722,20,'o','filled','black')
scatter(-119.6982,34.5208,20,'o','filled','black')
% text(-118.2437,34.0722,'Los Angeles','HorizontalAlignment','right','fontsize',12,'fontweight','bold')
% text(-118.4981,32.9029,'San Clemente','HorizontalAlignment','center','fontsize',8,'fontweight','bold','FontName','Georgia')
% text(-119.4992,33.2465,'San Nicholas','HorizontalAlignment','center','fontsize',8,'fontweight','bold','FontName','Georgia')
% text(-118.4163,33.3879,'Catalina','HorizontalAlignment','center','fontsize',8,'fontweight','bold','FontName','Georgia')
% text(-119.7658,34.0232,'Santa Cruz','HorizontalAlignment','center','fontsize',8,'fontweight','bold','FontName','Georgia')
% text(-120.0896,33.9773,'Santa Rosa','HorizontalAlignment','center','fontsize',8,'fontweight','bold','FontName','Georgia')
% text(-120.3724,34.0376,'San Miguel','HorizontalAlignment','center','fontsize',7)
% text(-119.6982,34.5208,'Santa Barbara','HorizontalAlignment','right','fontsize',12,'fontweight','bold')
% this works for now, next time try m_colmap('blues')
% sent the link to self over slack!

%% first, make maps of each deployment per site

% load receiver positions
load('F:\bathymetry\W01.mat');
% % H 72
% load('F:\Instrument_Orientation\SOCAL__H_72\SOCAL_H_72_HS\dep\SOCAL_H_72_HS_harp4chPar');
% hydLoc1{1} = recLoc;
% clear recLoc
% load('F:\Instrument_Orientation\SOCAL__H_72\SOCAL_H_72_HW\dep\SOCAL_H_72_HW_harp4chParams');
% hydLoc1{2} = recLoc;
% clear recLoc
hydLoc1{1} = [33.53748  -120.24918 -1251.6757];
hydLoc1{2} = [33.53236  -120.25423 -1249.5326];
hydLoc1{3} = [33.53973  -120.25815 -1377.8741];
% clear recLoc
% H 73
% load('F:\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HS\dep\SOCAL_H_73_HS_harp4chParams');
% hydLoc2{1} = recLoc;
% clear recLoc
% load('F:\Instrument_Orientation\SOCAL_H_73\SOCAL_H_73_HW\dep\SOCAL_H_73_harp4chParams');
% hydLoc2{2} = recLoc;
% clear recLoc
hydLoc2{1} = [33.53701  -120.24759 -1237.368];
hydLoc2{2} = [33.53831  -120.24518 -1428.6858];
hydLoc2{3} = [33.54057  -120.25866 -1370.4091];
% clear recLoc
% % H 74
% load('F:\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HS\rec\SOCAL_H_74_HS_harp4chParams');
% hydLoc3{1} = recLoc;
% clear recLoc
% load('F:\Instrument_Orientation\SOCAL_H_74\SOCAL_H_74_HW\rec\SOCAL_H_74_HW_harp4chParams');
% hydLoc3{2} = recLoc;
% clear recLoc
hydLoc3{1} = [33.53749  -120.24758 -1242.3095];
hydLoc3{2} = [33.53210  -120.25209 -1244.6753];
hydLoc3{3} = [33.54117  -120.25922 -1383.9635];
% H 75
% load('F:\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HS\rec\SOCAL_H_75_HS_harp4chPar');
% hydLoc4{1} = recLoc;
% clear recLoc
% load('F:\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HW\rec\SOCAL_H_75_HW_harp4chParams');
% hydLoc4{2} = recLoc;
% clear recLoc
% hydLoc4{3} = [32.86216  -119.13519  1284.5215];
% % W 05
% load('F:\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HS\rec\SOCAL_H_75_HS_harp4chPar');
% hydLoc4{1} = recLoc;
% clear recLoc
% load('F:\Instrument_Orientation\SOCAL_H_75\SOCAL_H_75_HW\rec\SOCAL_H_75_HW_harp4chParams');
% hydLoc4{2} = recLoc;
% clear recLoc
hydLoc4{1} = [33.53801  -120.25014 -1272.1879];
hydLoc4{2} = [33.53277  -120.25518 -1259.4659];
hydLoc4{3} = [33.54079  -120.25996 -1387.6076];

hydLoc5{1} = [33.53949  -120.25116 -1314.6391];
hydLoc5{2} = [33.53472  -120.25518 -1322.6153];
hydLoc5{3} = [33.54196  -120.25820 -1510.562];


figure
contour(X,Y,Z,15,'black','showtext','on','labelformat','%0.01f m')
yticks([])
yticklabels([])
xticks([])
xticklabels([])
% yticks([32.856 32.858 32.860 32.862 32.864])
% yticklabels({'32.856째N', '32.857째N','32.858째N','32.859째N','32.860째N','32.861째N','32.862째N','32.863째N','32.864째N','32.865째N'})
% yticklabels({'32.856째N','32.858째N','32.860째N','32.862째N','32.864째N'})
% xticks([-119.144 -119.140 -119.136 -119.132])
% xticklabels({'119.144째W','119.140째W','119.136째W','119.132째W'})
%xticklabels({'119.144째W', '119.142째W','119.140째W','119.138째W','119.136째W','119.136째W','119.134째W','119.132째W'})
hold on
h(1) = plot(hydLoc1{1,1}(2),hydLoc1{1,1}(1),'s','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',10,'DisplayName','W01');
h(2) = plot(hydLoc1{1,2}(2),hydLoc1{1,2}(1),'s','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',10,'DisplayName','W01');
h(3) = plot(hydLoc1{1,3}(2),hydLoc1{1,3}(1),'o','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',10,'DisplayName','W01');
plot([hydLoc1{1,1}(2) hydLoc1{1,2}(2)], [hydLoc1{1,1}(1) hydLoc1{1,2}(1)],'--','color','#FF1F5B')
plot([hydLoc1{1,2}(2) hydLoc1{1,3}(2)], [hydLoc1{1,2}(1) hydLoc1{1,3}(1)],'--','color','#FF1F5B')
plot([hydLoc1{1,1}(2) hydLoc1{1,3}(2)], [hydLoc1{1,1}(1) hydLoc1{1,3}(1)],'--','color','#FF1F5B')
h(4) = plot(hydLoc2{1,1}(2),hydLoc2{1,1}(1),'s','markeredgecolor','black','markerfacecolor','#00CD6C','markersize',10,'DisplayName','W02');
h(5) = plot(hydLoc2{1,2}(2),hydLoc2{1,2}(1),'s','markeredgecolor','black','markerfacecolor','#00CD6C','markersize',10,'DisplayName','W02');
h(6) = plot(hydLoc2{1,3}(2),hydLoc2{1,3}(1),'o','markeredgecolor','black','markerfacecolor','#00CD6C','markersize',10,'DisplayName','W02');
plot([hydLoc2{1,1}(2) hydLoc2{1,2}(2)], [hydLoc2{1,1}(1) hydLoc2{1,2}(1)],'--','color','#00CD6C')
plot([hydLoc2{1,2}(2) hydLoc2{1,3}(2)], [hydLoc2{1,2}(1) hydLoc2{1,3}(1)],'--','color','#00CD6C')
plot([hydLoc2{1,1}(2) hydLoc2{1,3}(2)], [hydLoc2{1,1}(1) hydLoc2{1,3}(1)],'--','color','#00CD6C')
h(7) = plot(hydLoc3{1,1}(2),hydLoc3{1,1}(1),'s','markeredgecolor','black','markerfacecolor','#009ADE','markersize',10,'DisplayName','W03');
h(8) = plot(hydLoc3{1,2}(2),hydLoc3{1,2}(1),'s','markeredgecolor','black','markerfacecolor','#009ADE','markersize',10,'DisplayName','W03');
h(9) = plot(hydLoc3{1,3}(2),hydLoc3{1,3}(1),'o','markeredgecolor','black','markerfacecolor','#009ADE','markersize',10,'DisplayName','W03');
plot([hydLoc3{1,1}(2) hydLoc3{1,2}(2)], [hydLoc3{1,1}(1) hydLoc3{1,2}(1)],'--','color','#009ADE')
plot([hydLoc3{1,2}(2) hydLoc3{1,3}(2)], [hydLoc3{1,2}(1) hydLoc3{1,3}(1)],'--','color','#009ADE')
plot([hydLoc3{1,1}(2) hydLoc3{1,3}(2)], [hydLoc3{1,1}(1) hydLoc3{1,3}(1)],'--','color','#009ADE')
h(10) = plot(hydLoc4{1,1}(2),hydLoc4{1,1}(1),'s','markeredgecolor','black','markerfacecolor','#C77CFF','markersize',10,'DisplayName','W04');
h(11) = plot(hydLoc4{1,2}(2),hydLoc4{1,2}(1),'s','markeredgecolor','black','markerfacecolor','#C77CFF','markersize',10,'DisplayName','W04');
h(12) = plot(hydLoc4{1,3}(2),hydLoc4{1,3}(1),'o','markeredgecolor','black','markerfacecolor','#C77CFF','markersize',10,'DisplayName','W04');
plot([hydLoc4{1,1}(2) hydLoc4{1,2}(2)], [hydLoc4{1,1}(1) hydLoc4{1,2}(1)],'--','color','#C77CFF')
plot([hydLoc4{1,2}(2) hydLoc4{1,3}(2)], [hydLoc4{1,2}(1) hydLoc4{1,3}(1)],'--','color','#C77CFF')
plot([hydLoc4{1,1}(2) hydLoc4{1,3}(2)], [hydLoc4{1,1}(1) hydLoc4{1,3}(1)],'--','color','#C77CFF')
h(13) = plot(hydLoc5{1,1}(2),hydLoc5{1,1}(1),'s','markeredgecolor','black','markerfacecolor','#EC5800','markersize',10,'DisplayName','W05');
h(14) = plot(hydLoc5{1,2}(2),hydLoc5{1,2}(1),'s','markeredgecolor','black','markerfacecolor','#EC5800','markersize',10,'DisplayName','W05');
h(15) = plot(hydLoc5{1,3}(2),hydLoc5{1,3}(1),'o','markeredgecolor','black','markerfacecolor','#EC5800','markersize',10,'DisplayName','W05');
plot([hydLoc5{1,1}(2) hydLoc5{1,2}(2)], [hydLoc5{1,1}(1) hydLoc5{1,2}(1)],'--','color','#EC5800')
plot([hydLoc5{1,2}(2) hydLoc5{1,3}(2)], [hydLoc5{1,2}(1) hydLoc5{1,3}(1)],'--','color','#EC5800')
plot([hydLoc5{1,1}(2) hydLoc5{1,3}(2)], [hydLoc5{1,1}(1) hydLoc5{1,3}(1)],'--','color','#EC5800')
h(16) = plot(NaN,NaN,'-','color','#FF1F5B','linewidth',8,'displayname','W01');
h(17) = plot(NaN,NaN,'-','color','#00CD6C','linewidth',8,'displayname','W02');
h(18) = plot(NaN,NaN,'-','color','#009ADE','linewidth',8,'displayname','W03');
h(19) = plot(NaN,NaN,'-','color','#C77CFF','linewidth',8,'displayname','W04');
h(20) = plot(NaN,NaN,'-','color','#EC5800','linewidth',8,'displayname','W05');
h(21) = plot(NaN,NaN,'s','markeredgecolor','black','markerfacecolor','white','markersize',12,'displayname','4-Channel');
h(22) = plot(NaN,NaN,'o','markeredgecolor','black','markerfacecolor','white','markersize',8,'displayname','1-Channel');
legend(h(16:22))


%% tracks time series

% create a plot, for each site, of tracks over time. split bar
% graph--assign color to dive classification, make the cleaned tracks a
% brighter color somehow so they stand out

% grab the cleaned tracks, the dolphin tracks, and short tracks
clean = dir('F:\Erics_detector\SOCAL_H_74\cleaned_tracks');
de = dir('F:\Erics_detector\SOCAL_H_74\dolphin_tracks');
sh = dir('F:\Erics_detector\SOCAL_H_74\short_detections');

tbl1 = [];
trackTime1 = datetime(zeros(length(clean)-3,1),0,0);
for i = 3:length(clean) % for the clean tracks
    
    myFile = dir([clean(i).folder,'\',clean(i).name,'\*brushDOA.mat']); % load the folder name
    trackDate = extractAfter(myFile.name,'_');
    trackDate = extractBefore(trackDate,'_');
    trackDate = str2num(trackDate);
    trackDateTime = extractAfter(myFile.name,'track');
    trackDateTime = extractAfter(trackDateTime,'_');
    trackDateTime = extractBefore(trackDateTime,'_detections');
    trackDateTime = replace(trackDateTime,'_',' ');
    trackDateTime = datetime(trackDateTime,'inputformat','yyMMdd HHmmss');

    % trackDateTime = str2num(trackDateTime);
    
    % trackDate = datetime(trackDate,'InputFormat','yyMMdd');
    
    tbl1(i-2,1) = trackDate;
    tbl1(i-2,2) = 1; % classification for a clean track
    trackTime1(i-2,1) = trackDateTime;
    
end
tbl2 = [];
trackTime2 = datetime(zeros(length(de)-3,1),0,0);
i = 3;
for i = 3:length(de) % for the dolphin tracks
    
    myFile = dir([de(i).folder,'\',de(i).name]); % load the folder name
    trackDate = extractAfter(myFile.name,'detections_track');
    trackDate = extractAfter(trackDate,'_');
    trackDate = extractBefore(trackDate,'_');
    trackDate = str2num(trackDate);
    trackDateTime = extractAfter(myFile.name,'track');
    trackDateTime = extractAfter(trackDateTime,'_');
    trackDateTime = extractBefore(trackDateTime,'.mat');
    trackDateTime = replace(trackDateTime,'_',' ');
    trackDateTime = datetime(trackDateTime,'inputformat','yyMMdd HHmmss');

    % trackDate = datetime(trackDate,'InputFormat','yyMMdd');
    
    tbl2(i-2,1) = trackDate;
    trackTime2(i-2,1) = trackDateTime;
    tbl2(i-2,2) = 2; % classification for dolphin tracks
    
end
tbl3 = [];
trackTime3 = datetime(zeros(length(sh)-3,1),0,0);
i = 3;
for i = 3:length(sh) % for the short tracks
    
    myFile = dir([sh(i).folder,'\',sh(i).name]); % load the folder name
    trackDate = extractAfter(myFile.name,'detections_track');
    trackDate = extractAfter(trackDate,'_');
    trackDate = extractBefore(trackDate,'_');
    trackDate = str2num(trackDate);
    trackDateTime = extractAfter(myFile.name,'track');
    trackDateTime = extractAfter(trackDateTime,'_');
    trackDateTime = extractBefore(trackDateTime,'.mat');
    trackDateTime = replace(trackDateTime,'_',' ');
    trackDateTime = datetime(trackDateTime,'inputformat','yyMMdd HHmmss');

    % trackDate = datetime(trackDate,'InputFormat','yyMMdd');
    
    tbl3(i-2,1) = trackDate;
    trackTime3(i-2,1) = trackDateTime;
    tbl3(i-2,2) = 3; % classification for short tracks
    
end

% myTbl = []; % only run this on the first iteration
myTbl = vertcat(myTbl,tbl1,tbl2,tbl3);

% totalTms = [];
% totalTms = [];
totalTms = vertcat(totalTms,trackTime1,trackTime2,trackTime3);

%% sort by date
myTblSorted = sortrows(myTbl,1);
% myTblSorted = myTblSorted(19:end,:);

dateMin = datetime(num2str(min(myTblSorted(:,1))),'inputformat','yyMMdd');
dateMax = datetime(num2str(max(myTblSorted(:,1))),'inputformat','yyMMdd');
dateVec = [dateMin-days(1):days(1):dateMax+days(1)]';

cleanT = myTblSorted(find(myTblSorted(:,3)==1),:);
deT = myTblSorted(find(myTblSorted(:,3)==2),:);
shT = myTblSorted(find(myTblSorted(:,3)==3),:);
matchDatesTbl = [];
i=1;
for i = 1:length(dateVec)
   
    dateMatch = find(cleanT(:,1)==dateVec(i));
    matchDatesTbl(i,1) = length(dateMatch); % column one is clean detections
    dateMatch = find(deT(:,1)==dateVec(i));
    matchDatesTbl(i,2) = length(dateMatch); % column two is dolphin detections
    dateMatch = find(shT(:,1)==dateVec(i));
    matchDatesTbl(i,3) = length(dateMatch); % column three is short detections
    
end

dateVec = datetime(num2str(dateVec),'inputformat','yyMMdd');
dateVec = datenum(dateVec);

hydOff(1,1) = datetime('22-Oct-2021');
hydOff(1,2) = datetime('21-Dec-2021');
hydOff(2,1) = datetime('22-May-2022');
hydOff(2,2) = datetime('11-Jun-2022');
hydOffNum(:,:) = datenum(hydOff(:,:))

figure
bh = bar(dateVec,matchDatesTbl,1,'stacked','facecolor','flat','edgecolor',[1 1 1]);
bh(1).CData = [0.8510    0.3255    0.0980];
bh(2).CData = [0.9098    0.7529    0.3804];
bh(3).CData = [0.5059    0.7333    0.8314];
ylabel('Number of Tracks Per Day');
% add a polygon to show off effort times
patch([hydOffNum(1,1) hydOffNum(1,1) hydOffNum(1,2) hydOffNum(1,2)], [0 6 6 0], [0.7 0.7 0.7],'edgecolor','none'); % between H72 and H73
patch([hydOffNum(2,1) hydOffNum(2,1) hydOffNum(2,2) hydOffNum(2,2)], [0 6 6 0], [0.7 0.7 0.7],'edgecolor','none'); % between H73 and H74
legend({'Clean Detections','De Detections','Short Detections'})
datetick('x','mmm-yyyy','keeplimits')


%% normalized time of day for clean tracks
% site H coords (use from HW, localized position)
lat = '32.86164';
lon = '-119.14343';
dateStr = datestr(dateVec,'yyyy-mm-dd');

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

totalTms = sort(totalTms);
% totalTms = totalTms(76:end,1);
totalTms = datetime(totalTms,'format','dd-MMM-yyyy HH:mm:ss');

for i = 1:length(totalTms)

    for m = 1:length(sriseUTC)-1
    sriseidx(m) = isbetween(totalTms(i),sriseUTC(m),sriseUTC(m+1));
    ssetidx(m) = isbetween(totalTms(i),ssetUTC(m),ssetUTC(m+1));
    end

    btwnsrise = find(sriseidx==1);
    btwnsset = find(ssetidx==1);

    if isempty(btwnsrise) | isempty(btwnsset)
        % move on to the next track
    elseif ~isempty(btwnsrise) & ~isempty(btwnsset)
        time = totalTms(i);
        sunrise = [sriseUTC(btwnsrise) sriseUTC(btwnsrise+1)];
        sunset = [ssetUTC(btwnsset) ssetUTC(btwnsset+1)];

        ntod(i) = fn_normTimeofd(time,sunrise,sunset);

    end
end

colors(1,:) = [0.8510    0.3255    0.0980];
colors(2,:) = [0.9098    0.7529    0.3804];
colors(3,:) = [0.5059    0.7333    0.8314];

% make the figure!
figure
scatter(ntod,datenum(totalTms),20,myTblSorted(:,2),'filled')
xlabel('Sunrise                             Sunset                                  Sunrise')
colormap(colors)
a = colorbar;
a.Limits = [1 3];
a.TickLength = 0;
ylabel(a,'Clean Tracks                                 De Tracks                                  Short Tracks')
set(a,'YTick',[])
ylim([min(datenum(totalTms)) max(datenum(totalTms))])
datetick('y','mmm-dd-yyyy','keeplimits')
set(gca,'YDir','reverse')
hold on
patch([0 0 1 1], [min(datenum(totalTms)) max(datenum(totalTms)) max(datenum(totalTms)) min(datenum(totalTms))],[0.8 0.8 0.8],'edgecolor','none')
patch([-1 1 1 -1], [hydOffNum(1,1) hydOffNum(1,1) hydOffNum(1,2) hydOffNum(1,2)], [0.7 0.7 0.7],'edgecolor','none'); % between H72 and H73
patch([-1 1 1 -1],[hydOffNum(2,1) hydOffNum(2,1) hydOffNum(2,2) hydOffNum(2,2)], [0.7 0.7 0.7],'edgecolor','none'); % between H73 and H74
scatter(ntod,datenum(totalTms),40,myTblSorted(:,2),'filled','MarkerEdgeColor','black')
hold off
title('Site H Tracks at Normalized Time of Day')

