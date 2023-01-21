% created January 20, 2023 by Samuel Fayad as a test repository to more familiarize myself with GitHub
% all of the code here-in will be created on the spot.

clc, clear, close all

%% upload images
[FILENAME_REF, PATHNAME_REF] = uigetfile('*.*');
ref = double(imread(strcat(PATHNAME_REF,'/',FILENAME_REF)));
[image_coords_j image_coords_i] = meshgrid(1:size(ref,2),1:size(ref,1));
[FILENAME_DEF, PATHNAME_DEF] = uigetfile('*.*','Select deformed images','Multiselect','on');
for image_ind = 1:length(FILENAME_DEF)
    def(:,:,image_ind) = double(imread(char(strcat(PATHNAME_DEF,'/',FILENAME_DEF(image_ind)))));
end

% load('example_data_temp.mat')

%% define ROI
figure
imagesc(uint8(ref)), colormap gray, axis equal
title('Draw ROI')
[~,j_px,i_px] = roipoly() ; % this has the option of other ROI types
%imagesc(uint8(ref)), colormap gray, axis equal
title('Draw Exclusion')
[~,j_px_exclude,i_px_exclude] = roipoly() ; % this has the option of other ROI types
%load('example_data_and_roi.mat')

%% define sample step size
step_size = 12;

%% define analysis grid based on ROI and step size
[grid_DIC_x grid_DIC_y] = meshgrid(1:step_size:size(ref,2),1:step_size:size(ref,1));
points_in_ROI = inpolygon( grid_DIC_x , grid_DIC_y , j_px , i_px );
points_in_ROI(inpolygon( grid_DIC_x , grid_DIC_y , j_px_exclude , i_px_exclude ))=0;
grid_DIC_x = grid_DIC_x(points_in_ROI);
grid_DIC_y = grid_DIC_y(points_in_ROI);


%% define subset shape, size, and shape function
subset_info.shape = 'square'; % square or circle
subset_info.size = 25;
subset_info.shape_function = 'affine'; % affine or quadratic
subset = create_subset(subset_info);

%% define optimization
options = optimoptions('fminunc','Display','none');

%% initialize values
found_parameters = zeros(subset.order,length(grid_DIC_x),size(def,3));
SSD = zeros(length(grid_DIC_x),size(def,3));
DIC_u = zeros(length(grid_DIC_x),size(def,3));
DIC_v = zeros(length(grid_DIC_x),size(def,3));
Exx = zeros(length(grid_DIC_x),size(def,3));
Eyy = zeros(length(grid_DIC_x),size(def,3));
Exy = zeros(length(grid_DIC_x),size(def,3));
vsg_size = step_size*5;

%% Image processing loop
for image_ind = 1 : size(def,3)
    f = waitbar(0,strcat('Analyzing image-',num2str(image_ind)));
    movegui(f);
    def_interp = griddedInterpolant(image_coords_i,image_coords_j,def(:,:,image_ind),'spline');
    x0 = initial_guess(image_ind,found_parameters);

    for point_ind = 1 : length(grid_DIC_x)
        point_of_interest = [grid_DIC_x(point_ind) grid_DIC_y(point_ind)];
        [alpha_opt,fval,exitflag,output] = fminunc(@(alpha_opt) cost_fun(alpha_opt,subset,point_of_interest,def_interp,ref),x0(:,point_ind),options);
        % assign values based on output of DIC
        found_parameters(:,point_ind,image_ind)=alpha_opt;
        SSD(point_ind,image_ind)=fval;
        waitbar(point_ind/length(grid_DIC_x),f)

    end
    DIC_u(:,image_ind) = found_parameters(4,:,image_ind);
    DIC_v(:,image_ind) = found_parameters(1,:,image_ind);
    % compute strain
    [exx, eyy, exy] = compute_strain(grid_DIC_x,grid_DIC_y,DIC_u(:,image_ind),DIC_v(:,image_ind),vsg_size);
    Exx(:,image_ind) = exx;
    Eyy(:,image_ind) = eyy;
    Exy(:,image_ind) = exy;
    close(f)
    plot_with_image(ref,grid_DIC_x,grid_DIC_y,DIC_u(:,image_ind),DIC_v(:,image_ind),eyy,'E_{yy}',image_ind)    
end