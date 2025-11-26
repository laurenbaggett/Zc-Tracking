% makeMovies_SR_publication

%% make plot for individual dive types
% based off Eric's script!

load('F:\BW_ICI\GOM\Lauren_GOM_rerun\detector_output\gervais\encounter1\encounter1_loc3D_DOA_whale.mat')

spd = 60*60*24;
global brushing
loadParams('C:\Users\Lauren\Documents\GitHub\Wheres-Whaledo\DOA_small_aperture\params\brushing_pastel')
% 
% % H 72 positions
% hydLoc{1} = [32.856510000000000,-1.191388000000000e+02,-1.248965500000000e+03];
% hydLoc{2} = [32.862110000000000,-1.191425900000000e+02,-1.263191900000000e+03];
% H 73 positions
% hydLoc{1} = [32.861640000000000,-119.1434300000000,-1253.391300000000];
% hydLoc{2} = [32.856260000000000,-119.1389600000000,-1246.449600000000];
% % H 74 positions
% hydLoc{1} = [32.860300000000000,-1.191378500000000e+02,-1.426175000000000e+03];
% hydLoc{2} = [32.861220000000000,-1.191433500000000e+02,-1.251348000000000e+03];
% % H 75 position
% hydLoc{1} = [32.8561, -119.1393, -1247.5828];
% hydLoc{2} = [32.8613, -119.1435, -1256.2609];

% % N 68 positions
% hydLoc{1} = [32.36492, -118.56841, -1338.4203];
% hydLoc{2} = [32.36975, -118.57225, -1343.4238];

% % E 63
% hydLoc{2} = [32.65871  -119.47711 -1325.5285]; % EE
% hydLoc{1} = [32.65646  -119.48815 -1330.1631]; % EW

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
% hydLoc{1} = [33.53801 -120.25014 -1272.1879];
% hydLoc{2} = [33.53277 -120.25518 -1259.4659];
% % % W 05 positions
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_05\SOCAL_W_05_WE\REDO\SOCAL_W_05_WE_harp4chParams');
% hydLoc{1} = recLoc;
% clear recLoc
% load('F:\Tracking\Instrument_Orientation\SOCAL_W_05\SOCAL_W_05_WS\REDO\SOCAL_W_05_WS_harp4chParams');
% hydLoc{2} = recLoc;

% GC 14 polutions
load('F:\BW_ICI\GOM\Lauren_GOM_rerun\instrument_orientations\GOM_GC_14_01_C4\GOM_GC_14_01_C4_harp4chParams.mat');
hydLoc{1} = recLoc;
clear H ; clear recLoc
load('F:\BW_ICI\GOM\Lauren_GOM_rerun\instrument_orientations\GOM_GC_14_02_C4\GOM_GC_14_02_harp4chParams.mat');
hydLoc{2} = recLoc;
clear H; clear recLoc

h0 = mean([hydLoc{1}; hydLoc{2}]);

[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = hydLoc{1}(3);
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = hydLoc{2}(3);
hloc = [h1; h2];

%% begin movie making
[B, R] = readgeoraster('F:\BW_ICI\GOM\GMRT_GOM_GC.tif','CoordinateSystemType','geographic'); %bathymetry data

[xblim, yblim] = latlon2xy_wgs84(R.LatitudeLimits, R.LongitudeLimits, h0(1), h0(2));
xb = linspace(xblim(1), xblim(2), R.RasterSize(2));
yb = linspace(yblim(1), yblim(2), R.RasterSize(1));

% set start and end angles of view:
viewStart = [60, 15];
viewEnd = [40, 10];

% determine start/end times of each whale track

tstart = nan;
tend = nan;

for b = 1:numel(whale) % remove any fields that are 0x0
    if height(whale{b}) < 10
        whale{b} = [];
    end
end
whale(cellfun('isempty',whale)) = []; % remove any empty fields

% find the start and end times for each whale
for wn = 1:numel(whale)
    Iuse = find(~isnan(whale{wn}.wlocSmooth(:,1)));
    tstart = min([tstart, whale{wn}.TDet(Iuse(1))]);
    tend = max([tend, whale{wn}.TDet(Iuse(end))]);

    wstart(wn) = whale{wn}.TDet(Iuse(1));
    wend(wn) = whale{wn}.TDet(Iuse(end));

    Istart(wn) = Iuse(1);
    Iend(wn) = Iuse(end);
end

tplot = (tstart:5/spd:tend+180/spd).'; % time vector for plot, interpolate every 5 seconds

% interpolate time
for wn = 1:numel(whale)
    for ndim = 1:3
        whaleI{wn}.wloc(:, ndim) = interp1(whale{wn}.TDet, whale{wn}.wlocSmooth(:, ndim), tplot);
    end
    whaleI{wn}.TDet = tplot;
end

% add in some code here to linear interpolate through the NaNs, we'll then
% plot these as dashes
for wn = 1:numel(whaleI)

    % identify chunks of nans
    nandiff = diff([true;isnan(whaleI{wn}.wloc(:,1));true]);
    starts{wn} = find(nandiff>0);
    ends{wn} = find(nandiff<0)-1;

    if ~isempty(ends{wn}) && ends{wn}(1) == 0
        ends{wn}(1) = [];
    end
    if ~isempty(ends{wn}) && ~isempty(starts{wn}) && ends{wn}(1) < starts{wn}(1)
        ends{wn}(1) = [];
    end
    if ~isempty(ends{wn}) && ~isempty(starts{wn}) && starts{wn}(end) > ends{wn}(end)
        starts{wn}(end) = [];
    end
    if isempty(starts{wn})
        ends{wn}=[];
    elseif isempty(ends{wn})
        starts{wn} = [];
    end

    % these are now indices of start and end of the nan chunks
    for ch = 1:length(starts{wn})
        for ndim = 1:3 % linear interp per dimension
            lin(:,ndim) = interp1([0 1], [whaleI{wn}.wloc(starts{wn}(ch)-1,ndim), whaleI{wn}.wloc(ends{wn}(ch)+1,ndim)], linspace(0, 1, (ends{wn}(ch)+1)-(starts{wn}(ch)-1)+1));
        end
        whaleI{wn}.wloc(starts{wn}(ch)-1:ends{wn}(ch)+1,:) = lin;
        clear lin
    end

end

viewVec(1, :) = linspace(viewStart(1), viewEnd(1), length(tplot));
viewVec(2, :) = linspace(viewStart(2), viewEnd(2), length(tplot));

v = VideoWriter('F:\BW_ICI\GOM\Lauren_GOM_rerun\detector_output\gervais\encounter1\encounter1_loc3D_DOA_whale_movie','MPEG-4');
open(v)
fig = figure(2);
set(fig, 'Position', [100, 100, 800, 800])

sf = surf(xb, yb, flipud(B));
sf.EdgeColor = 'none';
hold on
cmocean('gray')

for it = 1:length(tplot) % for each time step

    sf = surf(xb, yb, flipud(B)-25);
    sf.EdgeColor = 'none';
    hold on
    cmocean('gray')

    plot3(hloc(:,1), hloc(:,2), hloc(:,3), 'ks','markerfacecolor','white','markersize',10)
    axis([-2000, 2000, -2000, 2000, -1300, 0])
    xlabel('E-W [m]')
    ylabel('N-S [m]')
    zlabel('Depth [m]')
    pbaspect([1, 1, 1])
    hold on
    grid on
    box on

    % add text for site/time
    textstr = ['GOM GC, ',datestr(tplot(it)+datenum([2000 0 0 0 0 0])), ' UTC, Mesoplodon europaeus'];
    title(textstr)

    for wn = 1:numel(whaleI)

        if ~isempty(starts{wn}) % if we have breaks in this whale
            clear off; clear on;
            off(:,1) = starts{wn};
            off(:,2) = ends{wn};

            % find which chunk the time step is within
            Iuse = find(whaleI{wn}.TDet <= tplot(it));

            if isempty(Iuse)
                continue
            end

            if size(off,1)==1 % if there's just one break

                Iuse1 = Iuse(Iuse<off(1,1));
                plot3(whaleI{wn}.wloc(Iuse1, 1), whaleI{wn}.wloc(Iuse1, 2), whaleI{wn}.wloc(Iuse1, 3)+h0(3)+20, ...
                    'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                if Iuse(end) >= off(:,1) && Iuse(end) <= off(:,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(1,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                end

            elseif size(off,1) == 2 % if there's two breaks

                Iuse1 = Iuse(Iuse<off(1,1));
                plot3(whaleI{wn}.wloc(Iuse1, 1), whaleI{wn}.wloc(Iuse1, 2), whaleI{wn}.wloc(Iuse1, 3)+h0(3)+20, ...
                    'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                if Iuse(end) >= off(1,1) && Iuse(end) <= off(1,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(1,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) >= off(2,1) && Iuse(end) <= off(2,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(2,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                end

            elseif size(off,1) == 3 % if there are 3 breaks

                Iuse1 = Iuse(Iuse<off(1,1));
                plot3(whaleI{wn}.wloc(Iuse1, 1), whaleI{wn}.wloc(Iuse1, 2), whaleI{wn}.wloc(Iuse1, 3)+h0(3)+20, ...
                    'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                if Iuse(end) >= off(1,1) && Iuse(end) <= off(1,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(1,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) >= off(2,1) && Iuse(end) <= off(2,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(2,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) >= off(3,1) && Iuse(end) <= off(3,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse6 = Iuse(Iuse>=off(3,1));
                    Iuse6 = Iuse(Iuse<=off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse6, 1), whaleI{wn}.wloc(Iuse6, 2), whaleI{wn}.wloc(Iuse6, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(3,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse6 = Iuse(Iuse>=off(3,1));
                    Iuse6 = Iuse(Iuse<=off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse6, 1), whaleI{wn}.wloc(Iuse6, 2), whaleI{wn}.wloc(Iuse6, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse7 = Iuse(Iuse>off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse7, 1), whaleI{wn}.wloc(Iuse7, 2), whaleI{wn}.wloc(Iuse7, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                end

            elseif size(off,1) == 4 % if there are 5 breaks

                Iuse1 = Iuse(Iuse<off(1,1));
                plot3(whaleI{wn}.wloc(Iuse1, 1), whaleI{wn}.wloc(Iuse1, 2), whaleI{wn}.wloc(Iuse1, 3)+h0(3)+20, ...
                    'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                if Iuse(end) >= off(1,1) && Iuse(end) <= off(1,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(1,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) >= off(2,1) && Iuse(end) <= off(2,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(2,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) >= off(3,1) && Iuse(end) <= off(3,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse6 = Iuse(Iuse>=off(3,1));
                    Iuse6 = Iuse(Iuse<=off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse6, 1), whaleI{wn}.wloc(Iuse6, 2), whaleI{wn}.wloc(Iuse6, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(3,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse6 = Iuse(Iuse>=off(3,1));
                    Iuse6 = Iuse(Iuse<=off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse6, 1), whaleI{wn}.wloc(Iuse6, 2), whaleI{wn}.wloc(Iuse6, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse7 = Iuse(Iuse>off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse7, 1), whaleI{wn}.wloc(Iuse7, 2), whaleI{wn}.wloc(Iuse7, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) >= off(4,1) && Iuse(end) <= off(4,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse6 = Iuse(Iuse>=off(3,1));
                    Iuse6 = Iuse(Iuse<=off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse6, 1), whaleI{wn}.wloc(Iuse6, 2), whaleI{wn}.wloc(Iuse6, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse7 = Iuse(Iuse>off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse7, 1), whaleI{wn}.wloc(Iuse7, 2), whaleI{wn}.wloc(Iuse7, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse8 = Iuse(Iuse>=off(4,1));
                    Iuse8 = Iuse(Iuse<=off(4,2));
                    plot3(whaleI{wn}.wloc(Iuse8, 1), whaleI{wn}.wloc(Iuse8, 2), whaleI{wn}.wloc(Iuse8, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse9 = Iuse(Iuse>off(4,2));
                    plot3(whaleI{wn}.wloc(Iuse9, 1), whaleI{wn}.wloc(Iuse9, 2), whaleI{wn}.wloc(Iuse9, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                end

            elseif size(off,1) == 5 % if there are 5 breaks

                Iuse1 = Iuse(Iuse<off(1,1));
                plot3(whaleI{wn}.wloc(Iuse1, 1), whaleI{wn}.wloc(Iuse1, 2), whaleI{wn}.wloc(Iuse1, 3)+h0(3)+20, ...
                    'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                if Iuse(end) >= off(1,1) && Iuse(end) <= off(1,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(1,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) >= off(2,1) && Iuse(end) <= off(2,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(2,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) >= off(3,1) && Iuse(end) <= off(3,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse6 = Iuse(Iuse>=off(3,1));
                    Iuse6 = Iuse(Iuse<=off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse6, 1), whaleI{wn}.wloc(Iuse6, 2), whaleI{wn}.wloc(Iuse6, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) > off(3,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse6 = Iuse(Iuse>=off(3,1));
                    Iuse6 = Iuse(Iuse<=off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse6, 1), whaleI{wn}.wloc(Iuse6, 2), whaleI{wn}.wloc(Iuse6, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse7 = Iuse(Iuse>off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse7, 1), whaleI{wn}.wloc(Iuse7, 2), whaleI{wn}.wloc(Iuse7, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                elseif Iuse(end) >= off(4,1) && Iuse(end) <= off(4,2)

                    Iuse2 = Iuse(Iuse>=off(1,1));
                    Iuse2 = Iuse(Iuse<=off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse2, 1), whaleI{wn}.wloc(Iuse2, 2), whaleI{wn}.wloc(Iuse2, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse3 = Iuse(Iuse>off(1,2));
                    plot3(whaleI{wn}.wloc(Iuse3, 1), whaleI{wn}.wloc(Iuse3, 2), whaleI{wn}.wloc(Iuse3, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse4 = Iuse(Iuse>=off(2,1));
                    Iuse4 = Iuse(Iuse<=off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse4, 1), whaleI{wn}.wloc(Iuse4, 2), whaleI{wn}.wloc(Iuse4, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse5 = Iuse(Iuse>off(2,2));
                    plot3(whaleI{wn}.wloc(Iuse5, 1), whaleI{wn}.wloc(Iuse5, 2), whaleI{wn}.wloc(Iuse5, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse6 = Iuse(Iuse>=off(3,1));
                    Iuse6 = Iuse(Iuse<=off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse6, 1), whaleI{wn}.wloc(Iuse6, 2), whaleI{wn}.wloc(Iuse6, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse7 = Iuse(Iuse>off(3,2));
                    plot3(whaleI{wn}.wloc(Iuse7, 1), whaleI{wn}.wloc(Iuse7, 2), whaleI{wn}.wloc(Iuse7, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse8 = Iuse(Iuse>=off(4,1));
                    Iuse8 = Iuse(Iuse<=off(4,2));
                    plot3(whaleI{wn}.wloc(Iuse8, 1), whaleI{wn}.wloc(Iuse8, 2), whaleI{wn}.wloc(Iuse8, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse9 = Iuse(Iuse>off(4,2));
                    plot3(whaleI{wn}.wloc(Iuse9, 1), whaleI{wn}.wloc(Iuse9, 2), whaleI{wn}.wloc(Iuse9, 3)+h0(3)+20, ...
                        'linestyle','-','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                    Iuse10 = Iuse(Iuse>=off(5,1));
                    Iuse10 = Iuse(Iuse<=off(5,2));
                    plot3(whaleI{wn}.wloc(Iuse10, 1), whaleI{wn}.wloc(Iuse10, 2), whaleI{wn}.wloc(Iuse10, 3)+h0(3)+20, ...
                        'linestyle',':','color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)

                end

            else % if we have more breaks
                keyboard
            end

        else % if we have no breaks!

            Iuse = find(~isnan(whaleI{wn}.wloc(:,1)) & whaleI{wn}.TDet <= tplot(it));
            if isempty(Iuse)
                continue
            end
            plot3(whaleI{wn}.wloc(Iuse, 1), whaleI{wn}.wloc(Iuse, 2), whaleI{wn}.wloc(Iuse, 3)+h0(3)+20, ...
                'color',brushing.params.colorMat(wn+2,:), 'linewidth', 3)
            % plot3(whaleI{wn}.wloc(Iuse(end), 1), whaleI{wn}.wloc(Iuse(end), 2), whaleI{wn}.wloc(Iuse(end), 3)+h0(3)+20,...
            %     'k.')

        end
    end
    hold off
    view(viewVec(:, it).')

    F = getframe(fig);
    writeVideo(v,F);
end
hold off

close(v)


