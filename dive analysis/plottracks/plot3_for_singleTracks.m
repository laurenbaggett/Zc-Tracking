%% plot3_for_singleTracks

% plot single tracks for the paper
% XY is lat lon, Z is depth, and color is swim speed

%% load in the appropriate data

load('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track260\track260_loc3D_DOA_whale.mat');
load('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track260\track260_distSpd.mat');

% cmocean('thermal',20);
% cmocean('phase',20)
colormap(turbo(40))
% colormap(c(20))
patch([whale{1,wn}.wlocSmooth(1:end-1,1);nan], [whale{1,wn}.wlocSmooth(1:end-1,2);nan],[whale{1,wn}.wlocSmoothLatLonDepth(1:end-1,3);nan],[nonzeros(spd(:,wn));nan],'facecolor','none','edgecolor','interp','linewidth',1.5)
a = colorbar
ylabel(a,'Speed (m/s)')
view(45,10)
caxis([0 2])
grid on
box on

%% try more examples

load('F:\Erics_detector\SOCAL_H_72\cleaned_tracks\track132\track132_loc3D_DOA_whale.mat');
load('F:\Erics_detector\SOCAL_H_72\cleaned_tracks\track132\track132_distSpd.mat');

colormap(turbo(40))
for wn=1:length(whale)
patch([whale{1,wn}.wlocSmooth(1:end-1,1);nan], [whale{1,wn}.wlocSmooth(1:end-1,2);nan],[whale{1,wn}.wlocSmoothLatLonDepth(1:end-1,3);nan],[nonzeros(spd(:,wn));nan],'facecolor','none','edgecolor','interp','linewidth',2)
end
a = colorbar
ylabel(a,'Speed (m/s)')
view(45,10)
caxis([0.5 2])
grid on
box on

%% same examples as previous tracks!!

% type 1: H73 track 132
% type 2: H74 track 182
% type 3: H72 track 270

% type 1 plotting
load('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track132\track132_loc3D_DOA_whale')
load('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track132\track132_distSpd')

figure
colormap(jet(40))
patch([whale{1,wn}.wlocSmooth(1:end-1,1);nan], [whale{1,wn}.wlocSmooth(1:end-1,2);nan],[whale{1,wn}.wlocSmoothLatLonDepth(1:end-1,3);nan],[nonzeros(spd(:,wn));nan],'facecolor','none','edgecolor','interp','linewidth',2.5)
% a = colorbar
% ylabel(a,'Speed (m/s)')
% view(35,10)
view(45,10)
caxis([0.5 2.2])
zlim([-1200 -400])
xticklabels([])
yticklabels([])
zticklabels([])
grid on
set(gca, 'box','on','boxstyle','full')

% type 2 plotting
load('F:\Erics_detector\SOCAL_H_74\cleaned_tracks\track182\track182_loc3D_DOA_whale')
load('F:\Erics_detector\SOCAL_H_74\cleaned_tracks\track182\track182_distSpd')

figure
colormap(turbo(40))
patch([whale{1,wn}.wlocSmooth(1:end-1,1);nan], [whale{1,wn}.wlocSmooth(1:end-1,2);nan],[whale{1,wn}.wlocSmoothLatLonDepth(1:end-1,3);nan],[nonzeros(spd(:,wn));nan],'facecolor','none','edgecolor','interp','linewidth',2.5)
% a = colorbar
% ylabel(a,'Speed (m/s)')
% view(15,10)
view(45,10)
caxis([0.5 2.2])
zlim([-1200 -400])
xticklabels([])
yticklabels([])
zticklabels([])
grid on
set(gca, 'box','on','boxstyle','full')

% type 3 plotting
load('F:\Erics_detector\SOCAL_H_72\cleaned_tracks\track270\track270_loc3D_DOA_whale')
load('F:\Erics_detector\SOCAL_H_72\cleaned_tracks\track270\track270_distSpd')

figure
colormap(turbo(40))
patch([whale{1,wn}.wlocSmooth(1:end-1,1);nan], [whale{1,wn}.wlocSmooth(1:end-1,2);nan],[whale{1,wn}.wlocSmoothLatLonDepth(1:end-1,3);nan],[nonzeros(spd(:,wn));nan],'facecolor','none','edgecolor','interp','linewidth',2.5)
% a = colorbar
% ylabel(a,'Speed (m/s)')
% view(60,10)
view(45,10)
caxis([0.5 2.2])
zlim([-1200 -400])
xticklabels([])
yticklabels([])
zticklabels([])
grid on
set(gca, 'box','on','boxstyle','full')

%% make a movie
% type 1
load('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track132\track132_loc3D_DOA_whale')
load('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track132\track132_distSpd')

figure('units','pixels','position',[0 0 1440 1080])
vidFile = VideoWriter('F:\movies\type1\Type1_track_video');
vidFile.FrameRate = 60;
vidFile.Quality = 100;
open(vidFile)
for i = 2:length(whale{1,wn}.wlocSmooth(1:end-1,1))
    colormap(turbo(40))
    patch([whale{1,wn}.wlocSmooth(1:i,1);nan], [whale{1,wn}.wlocSmooth(1:i,2);nan],[whale{1,wn}.wlocSmoothLatLonDepth(1:i,3);nan],[nonzeros(spd(1:i,wn));nan],'facecolor','none','edgecolor','interp','linewidth',2.5)
    a = colorbar;
    ylabel(a,'Speed (m/s)');
    % view(35,10)
    view(45,10)
    caxis([0.5 2.2])
    zlim([-1200 -400])
    xlim([-180 -150])
    ylim([0 100])
    grid on
    set(gca, 'box','on','boxstyle','full')
    F(i) = getframe(gcf);
    writeVideo(vidFile, F(i));
end
close(vidFile)

% type 2
load('F:\Erics_detector\SOCAL_H_74\cleaned_tracks\track182\track182_loc3D_DOA_whale')
load('F:\Erics_detector\SOCAL_H_74\cleaned_tracks\track182\track182_distSpd')

figure('units','pixels','position',[0 0 1440 1080])
vidFile = VideoWriter('F:\movies\type2\Type2_track_video');
vidFile.FrameRate = 60;
vidFile.Quality = 100;
open(vidFile)
for i = 2:length(whale{1,wn}.wlocSmooth(1:end-1,1))
    colormap(turbo(40))
    patch([whale{1,wn}.wlocSmooth(1:i,1);nan], [whale{1,wn}.wlocSmooth(1:i,2);nan],[whale{1,wn}.wlocSmoothLatLonDepth(1:i,3);nan],[nonzeros(spd(1:i,wn));nan],'facecolor','none','edgecolor','interp','linewidth',2.5)
    a = colorbar;
    ylabel(a,'Speed (m/s)');
    % view(35,10)
    view(45,10)
    caxis([0.5 2.2])
    zlim([-1200 -400])
    xlim([-700 -200])
    ylim([-800 200])
    grid on
    set(gca, 'box','on','boxstyle','full')
    F(i) = getframe(gcf);
    writeVideo(vidFile, F(i));
end
close(vidFile)

% type 3
load('F:\Erics_detector\SOCAL_H_72\cleaned_tracks\track270\track270_loc3D_DOA_whale')
load('F:\Erics_detector\SOCAL_H_72\cleaned_tracks\track270\track270_distSpd')

figure('units','pixels','position',[0 0 1440 1080])
vidFile = VideoWriter('F:\movies\type3\Type3_track_video');
vidFile.FrameRate = 60;
vidFile.Quality = 100;
open(vidFile)
for i = 2:length(whale{1,wn}.wlocSmooth(1:end-1,1))
    colormap(turbo(40))
    patch([whale{1,wn}.wlocSmooth(1:i,1);nan], [whale{1,wn}.wlocSmooth(1:i,2);nan],[whale{1,wn}.wlocSmoothLatLonDepth(1:i,3);nan],[nonzeros(spd(1:i,wn));nan],'facecolor','none','edgecolor','interp','linewidth',2.5)
    a = colorbar;
    ylabel(a,'Speed (m/s)');
    % view(35,10)
    view(45,10)
    caxis([0.5 2.2])
    zlim([-1250 -400])
    xlim([-1500 0])
    ylim([-200 300])
    grid on
    set(gca, 'box','on','boxstyle','full')
    F(i) = getframe(gcf);
    writeVideo(vidFile, F(i));
end
close(vidFile)
