%% make plot for individual dive types
% based off Eric's script!

load("F:\Tracking\Erics_detector\SOCAL_W_03\cleaned_tracks\track614\track614_loc3D_DOA_whale.mat")

spd = 60*60*24;
global brushing
loadParams('C:\Users\Lauren\Documents\GitHub\wheresWhaledo\brushing.params')

% % H 73 positions
% hydLoc{1} = [32.861640000000000,-119.1434300000000,-1253.391300000000];
% hydLoc{2} = [32.856260000000000,-119.1389600000000,-1246.449600000000];
% % H 74 positions
% hydLoc{1} = [32.860300000000000,-1.191378500000000e+02,-1.426175000000000e+03];
% hydLoc{2} = [32.861220000000000,-1.191433500000000e+02,-1.251348000000000e+03];
% H 72 positions
% hydLoc{1} = [32.856510000000000,-1.191388000000000e+02,-1.248965500000000e+03];
% hydLoc{2} = [32.862110000000000,-1.191425900000000e+02,-1.263191900000000e+03];
% % H 75 position
% hydLoc{1} = [32.8561, -119.1393, -1247.5828];
% hydLoc{2} = [32.8613, -119.1435, -1256.2609];
% W 01 position
% hydLoc{1} = [33.53748, -120.24918, -1251.6757];
% hydLoc{2} = [33.53236, -120.25423, -1249.5326];
% N 68 positions
% hydLoc{1} = [32.36492, -118.56841, -1338.4203];
% hydLoc{2} = [32.36975, -118.57225, -1343.4238];
% % W 01
% hydLoc{1} = [33.53748 -120.24918 -1251.6757];
% hydLoc{2} = [33.53236 -120.25423 -1249.5326];
% % W 02
% hydLoc{1} = [33.53701 -120.24759 -1237.368];
% hydLoc{2} = [33.53138 -120.25162 -1236.775];
% % W 03 positions
% hydLoc{1} = [33.53749  -120.24758  -1242.3109];
% hydLoc{2} = [33.53210  -120.25209  -1244.6753];
% % W 04 positions
hydLoc{1} = [33.53801 -120.25014 -1272.1879];
hydLoc{2} = [33.53277 -120.25518 -1259.4659];

h0 = mean([hydLoc{1}; hydLoc{2}]);

[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = hydLoc{1}(3);
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = hydLoc{2}(3);
hloc = [h1; h2];

%% begin movie making
[B, R] = readgeoraster('F:\Tracking\bathymetry\siteW_topo.tif','CoordinateSystemType','planar'); %bathymetry data

[xblim, yblim] = latlon2xy_wgs84(R.YWorldLimits, R.XWorldLimits, h0(1), h0(2));
xb = linspace(xblim(1), xblim(2), R.RasterSize(2));
yb = linspace(yblim(1), yblim(2), R.RasterSize(1));

% set start and end angles of view:
viewStart = [35, 20]; 
viewEnd = [5, 10];
% viewStart = [220, 20];
% viewEnd = [260, 10];

% determine start/end times of each whale track

tstart = nan;
tend = nan;

for b = 1:numel(whale) % remove any fields that are 0x0
        if height(whale{b}) < 3
            whale{b} = [];
        end
    end
whale(cellfun('isempty',whale)) = []; % remove any empty fields

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


for wn = 1:numel(whale)
    for ndim = 1:3
        whaleI{wn}.wloc(:, ndim) = interp1(whale{wn}.TDet, whale{wn}.wlocSmooth(:, ndim), tplot);
    end
    whaleI{wn}.TDet = tplot;
end

viewVec(1, :) = linspace(viewStart(1), viewEnd(1), length(tplot));
viewVec(2, :) = linspace(viewStart(2), viewEnd(2), length(tplot));

v = VideoWriter('F:\Zc_Analysis\tracking_figures\movies\SOCAL_W_03_track614','MPEG-4');
open(v)
fig = figure(2);
set(fig, 'Position', [100, 100, 800, 800])

for it = 1:length(tplot)
    sf = surf(xb, yb, flipud(B)-25);
sf.EdgeColor = 'none';
hold on
cmocean('gray')
% colormap gray
% shading interp
% contour3(xb, yb, B)

plot3(hloc(:,1), hloc(:,2), hloc(:,3), 'ks','markerfacecolor','black','markersize',10)
% axis([-500, 2000, -1000, 1000, -1400, -400])
% axis([-4000, 4000, -4000, 4000, -1800, -400])
axis([-3000, 1000, -2000, 2000, -1400, -900])
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
