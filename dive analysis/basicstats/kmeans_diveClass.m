%% kmeans_diveClass

% clustering to determine delineations for dive classes
a = dir('F:\Erics_detector\SOCAL_H_72\cleaned_tracks');
b = dir('F:\Erics_detector\SOCAL_H_73\cleaned_tracks');
c = dir('F:\Erics_detector\SOCAL_H_74\cleaned_tracks');
xa = [];
xb = [];
xc = [];

for i = 3:length(a)
    
    myFile = dir([a(i).folder,'\',a(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\z_stats.mat']));
    z_stats = z_stats';

    for wn = 1:size(z_stats,1)
        v = z_stats(wn,1:3);
        xa = vertcat(xa,v);
    end
    
end

for i = 3:length(b)
    
    myFile = dir([b(i).folder,'\',b(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\z_stats.mat']));
    z_stats = z_stats';

    for wn = 1:size(z_stats,1)
        v = z_stats(wn,1:3);
        xb = vertcat(xb,v);
    end
    
end

for i = 3:length(c)
    
    myFile = dir([c(i).folder,'\',c(i).name,'\z_stats.mat']); % load the folder name
    load(fullfile([myFile.folder,'\z_stats.mat']));
    z_stats = z_stats';

    for wn = 1:size(z_stats,1)
        v = z_stats(wn,1:3);
        xc = vertcat(xc,v);
    end
    
end

X = vertcat(xa,xb,xc);
% visualize data to see how many clusters we should look for
scatter3(X(:,1),X(:,2),X(:,3))
xlabel('min depth')
ylabel('max depth')
zlabel('change in depth')

% clustering

classes = kmeans(X,3);
scatter3(X(:,1),X(:,2),X(:,3),50,classes,'filled')
xlabel('min depth')
ylabel('max depth')
zlabel('change in depth')
% this clustering approach doesn't make a ton of sense, since some sites
% are deeper than others
% the deployments are clustering instead of track type for 2 and 3

% try again, no max depth
classes = kmeans(X(:,[3 1]),3);
scatter(X(:,3),X(:,1),50,classes,'filled')
ylabel('min depth')
xlabel('change in depth')
set(gca,'YDir','reverse')

% try again, cluster only using change in depth!
classes = kmeans(X(:,3),3);
scatter(1:size(X,1),X(:,3),50,classes,'filled')
xlabel('index')
ylabel('change in depth')

% consult alba and simone to see what they think, I think this supports my
% hypothesis pretty well
