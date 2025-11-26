%% calculate_descent_angle

deps = {'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75', ...
    'SOCAL_E_63', 'SOCAL_N_68', ...
    'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05'};

spd = 60*60*24;
thetaAll = []; % preallocate for angles

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',char(deps(j)),'\cleaned_tracks\track*']); % directory of folders containing files

    if deps{j} == 'SOCAL_H_72'
        h0 = [32.8593100000000 -119.140695000000 -1256.07870000000];
    elseif deps{j} == 'SOCAL_H_73'
        h0 = [32.8589500000000 -119.141195000000 -1249.92045000000];
    elseif deps{j} == 'SOCAL_H_74'
        h0 = [32.8607600000000 -119.140600000000 -1338.76150000000];
    elseif deps{j} == 'SOCAL_H_75'
        h0 = [32.8586850000000 -119.141395000000 -1251.92185000000];
    elseif deps{j} == 'SOCAL_E_63'
        h0 = [32.6575850000000 -119.482630000000 -1327.84580000000];
    elseif deps{j} == 'SOCAL_N_68'
        h0 = [32.3673350000000 -118.570330000000 -1340.92205000000];
    elseif deps{j} == 'SOCAL_W_01'
        h0 = [33.5349200000000 -120.251705000000 -1250.60415000000];
    elseif deps{j} == 'SOCAL_W_02'
        h0 = [33.5341950000000 -120.249605000000 -1237.07150000000];
    elseif deps{j} == 'SOCAL_W_03'
        h0 = [33.5347950000000 -120.249835000000 -1243.49240000000];
    elseif deps{j} == 'SOCAL_W_04'
        h0 = [33.5353900000000 -120.252660000000 -1265.82690000000];
    elseif deps{j} == 'SOCAL_W_05'
        h0 = [33.5370150000000 -120.252915000000 -1292.41045000000];
    end

    for i = 1:length(df) % for each track

        myFile = dir([df(i).folder,'\',df(i).name,'\*turns2.mat']); % load the folder name

        if ~isempty(myFile) % if we have a initial descent whale

            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
            myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
            myFile = dir([df(i).folder,'\',df(i).name,'\*distFromSeafloor.mat']); % load the folder name
            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file


            initwn = find(~isnan(turns)); % find which whale is intial descent

            for k = 1:length(initwn) % for each whale initially descending

                wloc = whale{initwn(k)}.wlocSmooth(1:turns(initwn(k)),:);
                wloc(:,3) = wloc(:,3) + h0(3);

                v = diff(wloc); % calculate descent vector
                theta = rmmissing(rad2deg(atan2(v(:,3),(sqrt(v(:,1).^2 + v(:,2).^2))))); % calculate angle
                thetaAll = [thetaAll;theta]; % save angles

            end % close loop for initial descent whales

        end % close loop for turns file

    end % close loop for each track

end % close loop for each deployment

% calculate the mean and standard deviation
thetaMean = mean(thetaAll);
thetaMedian = median(thetaAll);
thetaSD = std(thetaAll);

figure
histogram(thetaAll,'normalization','pdf')
hold on
plot(xi,f,'linewidth',2,'color','r')

[f, xi] = ksdensity(thetaAll); % fit density curve
[pks, locs] = findpeaks(f); % find peaks
modes = xi(locs); % grab the modal values

wind = 30;
stdevs = zeros(size(modes));
for i = 1:length(modes)
    moderange = modes(i) + [-wind, wind];
    datarange = thetaAll(thetaAll >= moderange(1) & thetaAll <= moderange(2));
    stdevs(i) = std(datarange);
end
