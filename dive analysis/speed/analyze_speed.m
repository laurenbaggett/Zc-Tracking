%% analyze_speed

% load in data, make some visualizations

% deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};
% deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};
% deps = {'SOCAL_E_63'};
deps = {'SOCAL_N_68'};

mSp = [];
class = [];

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks\track*']);

    for i = 1:length(df)
        
        myFile = dir([df(i).folder,'\',df(i).name,'\*distSpd.mat']); % load the folder name
        trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
        myFile = dir([df(i).folder,'\',df(i).name,'\*z_stats.mat']); % load the folder name
        load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

        
        for wn = 1:size(medianSpd)
            mSp = [mSp,medianSpd(wn)];
            class = [class,z_stats(6,wn)];
        end

    end

end

figure
histogram(mSp,10)

figure
histogram(class)

firstidx = find(class==1);
secondidx = find(class==2);
thirdidx = find(class==3);
fourthidx = find(class==4);

figure
histogram(mSp(firstidx))
figure
histogram(mSp(secondidx))
figure
histogram(mSp(thirdidx))
figure
histogram(mSp(fourthidx))

figure
scatter(firstidx,mSp(firstidx),50,[0 0.4470 0.7410])
hold on
scatter(secondidx,mSp(secondidx),50,[0.8500 0.3250 0.0980])
scatter(thirdidx,mSp(thirdidx),50,[0.4660 0.6740 0.1880])
scatter(fourthidx,mSp(fourthidx),50,[0 0 0])

% plot initial descent vs everything else
elseidx = find(class~=1);

figure
scatter(firstidx,mSp(firstidx),50,[0 0.4470 0.7410])
hold on
scatter(elseidx,mSp(elseidx),50,[0.8500 0.3250 0.0980])

figure
histogram(mSp(firstidx),'facecolor',[0 0.4470 0.7410])
figure
histogram(mSp(elseidx),'facecolor',[0.8500 0.3250 0.0980])


%%
