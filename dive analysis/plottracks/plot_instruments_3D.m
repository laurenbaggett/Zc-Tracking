%% plot 3D site figure with instrument locations

% load instrument positions
hydLoc{1} = [32.36492, -118.56841, -1338.4203]; % N 4ch
hydLoc{2} = [32.36975, -118.57225, -1343.4238]; % N 4ch
hydLoc{3} = [32.36975, -118.56458, -1298.3579]; % N 1ch

h0 = mean([hydLoc{1}; hydLoc{2}]);
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = hydLoc{1}(3);
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = hydLoc{2}(3);
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = hydLoc{3}(3);

hloc = [h1; h2; h3];

% read in the bathymetry data
[B, R] = readgeoraster('F:\bathymetry\siteN.tif','CoordinateSystemType','planar');
[xblim, yblim] = latlon2xy_wgs84(R.YWorldLimits, R.XWorldLimits, h0(1), h0(2));
xb = linspace(xblim(1), xblim(2), R.RasterSize(2));
yb = linspace(yblim(1), yblim(2), R.RasterSize(1));

% make the plot
figure
sf = surf(xb, yb, flipud(B)-15);
sf.EdgeColor = 'none';
hold on
colormap("gray")
plot3(hloc(1:2,1), hloc(1:2,2), hloc(1:2,3), 'ks', 'markerfacecolor','black','markersize',10)
plot3(hloc(3,1), hloc(3,2), hloc(3,3), 'o', 'markerfacecolor','black','markeredgecolor','black','markersize',10)

%% plot for site W, how do different deployments land?

% load instrument positions
% H 72
hydLoc1{1} = [32.86117, -119.13516,-1282.5282]; % HE
hydLoc1{2} = [32.85651, -119.13880, -1248.9655]; % HS
hydLoc1{3} = [32.86211, -119.14259, -1263.1919]; % HW
% H 73
hydLoc2{1} = [32.86098, -119.13526, -1268.0248]; % HE
hydLoc2{2} = [32.85626, -119.13896, -1246.4496]; % HS
hydLoc2{3} = [32.86164, -119.14343, -1253.3913]; % HW
% H 74
hydLoc3{1} = [32.8609, -119.1353, -1272]; % HE from trilat, probably lower precision
hydLoc3{2} = [32.86030, -119.13785, -1426.175]; % HS
hydLoc3{3} = [32.86122  -119.14335, -1251.348]; % HW
% H 75
hydLoc4{1} = [32.86216, -119.13519, -1284.5215]; % HE
hydLoc4{2} = [32.85609, -119.13933, -1247.5828]; % HS
hydLoc4{3} = [32.86125, -119.14345, -1256.2609]; % HW

h0(1) = mean([hydLoc1{2}; hydLoc1{3}]);
h0(2) = mean([hydLoc2{2}; hydLoc2{3}]);
h0(3) = mean([hydLoc3{2}; hydLoc3{3}]);
h0(4) = mean([hydLoc4{2}; hydLoc4{3}]);
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = hydLoc{1}(3);
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = hydLoc{2}(3);
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = hydLoc{3}(3);

hloc = [h1; h2; h3];

% read in the bathymetry data
[B, R] = readgeoraster('F:\bathymetry\siteN.tif','CoordinateSystemType','planar');
[xblim, yblim] = latlon2xy_wgs84(R.YWorldLimits, R.XWorldLimits, h0(1), h0(2));
xb = linspace(xblim(1), xblim(2), R.RasterSize(2));
yb = linspace(yblim(1), yblim(2), R.RasterSize(1));

% make the plot
figure
sf = surf(xb, yb, flipud(B)-15);
sf.EdgeColor = 'none';
hold on
colormap("gray")
plot3(hloc(1:2,1), hloc(1:2,2), hloc(1:2,3), 'ks', 'markerfacecolor','black','markersize',10)
plot3(hloc(3,1), hloc(3,2), hloc(3,3), 'o', 'markerfacecolor','black','markeredgecolor','black','markersize',10)
