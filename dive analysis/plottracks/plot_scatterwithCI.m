%% plot the scatters with confidence interval lines

% load bathymetry
load('F:\bathymetry\siteHgridLarge.mat');
% load receiver positions
load('F:\Instrument_Orientation\SOCAL_H_73_HS\dep\SOCAL_H_73_HS_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Instrument_Orientation\SOCAL_H_73_HW\dep\SOCAL_H_73_harp4chParams');
hydLoc{2} = recLoc;
h0 = mean([hydLoc{1}; hydLoc{2}]);
hydLoc{3} = [32.86098  -119.13526 -1268.0248];
% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));
% load whale positions
df = dir('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track*');
% params
paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params';
global brushing
loadParams(paramFile)

load('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track33\track33_loc3D_DOA_whale')
load('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track33\z_stats')

% convert lat lon to meters, from Eric
plotAx = [-3500, 3500, -3500, 3500];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

% before figures
% XY
figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
hold on
plot(h1(2),h1(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
plot(h2(2),h2(1),'s','markeredgecolor','black','markerfacecolor','black','markersize',10)
for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        else
            CIxNeg = whale{wn}.CIy(:,1)-whale{wn}.wloc(:,2);
            CIxPos = whale{wn}.CIy(:,2)-whale{wn}.wloc(:,2);
            CIyNeg = whale{wn}.CIx(:,1)-whale{wn}.wloc(:,1);
            CIyPos = whale{wn}.CIx(:,2)-whale{wn}.wloc(:,1);
            e = errorbar(whale{wn}.wloc(:,2),whale{wn}.wloc(:,1),CIyNeg,CIyPos,CIxNeg,CIxPos,'o')
            plot(whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,1),'color',[0.8500 0.3250 0.0980],'linewidth',3)
            patch([whale{wn}.CIy(:,1) fliplr(whale{wn}.CIy(:,2))], [whale{wn}.CIx(:,1) fliplr(whale{wn}.CIx(:,2))],[0.8500 0.3250 0.0980],'edgecolor','none','facealpha',0.3)
        end
end