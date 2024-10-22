% calc_lane_distance

df = dir(['F:\Tracking\Erics_detector\SOCAL_W_05\cleaned_tracks\track*']); % directory of folders containing files
% rerun me in the morning to see what's breaking :)
% initiate an array to hold mean values
spd = 60*60*24;
depMeans = [];
depMax = [];
depMin = [];
depSlopes = [];
depTNums = [];
depWhl1 = [];
depWhl2 = [];

for i = 1:length(df) % for each track

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    myFile = dir([df(i).folder,'\',df(i).name,'\*distSpd.mat']); % load the folder name
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file
    
    epty = [];
    for b = 1:numel(whale) % remove any fields that are 0x0
        if height(whale{b}) < 20
            whale{b} = [];
            epty = horzcat(epty,b);
        end
    end
    for b = 1:length(epty)
        bepty = fliplr(epty);
        if bepty(b) <= length(totalDist)
        totalDist(bepty(b)) = [];
        end
    end
    whale(cellfun('isempty',whale)) = []; % remove any empty fields
    % totalDist(epty) = [];
    % for t = 1:length(epty)
    % totalDist(epty(t)) = [];
    % end

    if length(whale) ~= 1 % if we have more than one whale

        laneDist = [];
        laneMeans = [];
        laneMax = [];
        laneMin = [];
        slope = [];
        whl1 = [];
        whl2 = [];

        % interpolate
        for wn = 1:numel(whale)
            % interpolate in space
            % one point per meter? round down
            int = floor(totalDist(wn));
            whaleI{wn}.wlocSmooth = interparc(int, whale{wn}.wlocSmooth(:,1),whale{wn}.wlocSmooth(:,2),whale{wn}.wlocSmooth(:,3));
        end

        np = nchoosek(1:length(whaleI),2); % find the pair combos

        % find the closest point between each pair combo
        for n = 1:height(np)

            whale1 = whaleI{np(n,1)};
            whale2 = whaleI{np(n,2)};

            % find the closest point between the two whales
            [idx, dst] = dsearchn(whale1.wlocSmooth,whale2.wlocSmooth);
            [closeDist, closeIdx] = min(dst);
            idx1 = idx(closeIdx);
            idx2 = closeIdx;

            % we have the indices of the closest points now!
            % calculate distance from that closest point to the edges of
            % each whale, regardless of time

            if idx1 < idx2 % if the first index is smaller
                if idx1 ~= 1
                    for j = 1:idx1 % calculates from end to start
                        d1(j) = sqrt(((whale1.wlocSmooth(idx1-(j-1),1)-whale2.wlocSmooth(idx2-(j-1),1))^2) + ...
                            ((whale1.wlocSmooth(idx1-(j-1),2)-whale2.wlocSmooth(idx2-(j-1),2))^2) + ...
                            ((whale1.wlocSmooth(idx1-(j-1),3)-whale2.wlocSmooth(idx2-(j-1),3))^2));
                    end
                    d1 = flip(d1); % flip so we go from start to end
                end
            elseif idx2 < idx1 % if the second index is smaller
                if idx2 ~= 1
                    for j = 1:idx2
                        d1(j) = sqrt(((whale1.wlocSmooth(idx1-(j-1),1)-whale2.wlocSmooth(idx2-(j-1),1))^2) + ...
                            ((whale1.wlocSmooth(idx1-(j-1),2)-whale2.wlocSmooth(idx2-(j-1),2))^2) + ...
                            ((whale1.wlocSmooth(idx1-(j-1),3)-whale2.wlocSmooth(idx2-(j-1),3))^2));
                    end
                    d1 = flip(d1); % flip so we go from start to end
                end
            elseif idx1 == idx2 % if indices are equal
                if idx1 == length(whale1.wlocSmooth) && idx2 == length(whale2.wlocSmooth) % the indices are at the end of the track
                    for j = 1:idx1
                        d1(j) = sqrt(((whale1.wlocSmooth(j,1)-whale2.wlocSmooth(j,1))^2) + ...
                            ((whale1.wlocSmooth(j,2)-whale2.wlocSmooth(j,2))^2) + ...
                            ((whale1.wlocSmooth(j,3)-whale2.wlocSmooth(j,3))^2));
                    end
                end
            end

            % if the remaining length in whale 1 is less than in whale 2
            if length(whale1.wlocSmooth(idx1:end,1)) < length(whale2.wlocSmooth(idx2:end,1))
                if length(whale1.wlocSmooth(idx1:end,1))-1 ~= 0 % if the idx isn't at the end already
                    for j = 1:length(whale1.wlocSmooth(idx1:end,1))-1 % go until the shorter end, minus one
                        d2(j) = sqrt(((whale1.wlocSmooth(idx1+(j),1)-whale2.wlocSmooth(idx2+(j),1))^2) + ...
                            ((whale1.wlocSmooth(idx1+(j),2)-whale2.wlocSmooth(idx2+(j),2))^2) + ...
                            ((whale1.wlocSmooth(idx1+(j),3)-whale2.wlocSmooth(idx2+(j),3))^2));
                        % whale1_lane(j,1) = whale1.wlocSmooth(idx1+(j),1);
                        % whale1_lane(j,2) = whale1.wlocSmooth(idx1+(j),2);
                        % whale1_lane(j,3) = whale1.wlocSmooth(idx1+(j),3);
                        % whale2_lane(j,1) = whale2.wlocSmooth(idx2+(j),1);
                        % whale2_lane(j,2) = whale2.wlocSmooth(idx2+(j),2);
                        % whale2_lane(j,3) = whale2.wlocSmooth(idx2+(j),3);
                    end
                end
            elseif length(whale2.wlocSmooth(idx2:end,1)) < length(whale1.wlocSmooth(idx1:end,1))
                if length(whale2.wlocSmooth(idx2:end,1))-1 ~= 0 % if the idx isn't at the end already
                    for j = 1:length(whale2.wlocSmooth(idx2:end,1))-1
                        d2(j) = sqrt(((whale1.wlocSmooth(idx1+(j),1)-whale2.wlocSmooth(idx2+(j),1))^2) + ...
                            ((whale1.wlocSmooth(idx1+(j),2)-whale2.wlocSmooth(idx2+(j),2))^2) + ...
                            ((whale1.wlocSmooth(idx1+(j),3)-whale2.wlocSmooth(idx2+(j),3))^2));
                        % whale1_lane(j,1) = whale1.wlocSmooth(idx1+(j),1);
                        % whale1_lane(j,2) = whale1.wlocSmooth(idx1+(j),2);
                        % whale1_lane(j,3) = whale1.wlocSmooth(idx1+(j),3);
                        % whale2_lane(j,1) = whale2.wlocSmooth(idx2+(j),1);
                        % whale2_lane(j,2) = whale2.wlocSmooth(idx2+(j),2);
                        % whale2_lane(j,3) = whale2.wlocSmooth(idx2+(j),3);
                    end
                end
            end

            if idx1 == 1 && idx2 == length(whale2.wlocSmooth) % if the first index is the start of the first whale and the second is the end of the second whale
                if idx2 < length(whale1.wlocSmooth)
                    for j = 1:idx2
                        d1(j) = sqrt(((whale1.wlocSmooth(idx1+(j-1),1)-whale2.wlocSmooth(idx2-(j-1),1))^2) + ...
                            ((whale1.wlocSmooth(idx1+(j-1),2)-whale2.wlocSmooth(idx2-(j-1),2))^2) + ...
                            ((whale1.wlocSmooth(idx1+(j-1),3)-whale2.wlocSmooth(idx2-(j-1),3))^2));
                    end
                elseif idx2 > length(whale1.wlocSmooth)
                    for j = 1:length(whale1.wlocSmooth)
                        d1(j) = sqrt(((whale1.wlocSmooth(idx1+(j-1),1)-whale2.wlocSmooth(idx2-(j-1),1))^2) + ...
                            ((whale1.wlocSmooth(idx1+(j-1),2)-whale2.wlocSmooth(idx2-(j-1),2))^2) + ...
                            ((whale1.wlocSmooth(idx1+(j-1),3)-whale2.wlocSmooth(idx2-(j-1),3))^2));
                    end
                end
            elseif idx2==1 && idx1==length(whale1.wlocSmooth) % if the second index is the start and the first is the end
                if idx1 < length(whale2.wlocSmooth)
                    for j = 1:idx1
                        d1(j) = sqrt(((whale1.wlocSmooth(idx1-(j-1),1)-whale2.wlocSmooth(idx2+(j-1),1))^2) + ...
                            ((whale1.wlocSmooth(idx1-(j-1),2)-whale2.wlocSmooth(idx2+(j-1),1))^2) + ...
                            ((whale1.wlocSmooth(idx1-(j-1),3)-whale2.wlocSmooth(idx2+(j-1),1))^2));
                    end
                elseif idx1 > length(whale2.wlocSmooth)
                    for j = 1:length(whale2.wlocSmooth)
                        d1(j) = sqrt(((whale1.wlocSmooth(idx1-(j-1),1)-whale2.wlocSmooth(idx2+(j-1),1))^2) + ...
                            ((whale1.wlocSmooth(idx1-(j-1),2)-whale2.wlocSmooth(idx2+(j-1),1))^2) + ...
                            ((whale1.wlocSmooth(idx1-(j-1),3)-whale2.wlocSmooth(idx2+(j-1),1))^2));
                    end
                end
            end

            if exist('d1','var') && exist('d2','var')
                laneDist{n} = horzcat(d1,d2)'; % save the lane distance values for this pair
            elseif exist('d1','var') && ~exist('d2','var')
                laneDist{n} = d1'; % save the lane distance values for this pair
            elseif exist('d2','var') && ~exist('d1','var')
                laneDist{n} = d2'; % save the lane distance values for this pair
            end

            % fit a line
            mdl = polyfit(1:length(laneDist{n}),laneDist{n},1);

            labelstr{1,n} = {['whale pair ', num2str(np(n,:))]};
            laneMeans = horzcat(laneMeans,mean(laneDist{n}));
            laneMax = horzcat(laneMax,max(laneDist{n}));
            laneMin = horzcat(laneMin,min(laneDist{n}));
            slope = horzcat(slope,mdl(1));
            whl1 = horzcat(whl1,np(n,1));
            whl2 = horzcat(whl2,np(n,2));

            clear d1; clear d2; clear d; clear mdl;

        end

        save([char(myFile.folder),'\',char(trackNum),'_laneDist.mat'],'laneDist','laneMeans','laneMax','laneMin','labelstr'); % save the whale struct
        depMeans = horzcat(depMeans,laneMeans);
        depMax = horzcat(depMax,laneMax);
        depMin = horzcat(depMin,laneMin);
        depTNums = horzcat(depTNums,repmat(string(trackNum),size(laneMax)));
        depWhl1 = horzcat(depWhl1,whl1);
        depWhl2 = horzcat(depWhl2,whl2);
        depSlopes = horzcat(depSlopes,slope);

        clear whale; clear whaleI; clear laneDist; clear labelstr; clear laneMeans, clear laneMax; clear laneMin;
        clear d1; clear d2; clear d; clear whale1; clear whale2
    end

end

depMeans = vertcat(depMeans,depMax,depMin,depSlopes,depTNums,depWhl1,depWhl2)';

save('F:\Tracking\Erics_detector\SOCAL_W_05\deployment_stats\SOCAL_W_05_laneDist.mat','depMeans');

% %% plot one
% 
% figure(1)
% hold on
% for k = 1:length(laneDist)
%     if height(laneDist{k}) ~= 0
%         plot(laneDist{k})
%     end
% end
% % datetick('x')
% ylabel('meters')
% legend(char(vertcat(labelstr{:})))
% 
% 
% sqrt(((844.9-698.14)^2) + ...
%     ((-234.5+167.5)^2) + ...
%     ((159.4-208.413)^2))
% 
% 
% 
% figure
% plot3(nan,nan,nan)
% % xlim([-200 1000])
% % ylim([-300 300])
% % zlim([0 200])
% view(-45,30)
% grid on
% hold on
% for j = 1:length(whale1_lane)
%     plot3(whale1_lane(1:j,1),whale1_lane(1:j,2),whale1_lane(1:j,3),'-o','color','red')
%     plot3(whale2_lane(1:j,1),whale2_lane(1:j,2),whale2_lane(1:j,3),'-o','color','blue')
%     view(45-(.05*j),30+(.05*j))
%     pause(.05)
% end
% 
% 
% figure
% xlim([0 600])
% ylim([0 300])
% ylabel('Distance Between Whale Pair')
% xlabel('Index')
% hold on
% for j = 1:length(laneDist{5})
%     plot(laneDist{5}(1:j),'color','black')
%     pause(.15)
% end