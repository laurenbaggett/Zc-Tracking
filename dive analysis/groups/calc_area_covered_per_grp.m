% calc_area_covered_per_grp
% 05/07/2024 LMB 2023a
% fit an ellipsoid to the points (eigendecomposition), calculate the area

df = dir('F:\Tracking\Erics_detector\SOCAL_W_05\cleaned_tracks');

for i = 3:length(df)

    myFile = dir([df(i).folder,'\',df(i).name,'\*whale.mat']); % load the folder name
    trackNum = extractAfter(myFile(1).folder,'cleaned_tracks\'); % grab the track num for naming later
    load(fullfile([myFile(1).folder,'\',myFile(1).name])); % load the file

    for b = 1:numel(whale) % remove any fields that are 0x0
        if height(whale{b}) < 2
            whale{b} = [];
        end
    end
    whale(cellfun('isempty',whale)) = []; % remove any empty fields

    % combine all points from all whales
    allWhaleSmooth = [];
    for wn = 1:numel(whale)
        allWhaleSmooth = vertcat(whale{wn}.wlocSmooth,allWhaleSmooth);
    end

    % calculate an ellipsoid that best encompasses the points
    mu = mean(allWhaleSmooth,1); % define the mean
    X0 = bsxfun(@minus, allWhaleSmooth, mu); % subtract the mean from each value

    % scale the size of the ellipse based on standard deviatioon
    STD = 2;
    conf = 2*normcdf(STD)-1; % our confidence interval, 0.95ish
    scale = chi2inv(conf,3); % inverse chi-squared with dof=dimensions

    Cov = cov(X0)*scale; % scale covariance matrix of normalized input 

    % eigen decomposition [sorted by eigen values]
    [V, D] = eig(Cov); % outputs matrix of eigenvalues (D) and eigenvectors (V)
    % A*V = V*D (definition of an eigendecomposition!)
    [D, order] = sort(diag(D), 'descend'); % sort the diagonal matrix (eigenvalues) by descending order
    D = diag(D); % move them back into a diagonal matrix
    V = V(:, order); % match the corresponding eigenvectors by index

    t = linspace(0,2*pi,100); % generates 100 linearly spaced points between 0 and 2pi
    e = [cos(t) ; sin(t); 0*t]; % unit circle
    VV = V*sqrt(D); % scale eigenvectors by sqrt eigenvalues
    e = bsxfun(@plus, VV*e, mu'); % put the ellipse that we just computed back into its original space

    % plot cov and major/minor axes
    figure(3)
    plot3(e(1,:), e(2,:),e(3,:),'Color','b');
    hold on
    plot3(allWhaleSmooth(:,1),allWhaleSmooth(:,2),allWhaleSmooth(:,3),'o')
    hold off
    grid on

    area = area3D(e(1,:),e(2,:),e(3,:))

    % % calculate the area of the elipse
    % ellipse_params = fit_ellipse(e(1,:),e(2,:));
    % a = ellipse_params.a;
    % b = ellipse_params.b;
    % area = pi*a*b;

    disp(['Area of the ellipse: ',num2str(area)]);

    saveas(gcf,[df(i).folder,'\',df(i).name,'\',trackNum,'_area_plot.fig'])


end
