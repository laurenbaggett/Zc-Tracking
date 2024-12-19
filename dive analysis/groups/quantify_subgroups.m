%% quantify_subgroups
% LMB 12/19/24 2023a
%% a new approach based on clustering using the average linkage method

deps = {'SOCAL_W_01','SOCAL_W_02','SOCAL_W_03','SOCAL_W_04','SOCAL_W_05', ...
    'SOCAL_E_63','SOCAL_N_68',...
    'SOCAL_H_72','SOCAL_H_73','SOCAL_H_74','SOCAL_H_75'};

subgroups = [];
spd = 60*60*24;

for j = 1:length(deps)

    df = dir(['F:\Tracking\Erics_detector\',deps{j},'\cleaned_tracks\track*']); % directory of folders containing files
    spd = 60*60*24;

    for i = 1:length(df) % for each track

        myFile = dir([df(i).folder,'\',df(i).name,'\*distBtwnWhales.mat']); % load the folder name

        if size(myFile,1)>0

            trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
            myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
            load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

            for b = 1:numel(whale) % remove any fields that are 0x0
                if size(whale{b},2) < 15
                    whale{b} = [];
                elseif length(rmmissing(whale{b}.wlocSmooth(:,1))) < 1
                    whale{b} = [];
                end
            end
            whale(cellfun('isempty',whale)) = []; % remove any empty fields

            if numel(whale)>=2 % if there are at least two whales

                for wn = 1:numel(whale) % get space and time together into one struct
                    start_times(wn) = whale{wn}.TDet(1);
                    end_times(wn) = whale{wn}.TDet(end);
                end

                distance_matrix = zeros(numel(whale),numel(whale)); % preallocate
                overlap_matrix = zeros(numel(whale),numel(whale)); % preallocate for overlap

                for k = 1:numel(whale)

                    for m = k+1:numel(whale)
                        % if these whales are recorded within the same time
                        % period of each other
                        % let's say, 10 minutes
                        if (start_times(k)-(600/spd) < end_times(m)+(600/spd)) && (end_times(k)+(600/spd) > start_times(m)-(600/spd))
                            overlap_matrix(k, m) = 1;
                            overlap_matrix(m, k) = 1;  % make it symmetric
                        end

                    end
                end

                distance_threshold = 1000; % 1 km threshold
                lg = 10000; % unreasonable number for time non overlapping

                for k = 1:numel(whale)
                    for m = k+1:numel(whale)
                        if overlap_matrix(k,m) == 1 % only those that temporally overlap
                            [~, dist] = dsearchn(rmmissing(whale{k}.wlocSmooth),rmmissing(whale{m}.wlocSmooth));
                            dist = nanmean(dist);
                            distance_matrix(k,m) = dist;
                            distance_matrix(m,k) = dist; % symmetric
                        elseif overlap_matrix(k,m) == 0
                            distance_matrix(k,m) = lg;
                            distance_matrix(m,k) = lg;
                            lg = 2*lg; % increase in case this happens again this ends up in a different group
                        end
                    end
                end

                Z = linkage(distance_matrix,'average');
                
                % assign each whale to a cluster
                cluster_assn = cluster(Z,'cutoff',distance_threshold,'criterion','distance');

                % visualize this, if you want
                figure(1)
                dendrogram(Z)

                total_whales = length(cluster_assn);
                num_grps = length(unique(cluster_assn));
                mean_grps = mean(histcounts(cluster_assn));
                subgroups = [subgroups;[total_whales,num_grps,mean_grps]];

            end

        end

    end

end

% make some figures to visualize this
figure
scatter3(subgroups(:,1),subgroups(:,2),subgroups(:,3))

figure
subplot(1,3,1)
histogram(subgroups(:,1))
title('Total # of Whales')
subplot(1,3,2)
histogram(subgroups(:,2))
title('Number of Subgroups')
subplot(1,3,3)
histogram(subgroups(:,3))
title('Mean # of Whales Per Subgroup')

figure
boxplot(subgroups(:,1),subgroups(:,2))

figure
hist3(subgroups(:,1:2))
xlabel('total # whales')
ylabel('# subgroups')
zlim([1 250])

figure
hist3(subgroups(:,2:3))
xlabel('# subgroups')
ylabel('mean # whales/subgroup')
zlim([1 250])

figure
scatter(subgroups(:,1),subgroups(:,2))

[n,edges] = hist3(subgroups(:,1:2),{1:1:8 1:1:6});
cmap = cmocean('dense');

figure
tiledlayout(1,2,'tilespacing','compact')
nexttile
% subplot(1,2,1)
h = imagesc(edges{1},edges{2},n)
set(h,'alphadata',n>0)
c = colorbar
colormap(cmap)
xlabel('Total # Whales per Encounter')
ylabel('# of Subgroups')
ylabel(c,'Counts')
yticks([1:1:6])
% subplot(1,2,2)
nexttile
histogram(subgroups(:,3),[1:1:6],'facecolor',cmap(60,:))
xticks([1:1:6])
xlabel('Mean # Whales per Subgroup')
ylabel('Frequency')


[n,edges] = hist3(subgroups(:,2:3),{1:1:10 1:1:10});
cmap = cmocean('dense');

figure
imagesc(edges{2},edges{1},n')
colorbar
colormap(cmap)
ylabel('# subgroups')
xlabel('mean # whales/subgroup')

figure
histogram(subgroups(:,3))

figure
subplot(1,2,1)
scatter(subgroups(:,2),subgroups(:,1))
subplot(1,2,2)
scatter(subgroups(:,2),subgroups(:,3))






