%% plot examples of each type of dive

% type 1: H73 track 132
% type 2: H74 track 182
% type 3: H72 track 270

% make sure to constrain so that axes are same!

% plot depth vs time

% plot XY

% load bathymetry
load('F:\bathymetry\siteHgridMedium.mat');
% load receiver positions
load('F:\Instrument_Orientation\SOCAL_H_73_HS\dep\SOCAL_H_73_HS_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Instrument_Orientation\SOCAL_H_73_HW\dep\SOCAL_H_73_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
% load whale struct
load('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track132\track132_loc3D_DOA_whale.mat')
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params';
global brushing
loadParams(paramFile)

% convert lat lon to meters, from Eric
plotAx = [-500, 500, -500, 500];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

% plot the smoothed
figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
hold on
plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',[0 0.4470 0.7410],'linewidth',3)
            patch([whale{wn}.CIy(:,1) fliplr(whale{wn}.CIy(:,2))], [whale{wn}.CIx(:,1) fliplr(whale{wn}.CIx(:,2))],[0 0.4470 0.7410],'edgecolor','none','facealpha',0.3)
        end
end

%% plot depth over time
figure
plot(whale{1,1}.TDet,whale{1,1}.wlocSmooth(:,3),'color',[0 0.4470 0.7410],'linewidth',3)
patch([whale{wn,1}.TDet fliplr(whale{wn,1}.TDet)],[whale{wn}.CIz(:,1) fliplr(whale{wn}.CIz(:,2))],[0 0.4470 0.7410],'edgecolor','none','facealpha',0.3)
datetick('x')
hold off
ylabel('Depth (m)')
xlabel('Time (HH:mm)')


%% %%%% for type 2

% plot XY

% load bathymetry
load('F:\bathymetry\siteHgridMedium.mat');
% load receiver positions
load('F:\Instrument_Orientation\SOCAL_H_74_HS\rec\SOCAL_H_74_HS_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Instrument_Orientation\SOCAL_H_74_HW\rec\SOCAL_H_74_HW_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
% load whale struct
load('F:\Erics_detector\SOCAL_H_74\cleaned_tracks\track182\track182_loc3D_DOA_whale.mat')
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params';
global brushing
loadParams(paramFile)

% convert lat lon to meters, from Eric
plotAx = [-1000, 200, -1000, 200];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

% plot the smoothed
figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
hold on
plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',[0.8500 0.3250 0.0980],'linewidth',3)
            patch([whale{wn}.CIy(:,1) fliplr(whale{wn}.CIy(:,2))], [whale{wn}.CIx(:,1) fliplr(whale{wn}.CIx(:,2))],[0.8500 0.3250 0.0980],'edgecolor','none','facealpha',0.3)
        end
end


%% plot depth over time
figure
plot(whale{1,1}.TDet,whale{1,1}.wlocSmooth(:,3),'color',[0.8500 0.3250 0.0980],'linewidth',3)
patch([whale{wn,1}.TDet fliplr(whale{wn,1}.TDet)],[whale{wn}.CIz(:,1) fliplr(whale{wn}.CIz(:,2))],[0.8500 0.3250 0.0980],'edgecolor','none','facealpha',0.3)
ylim([-1250 400])
datetick('x')
hold off
ylabel('Depth (m)')
xlabel('Time (HH:mm)')


%% type 3


% load bathymetry
load('F:\bathymetry\siteHgridMedium.mat');
% load receiver positions
load('F:\Instrument_Orientation\SOCAL_H_72_HS\dep\SOCAL_H_72_HS_harp4chPar');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Instrument_Orientation\SOCAL_H_72_HW\dep\SOCAL_H_72_HW_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
% load whale struct
load('F:\Erics_detector\SOCAL_H_72\cleaned_tracks\track270\track270_loc3D_DOA_whale.mat')
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params';
global brushing
loadParams(paramFile)

% convert lat lon to meters, from Eric
plotAx = [-1000, 1000, -2000, 200];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

% plot the smoothed
figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
hold on
plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',[0.4660 0.6740 0.1880],'linewidth',3)
        end
end


%% plot depth over time
figure
plot(whale{1,1}.TDet,whale{1,1}.wlocSmoothLatLonDepth(:,3),'color',[0.4660 0.6740 0.1880],'linewidth',3)
ylim([-1250 400])
datetick('x')
hold off
ylabel('Depth (m)')
xlabel('Time HH:mm')