%% makeDepPlot
% make figures of instrument positions per site, for each deployment
% in 2D, then in 3D

% % process bathy data from GMRT
% [X, Y, Z] = grdread2('F:\bathymetry\socalN_zoom.grd'); % load the data
% contour(X,Y,Z,'black','showtext','on'); % check that it looks right
% save('F:\bathymetry\siteN_zoom.mat','X','Y','Z') % save if you want
% close all

% load existing bathymetry data
load('F:\Tracking\bathymetry\socal2');

% load receiver positions
% % N_68
% hydLoc{3} = [32.36975  -118.56458 -1298.3579]; % single channel
% hydLoc{1} = [32.36492  -118.56841 -1338.4203]; % NS
% hydLoc{2} = [32.36975  -118.57225 -1343.4238]; % NW
% E_63
hydLoc{3} = [32.65345  -119.48455  -1328.9836]; % ES (1ch)
hydLoc{1} = [32.65871  -119.47711  -1325.5285]; % EE (4ch)
hydLoc{2} = [32.65646  -119.48815  -1330.1631]; % EW (4ch)

% convert hydrophone locations to meters:
h0 = mean([hydLoc{1}; hydLoc{2}]);
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = abs(h0(3))-abs(hydLoc{1}(3));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = abs(h0(3))-abs(hydLoc{2}(3));
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = abs(h0(3))-abs(hydLoc{3}(3));

% convert lat lon to meters, from Eric
plotAx = [-1000, 1000, -1000, 1000];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);

% make the figure
figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
% contour(X,Y,Z,15,'black','showtext','on','labelformat','%0.01f m')
% yticks([])
% yticklabels([])
% xticks([])
% xticklabels([])
hold on
% plot(h1(1),h1(2),'s','markeredgecolor','black','markerfacecolor','black','markersize',8);
% plot(h2(1),h2(2),'s','markeredgecolor','black','markerfacecolor','black','markersize',8);
% plot(h3(1),h3(2),'o','markeredgecolor','black','markerfacecolor','black','markersize',8)
h(1) = plot(h1(1),h1(2),'s','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',10);
h(2) = plot(h2(1),h2(2),'s','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',10);
h(3) = plot(h3(1),h3(2),'o','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',10);
% h(4) = plot(hydLoc{1,4}(2),hydLoc{1,4}(1),'s','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',10);
plot([h1(1) h2(1)], [h1(2) h2(2)],'--','color','#FF1F5B')
plot([h2(1) h3(1)], [h2(2) h3(2)],'--','color','#FF1F5B')
plot([h1(1) h3(1)], [h1(2) h3(2)],'--','color','#FF1F5B')
h(4) = plot(NaN,NaN,'-','color','#FF1F5B','linewidth',8,'displayname','E63');
h(5) = plot(NaN,NaN,'s','markeredgecolor','black','markerfacecolor','white','markersize',12,'displayname','4-Channel');
h(6) = plot(NaN,NaN,'o','markeredgecolor','black','markerfacecolor','white','markersize',8,'displayname','1-Channel');
legend(h(4:6))
axis equal

%% figures for sites H and W hard coded, since there are so many deployments for each

% site W
% load receiver positions
% load('F:\bathymetry\W01.mat');

hydLoc1{1} = [33.53748  -120.24918 -1251.6757];
hydLoc1{2} = [33.53236  -120.25423 -1249.5326];
hydLoc1{3} = [33.53973  -120.25815 -1377.8741];

hydLoc2{1} = [33.53701  -120.24759 -1237.368];
hydLoc2{2} = [33.53138  -120.25162 -1236.775];
hydLoc2{3} = [33.54074  -120.25917 -1375.0725];

hydLoc3{1} = [33.53749  -120.24758 -1242.3095];
hydLoc3{2} = [33.53210  -120.25209 -1244.6753];
hydLoc3{3} = [33.54117  -120.25922 -1383.9635];

hydLoc4{1} = [33.53801  -120.25014 -1272.1879];
hydLoc4{2} = [33.53277  -120.25518 -1259.4659];
hydLoc4{3} = [33.54079  -120.25996 -1387.6076];

hydLoc5{1} = [33.53949  -120.25116 -1314.6391];
hydLoc5{2} = [33.53472  -120.25518 -1322.6153];
hydLoc5{3} = [33.54196  -120.25820 -1510.562];

% convert hydrophone locations to meters:
h0 = mean([hydLoc1{1}; hydLoc1{2}]);
% W_01
[h1_1(1), h1_1(2)] = latlon2xy_wgs84(hydLoc1{1}(1), hydLoc1{1}(2), h0(1), h0(2));
h1_1(3) = abs(h0(3))-abs(hydLoc1{1}(3));
[h2_1(1), h2_1(2)] = latlon2xy_wgs84(hydLoc1{2}(1), hydLoc1{2}(2), h0(1), h0(2));
h2_1(3) = abs(h0(3))-abs(hydLoc1{2}(3));
[h3_1(1), h3_1(2)] = latlon2xy_wgs84(hydLoc1{3}(1), hydLoc1{3}(2), h0(1), h0(2));
h3_1(3) = abs(h0(3))-abs(hydLoc1{3}(3));
% W_02
[h1_2(1), h1_2(2)] = latlon2xy_wgs84(hydLoc2{1}(1), hydLoc2{1}(2), h0(1), h0(2));
h1_2(3) = abs(h0(3))-abs(hydLoc2{1}(3));
[h2_2(1), h2_2(2)] = latlon2xy_wgs84(hydLoc2{2}(1), hydLoc2{2}(2), h0(1), h0(2));
h2_2(3) = abs(h0(3))-abs(hydLoc2{2}(3));
[h3_2(1), h3_2(2)] = latlon2xy_wgs84(hydLoc2{3}(1), hydLoc2{3}(2), h0(1), h0(2));
h3_2(3) = abs(h0(3))-abs(hydLoc2{3}(3));
% W_03
[h1_3(1), h1_3(2)] = latlon2xy_wgs84(hydLoc3{1}(1), hydLoc3{1}(2), h0(1), h0(2));
h1_3(3) = abs(h0(3))-abs(hydLoc3{1}(3));
[h2_3(1), h2_3(2)] = latlon2xy_wgs84(hydLoc3{2}(1), hydLoc3{2}(2), h0(1), h0(2));
h2_3(3) = abs(h0(3))-abs(hydLoc3{2}(3));
[h3_3(1), h3_3(2)] = latlon2xy_wgs84(hydLoc3{3}(1), hydLoc3{3}(2), h0(1), h0(2));
h3_3(3) = abs(h0(3))-abs(hydLoc3{3}(3));
% W_04
[h1_4(1), h1_4(2)] = latlon2xy_wgs84(hydLoc4{1}(1), hydLoc4{1}(2), h0(1), h0(2));
h1_4(3) = abs(h0(3))-abs(hydLoc4{1}(3));
[h2_4(1), h2_4(2)] = latlon2xy_wgs84(hydLoc4{2}(1), hydLoc4{2}(2), h0(1), h0(2));
h2_4(3) = abs(h0(3))-abs(hydLoc4{2}(3));
[h3_4(1), h3_4(2)] = latlon2xy_wgs84(hydLoc4{3}(1), hydLoc4{3}(2), h0(1), h0(2));
h3_4(3) = abs(h0(3))-abs(hydLoc4{3}(3));
% W_05
[h1_5(1), h1_5(2)] = latlon2xy_wgs84(hydLoc5{1}(1), hydLoc5{1}(2), h0(1), h0(2));
h1_5(3) = abs(h0(3))-abs(hydLoc5{1}(3));
[h2_5(1), h2_5(2)] = latlon2xy_wgs84(hydLoc5{2}(1), hydLoc5{2}(2), h0(1), h0(2));
h2_5(3) = abs(h0(3))-abs(hydLoc5{2}(3));
[h3_5(1), h3_5(2)] = latlon2xy_wgs84(hydLoc5{3}(1), hydLoc5{3}(2), h0(1), h0(2));
h3_5(3) = abs(h0(3))-abs(hydLoc5{3}(3));


% convert lat lon to meters, from Eric
plotAx = [-1000, 1000, -700, 1300];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);


figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
% contour(X,Y,Z,15,'black','showtext','on','labelformat','%0.01f m')
% yticks([])
% yticklabels([])
% xticks([])
% xticklabels([])
hold on
h(1) = plot(h1_1(1),h1_1(2),'s','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',8,'DisplayName','W01');
h(2) = plot(h2_1(1),h2_1(2),'s','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',8,'DisplayName','W01');
h(3) = plot(h3_1(1),h3_1(2),'o','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',8,'DisplayName','W01');
plot([h1_1(1) h2_1(1)], [h1_1(2) h2_1(2)],'--','color','#FF1F5B')
plot([h2_1(1) h3_1(1)], [h2_1(2) h3_1(2)],'--','color','#FF1F5B')
plot([h1_1(1) h3_1(1)], [h1_1(2) h3_1(2)],'--','color','#FF1F5B')
h(4) = plot(h1_2(1),h1_2(2),'s','markeredgecolor','black','markerfacecolor','#00CD6C','markersize',8,'DisplayName','W02');
h(5) = plot(h2_2(1),h2_2(2),'s','markeredgecolor','black','markerfacecolor','#00CD6C','markersize',8,'DisplayName','W02');
h(6) = plot(h3_2(1),h3_2(2),'o','markeredgecolor','black','markerfacecolor','#00CD6C','markersize',8,'DisplayName','W02');
plot([h1_2(1) h2_2(1)], [h1_2(2) h2_2(2)],'--','color','#00CD6C')
plot([h2_2(1) h3_2(1)], [h2_2(2) h3_2(2)],'--','color','#00CD6C')
plot([h1_2(1) h3_2(1)], [h1_2(2) h3_2(2)],'--','color','#00CD6C')
h(7) = plot(h1_3(1),h1_3(2),'s','markeredgecolor','black','markerfacecolor','#009ADE','markersize',8,'DisplayName','W03');
h(8) = plot(h2_3(1),h2_3(2),'s','markeredgecolor','black','markerfacecolor','#009ADE','markersize',8,'DisplayName','W03');
h(9) = plot(h3_3(1),h3_3(2),'o','markeredgecolor','black','markerfacecolor','#009ADE','markersize',8,'DisplayName','W03');
plot([h1_3(1) h2_3(1)], [h1_3(2) h2_3(2)],'--','color','#009ADE')
plot([h2_3(1) h3_3(1)], [h2_3(2) h3_3(2)],'--','color','#009ADE')
plot([h1_3(1) h3_3(1)], [h1_3(2) h3_3(2)],'--','color','#009ADE')
h(10) = plot(h1_4(1),h1_4(2),'s','markeredgecolor','black','markerfacecolor','#C77CFF','markersize',8,'DisplayName','W04');
h(11) = plot(h2_4(1),h2_4(2),'s','markeredgecolor','black','markerfacecolor','#C77CFF','markersize',8,'DisplayName','W04');
h(12) = plot(h3_4(1),h3_4(2),'o','markeredgecolor','black','markerfacecolor','#C77CFF','markersize',8,'DisplayName','W04');
plot([h1_4(1) h2_4(1)], [h1_4(2) h2_4(2)],'--','color','#C77CFF')
plot([h2_4(1) h3_4(1)], [h2_4(2) h3_4(2)],'--','color','#C77CFF')
plot([h1_4(1) h3_4(1)], [h1_4(2) h3_4(2)],'--','color','#C77CFF')
h(13) = plot(h1_5(1),h1_5(2),'s','markeredgecolor','black','markerfacecolor','#EC5800','markersize',8,'DisplayName','W05');
h(14) = plot(h2_5(1),h2_5(2),'s','markeredgecolor','black','markerfacecolor','#EC5800','markersize',8,'DisplayName','W05');
h(15) = plot(h3_5(1),h3_5(2),'o','markeredgecolor','black','markerfacecolor','#EC5800','markersize',8,'DisplayName','W05');
plot([h1_5(1) h2_5(1)], [h1_5(2) h2_5(2)],'--','color','#EC5800')
plot([h2_5(1) h3_5(1)], [h2_5(2) h3_5(2)],'--','color','#EC5800')
plot([h1_5(1) h3_5(1)], [h1_5(2) h3_5(2)],'--','color','#EC5800')
h(16) = plot(NaN,NaN,'-','color','#FF1F5B','linewidth',8,'displayname','W01');
h(17) = plot(NaN,NaN,'-','color','#00CD6C','linewidth',8,'displayname','W02');
h(18) = plot(NaN,NaN,'-','color','#009ADE','linewidth',8,'displayname','W03');
h(19) = plot(NaN,NaN,'-','color','#C77CFF','linewidth',8,'displayname','W04');
h(20) = plot(NaN,NaN,'-','color','#EC5800','linewidth',8,'displayname','W05');
h(21) = plot(NaN,NaN,'s','markeredgecolor','black','markerfacecolor','white','markersize',12,'displayname','4-Channel');
h(22) = plot(NaN,NaN,'o','markeredgecolor','black','markerfacecolor','white','markersize',8,'displayname','1-Channel');
legend(h(16:22))
axis equal

%% site H
hydLoc1{1} = [32.85651  -119.13880 -1248.9655];
hydLoc1{2} = [32.86211  -119.14259 -1263.1919];
hydLoc1{3} = [32.86117  -119.13516 -1282.5282];

hydLoc2{1} = [32.85626  -119.13896 -1246.4496];
hydLoc2{2} = [32.86164  -119.14343 -1253.3913];
hydLoc2{3} = [32.86098  -119.13526 -1268.0248];

hydLoc3{1} = [32.86030  -119.13785 -1426.175];
hydLoc3{2} = [32.86122  -119.14335 -1251.348];
hydLoc3{3} = [32.8609  -119.1353 -1272];

hydLoc4{1} = [32.85599  -119.13923 -1248.3254];
hydLoc4{2} = [32.86130  -119.14342 -1255.7739];
hydLoc4{3} = [32.86216  -119.13519 -1284.5215];

% convert hydrophone locations to meters:
h0 = mean([hydLoc1{1}; hydLoc1{2}]);
% H_72
[h1_1(1), h1_1(2)] = latlon2xy_wgs84(hydLoc1{1}(1), hydLoc1{1}(2), h0(1), h0(2));
h1_1(3) = abs(h0(3))-abs(hydLoc1{1}(3));
[h2_1(1), h2_1(2)] = latlon2xy_wgs84(hydLoc1{2}(1), hydLoc1{2}(2), h0(1), h0(2));
h2_1(3) = abs(h0(3))-abs(hydLoc1{2}(3));
[h3_1(1), h3_1(2)] = latlon2xy_wgs84(hydLoc1{3}(1), hydLoc1{3}(2), h0(1), h0(2));
h3_1(3) = abs(h0(3))-abs(hydLoc1{3}(3));
% H_73
[h1_2(1), h1_2(2)] = latlon2xy_wgs84(hydLoc2{1}(1), hydLoc2{1}(2), h0(1), h0(2));
h1_2(3) = abs(h0(3))-abs(hydLoc2{1}(3));
[h2_2(1), h2_2(2)] = latlon2xy_wgs84(hydLoc2{2}(1), hydLoc2{2}(2), h0(1), h0(2));
h2_2(3) = abs(h0(3))-abs(hydLoc2{2}(3));
[h3_2(1), h3_2(2)] = latlon2xy_wgs84(hydLoc2{3}(1), hydLoc2{3}(2), h0(1), h0(2));
h3_2(3) = abs(h0(3))-abs(hydLoc2{3}(3));
% H_74
[h1_3(1), h1_3(2)] = latlon2xy_wgs84(hydLoc3{1}(1), hydLoc3{1}(2), h0(1), h0(2));
h1_3(3) = abs(h0(3))-abs(hydLoc3{1}(3));
[h2_3(1), h2_3(2)] = latlon2xy_wgs84(hydLoc3{2}(1), hydLoc3{2}(2), h0(1), h0(2));
h2_3(3) = abs(h0(3))-abs(hydLoc3{2}(3));
[h3_3(1), h3_3(2)] = latlon2xy_wgs84(hydLoc3{3}(1), hydLoc3{3}(2), h0(1), h0(2));
h3_3(3) = abs(h0(3))-abs(hydLoc3{3}(3));
% H_75
[h1_4(1), h1_4(2)] = latlon2xy_wgs84(hydLoc4{1}(1), hydLoc4{1}(2), h0(1), h0(2));
h1_4(3) = abs(h0(3))-abs(hydLoc4{1}(3));
[h2_4(1), h2_4(2)] = latlon2xy_wgs84(hydLoc4{2}(1), hydLoc4{2}(2), h0(1), h0(2));
h2_4(3) = abs(h0(3))-abs(hydLoc4{2}(3));
[h3_4(1), h3_4(2)] = latlon2xy_wgs84(hydLoc4{3}(1), hydLoc4{3}(2), h0(1), h0(2));
h3_4(3) = abs(h0(3))-abs(hydLoc4{3}(3));


% convert lat lon to meters, from Eric
plotAx = [-800, 1200, -800, 1200];
[x,~] = latlon2xy_wgs84(h0(1).*ones(size(X)), X, h0(1), h0(2));
[~,y] = latlon2xy_wgs84(Y, h0(2).*ones(size(Y)), h0(1), h0(2));
Ix = find(x>=plotAx(1)-100 & x<=plotAx(2)+100);
Iy = find(y>=plotAx(3)-100 & y<=plotAx(4)+100);


figure
contour(x(Ix), y(Iy), Z(Iy,Ix),'black','showtext','on')
% contour(X,Y,Z,15,'black','showtext','on','labelformat','%0.01f m')
% yticks([])
% yticklabels([])
% xticks([])
% xticklabels([])
hold on
h(1) = plot(h1_1(1),h1_1(2),'s','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',8,'DisplayName','H72');
h(2) = plot(h2_1(1),h2_1(2),'s','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',8,'DisplayName','H72');
h(3) = plot(h3_1(1),h3_1(2),'o','markeredgecolor','black','markerfacecolor','#FF1F5B','markersize',8,'DisplayName','H72');
plot([h1_1(1) h2_1(1)], [h1_1(2) h2_1(2)],'--','color','#FF1F5B')
plot([h2_1(1) h3_1(1)], [h2_1(2) h3_1(2)],'--','color','#FF1F5B')
plot([h1_1(1) h3_1(1)], [h1_1(2) h3_1(2)],'--','color','#FF1F5B')
h(4) = plot(h1_2(1),h1_2(2),'s','markeredgecolor','black','markerfacecolor','#00CD6C','markersize',8,'DisplayName','H73');
h(5) = plot(h2_2(1),h2_2(2),'s','markeredgecolor','black','markerfacecolor','#00CD6C','markersize',8,'DisplayName','H73');
h(6) = plot(h3_2(1),h3_2(2),'o','markeredgecolor','black','markerfacecolor','#00CD6C','markersize',8,'DisplayName','H73');
plot([h1_2(1) h2_2(1)], [h1_2(2) h2_2(2)],'--','color','#00CD6C')
plot([h2_2(1) h3_2(1)], [h2_2(2) h3_2(2)],'--','color','#00CD6C')
plot([h1_2(1) h3_2(1)], [h1_2(2) h3_2(2)],'--','color','#00CD6C')
h(7) = plot(h1_3(1),h1_3(2),'s','markeredgecolor','black','markerfacecolor','#009ADE','markersize',8,'DisplayName','H74');
h(8) = plot(h2_3(1),h2_3(2),'s','markeredgecolor','black','markerfacecolor','#009ADE','markersize',8,'DisplayName','H74');
h(9) = plot(h3_3(1),h3_3(2),'o','markeredgecolor','black','markerfacecolor','#009ADE','markersize',8,'DisplayName','H74');
plot([h1_3(1) h2_3(1)], [h1_3(2) h2_3(2)],'--','color','#009ADE')
plot([h2_3(1) h3_3(1)], [h2_3(2) h3_3(2)],'--','color','#009ADE')
plot([h1_3(1) h3_3(1)], [h1_3(2) h3_3(2)],'--','color','#009ADE')
h(10) = plot(h1_4(1),h1_4(2),'s','markeredgecolor','black','markerfacecolor','#C77CFF','markersize',8,'DisplayName','H75');
h(11) = plot(h2_4(1),h2_4(2),'s','markeredgecolor','black','markerfacecolor','#C77CFF','markersize',8,'DisplayName','H75');
h(12) = plot(h3_4(1),h3_4(2),'o','markeredgecolor','black','markerfacecolor','#C77CFF','markersize',8,'DisplayName','H75');
plot([h1_4(1) h2_4(1)], [h1_4(2) h2_4(2)],'--','color','#C77CFF')
plot([h2_4(1) h3_4(1)], [h2_4(2) h3_4(2)],'--','color','#C77CFF')
plot([h1_4(1) h3_4(1)], [h1_4(2) h3_4(2)],'--','color','#C77CFF')
h(13) = plot(NaN,NaN,'-','color','#FF1F5B','linewidth',8,'displayname','H72');
h(14) = plot(NaN,NaN,'-','color','#00CD6C','linewidth',8,'displayname','H73');
h(15) = plot(NaN,NaN,'-','color','#009ADE','linewidth',8,'displayname','H74');
h(16) = plot(NaN,NaN,'-','color','#C77CFF','linewidth',8,'displayname','H75');
h(17) = plot(NaN,NaN,'s','markeredgecolor','black','markerfacecolor','white','markersize',12,'displayname','4-Channel');
h(18) = plot(NaN,NaN,'o','markeredgecolor','black','markerfacecolor','white','markersize',8,'displayname','1-Channel');
legend(h(13:18))
axis equal

%% make some 3D figures showing the deployment positions!

% get instrument positions calculated in meters
h0 = mean([hydLoc{1}; hydLoc{2}]);
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
h1(3) = hydLoc{1}(3);
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));
h2(3) = hydLoc{2}(3);
[h3(1), h3(2)] = latlon2xy_wgs84(hydLoc{3}(1), hydLoc{3}(2), h0(1), h0(2));
h3(3) = hydLoc{3}(3);
hloc = [h1; h2; h3];

% use tif files for this so that we can have meters on there
[B, R] = readgeoraster('F:\bathymetry\siteN_zoom.tif','coordinatesystemtype','planar');
[xblim, yblim] = latlon2xy_wgs84(R.YWorldLimits, R.XWorldLimits, h0(1), h0(2));
xb = linspace(xblim(1), xblim(2), R.RasterSize(2));
yb = linspace(yblim(1), yblim(2), R.RasterSize(1));

figure
surf(xb, yb, flipud(B)-10,'edgecolor','none');
hold on
cmocean('gray')
% axis([-4000, 4000, -4000, 4000, -1450, -400])
plot3(hloc(1:2,1), hloc(1:2,2), hloc(1:2,3), 'k', 'markerfacecolor','black','markersize',10)
plot3(hloc(3,1), hloc(3,2), hloc(3,3), 'o', 'markerfacecolor','black','markersize',10)
xlabel('E-W (m)')
ylabel('N-S (m)')
zlabel('Depth (m)')
grid on
box on
hold off


figure
surf(X,Y,Z,'edgecolor','none')
cmocean('gray')
hold on
plot3(hydLoc{1}(2), hydLoc{1}(1), hydLoc{1}(3)+20, 'ks','markerfacecolor','#FF1F5B','markersize',10)
plot3(hydLoc{2}(2), hydLoc{2}(1), hydLoc{2}(3)+20, 'ks','markerfacecolor','#FF1F5B','markersize',10)
plot3(hydLoc{3}(2), hydLoc{3}(1), hydLoc{3}(3)+20, 'o','markerfacecolor','#FF1F5B','markeredgecolor','black','markersize',10)
zlim([-1450 -600])