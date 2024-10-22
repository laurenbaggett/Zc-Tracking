%% diveDown_diveUp.m

% does diving down happen at a different speed than diving up does? let's
% find out!

clear all
close all

df = dir('F:\Erics_detector\SOCAL_H_72\cleaned_tracks\track*');

for i = 1:length(df)

    myFile = dir([df(i).folder,'\',df(i).name,'\*distSpd.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load speed calcs
    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load whale struct
    myFile = dir([df(i).folder,'\',df(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load z_stats

    downUp = []; % initialize to save these values
    down = zeros(size(spd));
    up = zeros(size(spd));

    for wn = 1:length(whale) % for each whale

        if ~isempty(whale{wn})

            if deltaSpd(1,wn)>=3 | max(spd(:,wn))>=3 % if the delta speed or spd value is suspicious, skip
                continue
            else
                depth = whale{wn}.wlocSmoothLatLonDepth(:,3);
                deltaDepth = diff(depth);

                negDeltaDepthIdx = find(deltaDepth<=0);
                posDeltaDepthIdx = find(deltaDepth>=0);

                downUp(1,wn) = mean(spd(negDeltaDepthIdx,wn));
                downUp(2,wn) = std(spd(negDeltaDepthIdx,wn));
                downUp(3,wn) = mean(spd(posDeltaDepthIdx,wn));
                downUp(4,wn) = std(spd(posDeltaDepthIdx,wn));
                downUp(5,wn) = z_stats(6,wn);

                down(negDeltaDepthIdx,wn) = spd(negDeltaDepthIdx,wn);
                up(posDeltaDepthIdx,wn) = spd(posDeltaDepthIdx,wn);

            end
        end
    end
    save([myFile.folder,'\upDown.mat'],'downUp','down','up')

end

%% analyze this, are they different?
close all
clear all

df = dir('F:\Erics_detector\SOCAL_H_72\cleaned_tracks\track*');
vals = [];

for i = 1:length(df)

    myFile = dir([df(i).folder,'\',df(i).name,'\*upDown.mat']); % load the folder name
    load(fullfile([myFile.folder,'\',myFile.name])); % load speed calcs
    trackNum = str2num(extractAfter(df(i).name,'track'));


    for wn = 1:size(downUp,2)
        if ~isnan(downUp(wn,1))
        v = [];
        v = horzcat(v,downUp(1,wn),downUp(2,wn),downUp(3,wn),downUp(4,wn),downUp(5,wn),trackNum,72);
        vals = vertcat(vals,v);
        end
    end 
end

% find the average, std of nonzero negative dives
negs = vals(find(vals(:,1)),1);
negs = rmmissing(negs);
negAvg = mean(negs);
negStd = std(negs);

% find the average, std of nonzero positive dives
poss = vals(find(vals(:,3)),3);
poss = rmmissing(poss);
posAvg = mean(poss);
posStd = std(poss);


%% plot this

% plot neg vel vs pos vel, color is dive class
type1 = vals(vals(:,5)==1,:);
type2 = vals(vals(:,5)==2,:);
type3 = vals(vals(:,5)==3,:);

figure
scatter(type1(:,1),type1(:,3),'color',[0 0.4470 0.7410])
hold on
scatter(type2(:,1),type2(:,3),'color',[0.8500 0.3250 0.0980])
scatter(type3(:,1),type3(:,3),'color',[0.4660 0.6740 0.1880])
h = plotEllipses([mean(type1(:,1)) mean(rmmissing(type1(:,3)))],[std(type1(:,2)) std(rmmissing(type1(:,4)))]); 
h.FaceColor = [0 0.4470 0.7410 0.15]; %4th value is undocumented: transparency
h.EdgeColor = [0 0.4470 0.7410]; 
h.LineWidth = 2; 
h = plotEllipses([mean(rmmissing(type2(:,1))) mean(rmmissing(type2(:,3)))],[std(rmmissing(type2(:,2))) std(rmmissing(type2(:,4)))]); 
h.FaceColor = [0.8500 0.3250 0.0980 0.15]; %4th value is undocumented: transparency
h.EdgeColor = [0.8500 0.3250 0.0980]; 
h.LineWidth = 2; 
h = plotEllipses([mean(rmmissing(type3(:,1))) mean(rmmissing(type3(:,3)))],[std(rmmissing(type3(:,2))) std(rmmissing(type3(:,4)))]); 
h.FaceColor = [0.4660 0.6740 0.1880 0.15]; %4th value is undocumented: transparency
h.EdgeColor = [0.4660 0.6740 0.1880]; 
h.LineWidth = 2; 
hold off
hold off
xlabel('Negative Velocity (m/s)')
ylabel('Positive Velocity (m/s)')


