% plot_whale_with_sf_2D
% LMB Sept 2024
% plot the whale tracks where the whales are following the contours of
% bathymetry
% in 2D, good for proposals + reports where we can't include videos
% h_73, track 278 and 43

% load whale
load('F:\Tracking\Erics_detector\SOCAL_W_03\cleaned_tracks\track77\track77_loc3D_DOA_whale');
% load distance from seafloor
% load('F:\Tracking\Erics_detector\SOCAL_W_03\cleaned_tracks\track77\track77_distFromSeafloor');
% load bathymetry
load('F:\Tracking\bathymetry\socal_new.mat')

closeDepth = zeros(length(whale{1,1}.TDet),1);
for i = 1:length(whale{1,1}.TDet)
    % find the closest lat
    [ ~, closeLon] = min(abs(X-whale{1,1}.wlocSmoothLatLonDepth(i,2)));
    % find the closest lon
    [~, closeLat] = min(abs(Y-whale{1,1}.wlocSmoothLatLonDepth(i,1)));
    % index to grab depth
    thisDepth(i) = Z(closeLat,closeLon);
end

figure
plot(whale{1,1}.TDet,whale{1,1}.wlocSmoothLatLonDepth(:,3)+1400,'linewidth',3)
hold on
area(whale{1,1}.TDet,thisDepth+1400,'facecolor',[0.8 0.8 0.8])
xlim([whale{1,1}.TDet(1), whale{1,1}.TDet(end)])
datetick('x','keeplimits')
ylim([0 700])
yticklabels({'-1400','-1300','-1200','-1100','-1000','-900','-800','-700'})
xlabel('15 Jun 2022')
ylabel('Depth (m)')
title('SOCAL W')
