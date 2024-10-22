paramFile = 'C:\Users\Lauren\Documents\GitHub\wheresWhaledo\localize_DOAintersect.params';
global LOC_DOA
loadParams(paramFile)

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
h1(3) = h1(3)+h0(3);
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
h2(3) = h2(3)+h0(3);
load('F:\Erics_detector\SOCAL_H_73\cleaned_tracks\track33\track33_loc3D_DOA_whale');

spd = 60*60*24;
startTimes = nan(numel(whale), 1);
endTimes = nan(numel(whale), 1);
tstart = [];
tend = [];
for wn = 1:numel(whale)
    Iuse = find(~isnan(whale{wn}.wloc(:, 1)));
    startTimes(wn) = whale{wn}.TDet(Iuse(1));
    tstart = min([tstart, whale{wn}.TDet(Iuse(1))]);
    endTimes(wn) = whale{wn}.TDet(Iuse(end));
    tend = max([tend, whale{wn}.TDet(Iuse(end))]);
end

ti = tstart:5/spd:tend;

for wn = 1:numel(whale)
    for dim = 1:3
        whaleI{wn}.wloc(:, dim) = interp1(whale{wn}.TDet, whale{wn}.wlocSmooth(:, dim), ti);
    end
end


for i = 2:length(ti)
    figure
    scatter3(h1(1), h1(2), h1(3), 24, 'k^', 'filled')
    hold on
    scatter3(h2(1), h2(2), h2(3), 24, 'k^', 'filled')
    for wn = 1:length(whale)
        if isempty(whale{wn}) % if no whale with this num
            continue
        elseif i>length(whale{1,wn}.wlocSmooth(1:end-1,1))
            plot3(whaleI{wn}.wloc(1:end-1,1),whaleI{wn}.wloc(1:end-1,2),whaleI{wn}.wloc(1:end-1,3),'linewidth',2,'color',LOC_DOA.colorMat(wn+2, :))
        else
            plot3(whaleI{wn}.wloc(1:i,1),whaleI{wn}.wloc(1:i,2),whaleI{wn}.wloc(1:i,3),'linewidth',2,'color',LOC_DOA.colorMat(wn+2, :))
        end
    end
    view(45+(.15*i),10)
    zlim([-1270 -1000])
    set(gca,'box','on')
    % set(gca, 'box','on','boxstyle','full')
    n = sprintf('file%d.png',i);
    saveas(gcf,['F:\movies\trackEx1\',n])
    close all
end

tic
GSvid = VideoWriter('F:\movies\type3_color\track3_green'); %,'Motion JPEG AVI');
GSvid.FrameRate = 75
open(GSvid);
figDir = 'F:\movies\type3_color';
fileList = dir(fullfile(figDir,'*.png'));
[~, reindex] = sort( str2double( regexp( {fileList.name}, '\d+', 'match', 'once' )));
fileList = fileList(reindex);

for i=1:length(fileList)
    
    I = imread(fullfile(figDir,fileList(i).name));
    writeVideo(GSvid,I)
end

close(GSvid);
toc