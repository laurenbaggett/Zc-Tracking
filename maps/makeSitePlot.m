%% make a map of site H
% LMB last update 10/09/24

% % bathymetry data from gmrt, extract as a grd file
% [X, Y, Z] = grdread2('D:\Other\Bathymetry\CADEMO_zoom.grd'); % load the data
% save('D:\Other\Bathymetry\CHNMS_NO_bathy.mat','X','Y','Z') % save if you want
load('F:\Tracking\bathymetry\socal_new.mat');

% define site coordinates
v = [0,0]; % for adding a black line for land
H = [32.86117  -119.13516 -1282.5282];
W = [33.53973  -120.25815 -1377.8741];
N = [32.36975  -118.56458 -1298.3579];
E = [32.65345  -119.48455 -1328.9836];

% define the colormap
a = m_colmap('blues');
a = vertcat(a,[0.8020    0.8020    0.8020]); % add grey for land

figure
contourf(X,Y,Z,150,'edgecolor','none') % 'showtext','on') %10) %,'edgecolor','black')
colormap(a) % set the colormap to blues
caxis([-2000 0]) % max depth shown is 2000 m
hold on
contourf(X,Y,Z,v,'k') % add black line for land
c = colorbar; % add a colorbar
ylabel(c,'Depth (m)')
scatter(W(2),W(1),150,'o','filled','red')
scatter(H(2),H(1),150,'o','filled','red')
scatter(E(2),E(1),150,'o','filled','red')
scatter(N(2),N(1),150,'o','filled','red')
yticks([32 33 34 35])
yticklabels({'32°N', '33°N','34°N','35°N'})
xticks([-120, -119, -118])
xticklabels({'120°W','119°W','118°W'})
scatter(-118.2437,34.0722,20,'o','filled','black') % Los Angeles
scatter(-119.6982,34.5208,20,'o','filled','black') % Santa Barbara


