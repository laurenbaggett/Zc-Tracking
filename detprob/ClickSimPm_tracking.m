function [sumsim,sumdet,fprob,xline,yline,xdetall,ydetall] = ...
    ClickSimPm_tracking(a1,a2,...
    diveAlt1_itr_mean, diveAlt1_itr_std, diveAlt2_itr_mean, diveAlt2_itr_std, ...
    diveType1Percent_itr, maxDiveDepth_mean, maxDiveDepth_std, ...
    SL_mean,SL_std,rr_int1,rr_int2,minAltitude, ...
    descAngle_mean,descAngle_std,clickStart_mean,clickStart_std, ...
    directivity,minAmpSide_mean, ...
    minAmpBack_mean,botAngle_std,descentPerc, ...
    binVec,n,N,maxRange,thresh,RLbins,offset,grid,absolute)
%Based on Kait Frasier ClickMethod
% JAH made function 6-2022
% global p
% n = p.n; N = p.N; maxRange = p.maxRange; thresh = p. thresh; RLbins = p. RLbins;

grdsimall = zeros(81,81,n); % save simulated counts
grddetall = zeros(81,81,n); % save detected counts

for itr_n = 1:n  % number of simulations loop 
    if rem(itr_n,100) == 0
        fprintf('Click TL computation %d of %d\n', itr_n, n)
    end

    %%%%% Location Computation %%%%%
    % rand location
    randVec = ceil(rand(2,N)'.*repmat([2*maxRange, 2*maxRange], [N, 1]))...
        - repmat([maxRange, maxRange], [N, 1]);

    % for the FIRST 4 channel array
    x1 = offset(1,1);
    y1 = offset(1,2);
    % I want the center of the two 4 channels to be (0,0), so I'll need to offset
    % by the location in m of each 4 channel relative to that before
    % converting to polar coordinates.
    randVec2 = [randVec(:,1)+x1, randVec(:,2)+y1];
    % now convert these to polar
    [theta, rho] = cart2pol(randVec2(:,1),randVec2(:,2));  % convert to polar coord.
    thetaDeg = make360(theta*180/pi);
    
    % go from angle to ref indices
    [angleRef,radRef] = angle_ref_comp(thetaDeg,rho,a1.thisAngle);

    %%%%% Depth Computation %%%%%
    % Compute bottom depth at each randomly selected point
    bottomDepthByPoint = a1.botDepthSort(sub2ind(size(a1.botDepthSort),...
        angleRef,max(1,round(radRef/rr_int1))));

    % For each point, is target at bottom or midwater dive?
    indexDiveAlt1 = (1:round(length(angleRef)*diveType1Percent_itr(itr_n)))';
    indexDiveAlt2 = (max(indexDiveAlt1)+1:length(angleRef))';

    % calculate vector of type 1 altitudes and
    % convert to depth
    diveAlt1 = diveAlt1_itr_mean(itr_n) + diveAlt1_itr_std(itr_n)...
        *randn(size(indexDiveAlt1));
    diveAlt2 = diveAlt2_itr_mean(itr_n) + diveAlt2_itr_std(itr_n)...
        *randn(size(indexDiveAlt2));
    diveAlt = [diveAlt1;diveAlt2];
    diveDepthRef = min(bottomDepthByPoint - diveAlt,...
        bottomDepthByPoint - minAltitude); % This enforces minimum altitude
    % by taking the minimum of these two values. It
    % would be nicer to have it resample things
    % that are too deep, but this creates a
    % circular situation when combined with the
    % correction below for maximum dive depth...

    % Replace any target depths that are larger
    % than the maximum dive depth by sampling from
    % a distribution
    tooDeep = find(diveDepthRef>maxDiveDepth_mean(itr_n));
    diveDepthRef(tooDeep) = []; % maxDiveDepth_mean(itr_n) + maxDiveDepth_std(itr_n)*randn(size(tooDeep));

    % % Assign some dives from each set to descent
    % phase
    % Choose a depth between start of clicking and destination depth
    % determine off-axis angle
    descentIdx1 = (1:round(descentPerc(itr_n,1)*length(diveAlt1)))';
    descentIdx2 = (min(indexDiveAlt2)+1)+(1:round(descentPerc(itr_n,1)*length(diveAlt2)))';
    descentIdx = [descentIdx1;descentIdx2];
    clickStartVec = clickStart_mean(itr_n,1) + clickStart_std(itr_n,1).*randn(size(descentIdx));

    % If there are clickStarts above the sea surface, put them below it.
    flyingWhaleIdx = find(clickStartVec<1);
    while ~isempty(flyingWhaleIdx)
        clickStartVec(flyingWhaleIdx) = clickStart_mean(itr_n,1) + clickStart_std(itr_n,1).*randn(size(flyingWhaleIdx));
        flyingWhaleIdx = find(clickStartVec<1);
    end

    % Use a uniform random number distribution to
    % choose a depth between start of clicking and
    % target depth for each point in descent phase.
    dFactor = rand(size(descentIdx));
    descentDelta = dFactor.* (diveDepthRef(descentIdx,:) - clickStartVec);
    diveDepthRef(descentIdx,1) = clickStartVec + descentDelta;

    %%%%% Beam Angle Computation %%%%%
    % Assign random beam orientation in horizontal (all orientations equally likely)
    randAngleVec = ceil(rand(size(rho)).*359);
    % Compute vertical component of shift between animal and sensor (sd =
    % sensor depth)
    dZ = abs(a1.sd - diveDepthRef);
    zAngle_180 = ceil(abs(atand(dZ./radRef))+ (botAngle_std(itr_n,1)*randn(size(dZ))));
    % assign descent angle to descending portion
    zAngle_180(descentIdx,1) = ceil(abs(atand(dZ(descentIdx,:)./radRef(descentIdx,:))) -...
        descAngle_mean(itr_n,1) + (descAngle_std(itr_n,1).*randn(size(descentIdx))));

    zAngle = make360(zAngle_180); % wrap
    % clear zAngle_180

    %%%%% Transmission loss (TL) Computation %%%%%
    % Note, due to computation limitations, directivity does not vary by individual.
    % The beam pattern is considered to be the same for all individuals within an iteration.
    % Compute beam pattern:
    [beam3D,~] = odont_beam_3D_Pm(directivity(itr_n,1), [minAmpSide_mean(itr_n,1),minAmpBack_mean(itr_n,1)]);

    % Using vertical and horizontal off axis components, compute beam
    % related transmission loss
    beamTL = beam3D(sub2ind(size(beam3D),zAngle, randAngleVec));

    %%%%% Transmission Loss Loop %%%%%

    % Compute location of this animal in the transmission loss matrix:
    % Find which row you want to look at:
    locTL = a1.rd_all(:,:,angleRef);
    diveDepthRef3D = reshape(round(diveDepthRef),1,1,numel(diveDepthRef));
    [~,thisDepthIdx] = min(abs(bsxfun(@minus,locTL,diveDepthRef3D)));
    clear locTL diveDepthRef3D % trying to save on memory
    thisDepthIdx = squeeze(thisDepthIdx);

    % record the distance related portion of this transmission loss
    linearInd = sub2ind(size(a1.sortedTLVec),thisDepthIdx,ceil(radRef./rr_int1),angleRef);
    distTL = a1.sortedTLVec(linearInd);

    % Compute variation to add to source level
    SL_adj = SL_std(itr_n,1)*randn(size(zAngle));
    % Add up all the sources of TL
    RL1 = SL_mean(itr_n,1) + SL_adj - beamTL - distTL;


 % for the SECOND 4 channel array
    x2 = offset(2,1);
    y2 = offset(2,2);
    % I want the center of the two 4 channels to be (0,0), so I'll need to offset
    % by the location in m of each 4 channel relative to that before
    % converting to polar coordinates.
    randVec3 = [randVec(:,1)+x2, randVec(:,2)+y2];
    % now convert these to polar
    [theta, rho] = cart2pol(randVec3(:,1),randVec3(:,2));  % convert to polar coord.
    thetaDeg = make360(theta*180/pi);
    
    % for the FIRST 4 channel array
    % go from angle to ref indices
    [angleRef,radRef] = angle_ref_comp(thetaDeg,rho,a1.thisAngle);

    %%%%% Depth Computation %%%%%
    % Compute bottom depth at each randomly selected point
    bottomDepthByPoint = a2.botDepthSort(sub2ind(size(a2.botDepthSort),...
        angleRef,max(1,round(radRef/rr_int2))));

    % For each point, is target at bottom or midwater dive?
    indexDiveAlt1 = (1:round(length(angleRef)*diveType1Percent_itr(itr_n)))';
    indexDiveAlt2 = (max(indexDiveAlt1)+1:length(angleRef))';

    % calculate vector of type 1 altitudes and
    % convert to depth
    diveAlt1 = diveAlt1_itr_mean(itr_n) + diveAlt1_itr_std(itr_n)...
        *randn(size(indexDiveAlt1));
    diveAlt2 = diveAlt2_itr_mean(itr_n) + diveAlt2_itr_std(itr_n)...
        *randn(size(indexDiveAlt2));
    diveAlt = [diveAlt1;diveAlt2];
    diveDepthRef = min(bottomDepthByPoint - diveAlt,...
        bottomDepthByPoint - minAltitude); % This enforces minimum altitude
    % by taking the minimum of these two values. It
    % would be nicer to have it resample things
    % that are too deep, but this creates a
    % circular situation when combined with the
    % correction below for maximum dive depth...

    % Replace any target depths that are larger
    % than the maximum dive depth by sampling from
    % a distribution
    % tooDeep = find(diveDepthRef>maxDiveDepth_mean(itr_n));
    diveDepthRef(tooDeep) = []; % remove for now instead of resampling since we have 
    % multiple receivers we're testing this on % maxDiveDepth_mean(itr_n) + maxDiveDepth_std(itr_n)*randn(size(tooDeep));

    % % Assign some dives from each set to descent
    % phase
    % Choose a depth between start of clicking and destination depth
    % determine off-axis angle
    descentIdx1 = (1:round(descentPerc(itr_n,1)*length(diveAlt1)))';
    descentIdx2 = (min(indexDiveAlt2)+1)+(1:round(descentPerc(itr_n,1)*length(diveAlt2)))';
    descentIdx = [descentIdx1;descentIdx2];
    clickStartVec = clickStart_mean(itr_n,1) + clickStart_std(itr_n,1).*randn(size(descentIdx));

    % If there are clickStarts above the sea surface, put them below it.
    flyingWhaleIdx = find(clickStartVec<1);
    while ~isempty(flyingWhaleIdx)
        clickStartVec(flyingWhaleIdx) = clickStart_mean(itr_n,1) + clickStart_std(itr_n,1).*randn(size(flyingWhaleIdx));
        flyingWhaleIdx = find(clickStartVec<1);
    end

    % Use a uniform random number distribution to
    % choose a depth between start of clicking and
    % target depth for each point in descent phase.
    dFactor = rand(size(descentIdx));
    descentDelta = dFactor.* (diveDepthRef(descentIdx,:) - clickStartVec);
    diveDepthRef(descentIdx,1) = clickStartVec + descentDelta;

    %%%%% Beam Angle Computation %%%%%
    % Assign random beam orientation in horizontal (all orientations equally likely)
    randAngleVec = ceil(rand(size(rho)).*359);
    % Compute vertical component of shift between animal and sensor (sd =
    % sensor depth)
    dZ = abs(a2.sd - diveDepthRef);
    zAngle_180 = ceil(abs(atand(dZ./radRef))+ (botAngle_std(itr_n,1)*randn(size(dZ))));
    % assign descent angle to descending portion
    zAngle_180(descentIdx,1) = ceil(abs(atand(dZ(descentIdx,:)./radRef(descentIdx,:))) -...
        descAngle_mean(itr_n,1) + (descAngle_std(itr_n,1).*randn(size(descentIdx))));

    zAngle = make360(zAngle_180); % wrap
    % clear zAngle_180

    %%%%% Transmission loss (TL) Computation %%%%%
    % Note, due to computation limitations, directivity does not vary by individual.
    % The beam pattern is considered to be the same for all individuals within an iteration.
    % Compute beam pattern:
    [beam3D,~] = odont_beam_3D_Pm(directivity(itr_n,1), [minAmpSide_mean(itr_n,1),minAmpBack_mean(itr_n,1)]);

    % Using vertical and horizontal off axis components, compute beam
    % related transmission loss
    beamTL = beam3D(sub2ind(size(beam3D),zAngle, randAngleVec));

    %%%%% Transmission Loss Loop %%%%%

    % Compute location of this animal in the transmission loss matrix:
    % Find which row you want to look at:
    locTL = a2.rd_all(:,:,angleRef);
    diveDepthRef3D = reshape(round(diveDepthRef),1,1,numel(diveDepthRef));
    [~,thisDepthIdx] = min(abs(bsxfun(@minus,locTL,diveDepthRef3D)));
    clear locTL diveDepthRef3D % trying to save on memory
    thisDepthIdx = squeeze(thisDepthIdx);

    % record the distance related portion of this transmission loss
    linearInd = sub2ind(size(a2.sortedTLVec),thisDepthIdx,ceil(radRef./rr_int2),angleRef);
    distTL = a2.sortedTLVec(linearInd);

    % Compute variation to add to source level
    SL_adj = SL_std(itr_n,1)*randn(size(zAngle));
    % Add up all the sources of TL
    RL2 = SL_mean(itr_n,1) + SL_adj - beamTL - distTL;


    % keep only the ones heard on both arrays
    clear isheard
    isheard(:,1) = RL1>=thresh;
    isheard(:,2) = RL2>=thresh;
    notHeard =(isheard(:, 1) == 0 & isheard(:, 2) == 0) | (isheard(:, 1) ~= isheard(:, 2));
    isheard(notHeard,:) = 0;
    isheard = isheard(:,1);

    % convert to cartesian coordinates
    % remove the offset, back to centerpoint of 2 arrays
    x = rho.*cos(theta) - x2;
    y = rho.*sin(theta) - y2;
    % move these to reference an absolute centerpoint that's constant
    % between deployments
    % x = x + absolute(1);
    % y = y + absolute(2);
    
    % to plot a birdseye view of what was heard and
    % what wasn't:

        % figure(213)
        % plot(x,y,'*k')
        % hold on
        % plot(x(isheard),y(isheard),'*r')
        % legend({'simulated', 'detected'})
        % title('cartesian')

        % figure(214)
        % plot(lon_all,lat_all,'*k')
        % hold on
        % plot(lon_heard,lat_heard,'*r')
        % legend({'simulated', 'detected'})
        % title('geographic')

    % split these detections into our n by n grid squares
    % default grid value for LMB is 100m :)
    xline = [-4000:grid:4000]; % x limits, 1000 m bins
    yline = [-4000:grid:4000]'; % y limits 1000 m bins

    grdsim = zeros(length(xline),length(yline)); % final gridded zeros, initialized
    % find the simulated values for that grid, add them
    for j = 1:length(x) % for each point
        xidx = find(x(j) > xline(1:end-1) & x(j) < xline(2:end)); % find which bin x value falls in
        yidx = find(y(j) > yline(1:end-1) & y(j) < yline(2:end)); % find which bin y value falls in
        grdsim(xidx,yidx) = grdsim(xidx,yidx)+1; % make the bin value 1
    end
    grdsimall(:,:,itr_n) = grdsim;

    grddet = zeros(length(xline),length(yline)); % final gridded zeros, initialized
    xdet = x(isheard);
    ydet = y(isheard);
    % find the detected values for that grid, add them
    for j = 1:length(xdet) % for each point
        xidx = find(xdet(j) > xline(1:end-1) & xdet(j) < xline(2:end)); % find which bin x value falls in
        yidx = find(ydet(j) > yline(1:end-1) & ydet(j) < yline(2:end)); % find which bin y value falls in
        grddet(xidx,yidx) = grddet(xidx,yidx)+1; % make the bin value 1
    end
    grddetall(:,:,itr_n) = grddet;
    xdetall{itr_n} = xdet;
    ydetall{itr_n} = ydet;

    % % plot the probability for this iteration
    % grdprob = grddet./grdsim;
    % figure(214)
    % imagesc(xline, yline, grdprob)% grdf)
    % colormap(hot)

end

% take all looped simulations, output calculated probability
sumsim = sum(grdsimall,3);
sumdet = sum(grddetall,3);
fprob = sumdet./sumsim;

figure(215)
imagesc(xline,yline,fprob)
colormap(hot)
colorbar
set(gca,'YDir','normal')
hold on
plot(offset(1,1),offset(1,2),'s','markeredgecolor','white','markerfacecolor',[0.6 0.6 0.6],'markersize',6);
plot(offset(2,1),offset(2,2),'s','markeredgecolor','white','markerfacecolor',[0.6 0.6 0.6],'markersize',6);


