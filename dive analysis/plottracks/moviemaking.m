%% make plot for individual dive types
% based off Eric's script!

% the whale struct for the file you want to make into a movie
load("F:\Tracking\Erics_detector\SOCAL_W_03\cleaned_tracks\track656\track656_loc3D_DOA_whale.mat")

spd = 60*60*24;
global brushing
loadParams('C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params')

% instrument positions
hydLoc{1} = [33.53749  -120.24758  -1242.3109];
hydLoc{2} = [33.53210  -120.25209  -1244.6753];

h0 = mean([hydLoc{1}; hydLoc{2}]);

% convert positions to meters
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = hydLoc{1}(3);
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = hydLoc{2}(3);
hloc = [h1; h2];
%% begin movie making

[B, R] = readgeoraster('F:\Tracking\bathymetry\siteW_topo.tif'); % bathymetry data

% raster conversion of bathymetry data to meters
[xblim, yblim] = latlon2xy_wgs84(R.YWorldLimits, R.XWorldLimits, h0(1), h0(2));
xb = linspace(xblim(1), xblim(2), R.RasterSize(2));
yb = linspace(yblim(1), yblim(2), R.RasterSize(1));

% set start and end angles of view:
viewStart = [45, 20]; 
viewEnd = [30, 10];


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

tplot = (tstart:5/spd:tend+180/spd).'; % time vector for plot

% interpolate in time to make a smoother movie
for wn = 1:numel(whale)
    for ndim = 1:3
        whaleI{wn}.wloc(:, ndim) = interp1(whale{wn}.TDet, whale{wn}.wlocSmooth(:, ndim), tplot);
    end
    whaleI{wn}.TDet = tplot;
end

viewVec(1, :) = linspace(viewStart(1), viewEnd(1), length(tplot));
viewVec(2, :) = linspace(viewStart(2), viewEnd(2), length(tplot));

v = VideoWriter('F:\Tracking\Erics_detector\SOCAL_W_03\movies\track656_movie','MPEG-4');
open(v)
fig = figure(2);
set(fig, 'Position', [100, 100, 800, 800])

for it = 1:length(tplot)
    sf = surf(xb, yb, flipud(B)-20);
sf.EdgeColor = 'none';
hold on
cmocean('gray')

plot3(hloc(:,1), hloc(:,2), hloc(:,3), 'ks','markerfacecolor','black','markersize',10)
axis([-4000, 3500, -4000, 3500, -1400, -400]) % change this to change the scale of bathymetric data
xlabel('E-W [m]')
ylabel('N-S [m]')
zlabel('Depth [m]')
pbaspect([1, 1, 1])
hold on
grid on
box on

    for wn = 1:numel(whaleI)
        Iuse = find(~isnan(whaleI{wn}.wloc(:,1)) & whaleI{wn}.TDet <= tplot(it));
        if isempty(Iuse)
            continue
        end
        plot3(whaleI{wn}.wloc(Iuse, 1), whaleI{wn}.wloc(Iuse, 2), whaleI{wn}.wloc(Iuse, 3)+h0(3)+20, ...
            'color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)
        plot3(whaleI{wn}.wloc(Iuse(end), 1), whaleI{wn}.wloc(Iuse(end), 2), whaleI{wn}.wloc(Iuse(end), 3)+h0(3)+20,...
            'k.')
        
    end
    hold off
    view(viewVec(:, it).')

    F = getframe(fig);
    writeVideo(v,F);
end
hold off

close(v)
