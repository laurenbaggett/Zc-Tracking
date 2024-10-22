%% recalc speed using only dive down

% load the whale struct
% load distSpd
trackNum = 'track330'

plot(whale{wn}.TDet,whale{wn}.wlocSmoothLatLonDepth(:,3))
find(whale{wn}.TDet<8319.854)
ed = 39
meanSpd(1,wn) = mean(spd(1:ed,wn))
deltaSpd(1,wn) = abs(max(spd(find(spd(1:ed,wn)),wn))) - abs(min(spd(find(spd(1:ed,wn)),wn)));
totalDist(1,wn) = sum(dist(1:ed,wn));

save(['F:\Erics_detector\SOCAL_H_74\cleaned_tracks\',trackNum,'\',trackNum,'_distSpd.mat'])