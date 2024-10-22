% W 05
load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WE\dep\SOCAL_W_03_WE_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WS\dep\SOCAL_W_03_WS_harp4chParams');
hydLoc{2} = recLoc;
% set h0 at consistent point so can combine these detprobs later on!
% site W, set centerpoint at center of W01
h0 = mean([hydLoc{1};hydLoc{2}]);
% h0 = mean([33.53748, -120.24918, 1251.6757; 33.53236, -120.25423, -1249.5326]);

% convert hydrophone locations to meters:
[h1(1), h1(2)] = latlon2xy_wgs84(hydLoc{1}(1), hydLoc{1}(2), h0(1), h0(2));
[h2(1), h2(2)] = latlon2xy_wgs84(hydLoc{2}(1), hydLoc{2}(2), h0(1), h0(2));

offset = [h1;h2];
save('F:\Tracking\prop\SOCAL_W_03\SOCAL_W_03_4ch_offset2_m','offset','h0');

%% calculate absolute

% offset is x,y distance of each 4 channel in reference to the centerpoint
% of those two arrays
% absolute is the x,y distance of this centerpoint from the reference
% centerpoint
% in this case, W 01. this keeps the maps centered at the same point
% between deployments

load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WE\dep\SOCAL_W_03_WE_harp4chParams');
hydLoc{1} = recLoc;
clear recLoc
load('F:\Tracking\Instrument_Orientation\SOCAL_W_03\SOCAL_W_03_WS\dep\SOCAL_W_03_WS_harp4chParams');
hydLoc{2} = recLoc;

h0_1 = mean([hydLoc{1};hydLoc{2}]);
h0_2 = mean([33.53748, -120.24918, 1251.6757; 33.53236, -120.25423, -1249.5326]);

[absolute(1), absolute(2)] = latlon2xy_wgs84(h0_1(1),h0_1(2),h0_2(1),h0_2(2));
save('F:\Tracking\prop\SOCAL_W_03\SOCAL_W_03_4ch_absolute_m','absolute','h0_2');




