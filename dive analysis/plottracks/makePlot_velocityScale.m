% load('D:\presentations\Lauren_tracks\track33_loc3D_DOA_whale.mat')
load('F:\Tracking\Erics_detector\SOCAL_W_03\cleaned_tracks\track423\track423_loc3D_DOA_whale.mat')
spd = 60*60*24;
global brushing
loadParams('C:\Users\Lauren\Documents\GitHub\Wheres-Whaledo\DOA_small_aperture\params\brushing.params')

load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WS\dep\SOCAL_W_03_WS_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WE\dep\SOCAL_W_03_WE_harp4chParams');
hydLoc{2} = recLoc;

h0 = mean([hydLoc{1}; hydLoc{2}]);

[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = hydLoc{1}(3);
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = hydLoc{2}(3);
hloc = [h1; h2];

%% begin movie making
[B, R] = readgeoraster('F:\Tracking\bathymetry\siteW_topo.tif'); %bathymetry data

[xblim, yblim] = latlon2xy_wgs84(R.YWorldLimits, R.XWorldLimits, h0(1), h0(2));
xb = linspace(xblim(1), xblim(2), R.RasterSize(2));
yb = linspace(yblim(1), yblim(2), R.RasterSize(1));

% set start and end angles of view:
viewStart = [20, 10]; 
viewEnd = [90, 0];

% determine start/end times of each whale track

tstart = nan;
tend = nan;

for wn = 1:numel(whale)
    Iuse = find(~isnan(whale{wn}.wlocSmooth(:,1)));
    tstart = min([tstart, whale{wn}.TDet(Iuse(1))]);
    tend = max([tend, whale{wn}.TDet(Iuse(end))]);

    wstart(wn) = whale{wn}.TDet(Iuse(1));
    wend(wn) = whale{wn}.TDet(Iuse(end));

    Istart(wn) = Iuse(1);
    Iend(wn) = Iuse(end);
end

tplot = (tstart:5/spd:tend+15/spd).'; % time vector for plot

col = jet(500);
velScale = linspace(1, 2, 500);

for wn = 1:numel(whale)
    for ndim = 1:3
        whaleI{wn}.wloc(:, ndim) = interp1(whale{wn}.TDet, whale{wn}.wlocSmooth(:, ndim), tplot);
    end
    whaleI{wn}.TDet = tplot;
    whaleI{wn}.vel(2:length(tplot)) = sqrt(sum(diff(whaleI{wn}.wloc).^2, 2))./(diff(tplot).*spd);
    whaleI{wn}.vel(1) = whaleI{wn}.vel(2);
    whaleI{wn}.colInd = nan(size(tplot));
    for ni = 1:length(tplot)
        if ~isnan(whaleI{wn}.vel(ni))
            [~, whaleI{wn}.colInd(ni)] = min(abs(velScale - whaleI{wn}.vel(ni)));
        end
    end
end

for ic = 1:11
    cbTickLabels{ic} = num2str((ic-1)./10 + 1);
    
end
cbTickMarks = linspace(0, 1, 11);
%%

fig = figure(99);
sf = surf(xb, yb, flipud(B)-10);
sf.EdgeColor = 'none';
hold on
colormap gray

bathCol = sf.CData;

close(fig)
clear sf
%%

viewVec(1, :) = linspace(viewStart(1), viewEnd(1), length(tplot));
viewVec(2, :) = linspace(viewStart(2), viewEnd(2), length(tplot));

v = VideoWriter('track182.avi');
open(v)
fig = figure(2);
set(fig, 'Position', [100, 100, 800, 800])

for it = 1:length(tplot)
%     sf = surf(xb, yb, flipud(B)-10);
% sf.EdgeColor = 'none';
% sf.CData = bathCol;

% hold on
% colormap gray
% shading interp
% contour3(xb, yb, B)

plot3(hloc(:,1), hloc(:,2), hloc(:,3), 'ks')
hold on
axis([-700, 300, -700, 300, -1300, -800])
xlabel('E-W [m]')
ylabel('N-S [m]')
zlabel('Depth [m]')
pbaspect([1, 1, 1])
hold on
grid on

    for wn = 1:numel(whaleI)
        Iuse = find(~isnan(whaleI{wn}.wloc(:,1)) & whaleI{wn}.TDet <= tplot(it));
        if isempty(Iuse)
            continue
        end
        sct = scatter3(whaleI{wn}.wloc(Iuse, 1), whaleI{wn}.wloc(Iuse, 2), whaleI{wn}.wloc(Iuse, 3)+h0(3), ...
            45, col(whaleI{wn}.colInd(Iuse), :), 'filled');
        colormap(col)
        cb = colorbar;
        cb.TickLabels = cbTickLabels;

    end
    hold off

    view(viewVec(:, it).')

    F = getframe(fig);
    writeVideo(v,F);
end
hold off

close(v)

%%
% fig = figure;
% movie(fig,F,2)