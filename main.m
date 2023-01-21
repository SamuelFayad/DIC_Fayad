% created January 20, 2023 by Samuel Fayad as a test repository to more familiarize myself with GitHub
% all of the code here-in will be created on the spot.


clc, clear, close all

%% upload images
% [FILENAME_REF, PATHNAME_REF] = uigetfile('*.*');
% ref = double(imread(strcat(PATHNAME_REF,'/',FILENAME_REF)));
% [FILENAME_DEF, PATHNAME_DEF] = uigetfile('*.*','Select deformed images','Multiselect','on');
% for image_ind = 1:length(FILENAME_DEF)
%     def(:,:,image_ind) = double(imread(char(strcat(PATHNAME_DEF,'/',FILENAME_DEF(image_ind)))));
% end

%load('example_data_temp.mat')


%% define ROI
% imshow(uint8(ref))
% title('Draw ROI')
% [~,j_px,i_px] = roipoly() ; % this has the option of other ROI types
% imshow(uint8(ref))
% title('Draw ROI')
% [~,j_px,i_px] = roipoly() ; % this has the option of other ROI types
load('example_data_and_roi.mat')

%% define step size
step_size = 30;

%% define grid based on ROI and step size
[grid_DIC_x grid_DIC_y] = meshgrid(1:step_size:size(ref,2),1:step_size:size(ref,1));
points_in_ROI = inpolygon( grid_DIC_x , grid_DIC_y , j_px , i_px );
grid_DIC_x = grid_DIC_x(points_in_ROI);
grid_DIC_y = grid_DIC_y(points_in_ROI);

%% define image interpolant
[image_coords_j image_coords_i] = meshgrid(1:size(ref,2),1:size(ref,1));

%% define subset shape, size, and shape function
subset_info.shape = 'square'; % square or circle
subset_info.size = 25;
subset_info.shape_function = 'affine'; % affine or quadratic
subset = create_subset(subset_info);

%% define initial guess
% pass
%% define cost function
% see other file

%% define optimization
x0 = zeros(subset.order,1);
options = optimoptions('fminunc','Display','none');
found_parameters = zeros(subset.order,length(grid_DIC_x),size(def,3));
SSD = zeros(length(grid_DIC_x),size(def,3));
v = zeros(size(grid_DIC_x));
%% define post processing
figure
set(gcf,'color','w')
for image_ind = 1 %: size(def,3)
    f = waitbar(0,strcat('Analyzing image-',num2str(image_ind)));
    def_interp = griddedInterpolant(image_coords_i,image_coords_j,def(:,:,image_ind),'spline');
    for point_ind = 1 : length(grid_DIC_x)
        point_of_interest = [grid_DIC_x(point_ind) grid_DIC_y(point_ind)];
        [alpha_opt,fval,exitflag,output] = fminunc(@(alpha_opt) cost_fun(alpha_opt,subset,point_of_interest,def_interp,ref),x0,options);
        found_parameters(:,point_ind,image_ind)=alpha_opt;
        SSD(point_ind,image_ind)=fval;
        v(point_ind) = alpha_opt(1);
        waitbar(point_ind/length(grid_DIC_x),f)

    end
    close(f)
    scatter(grid_DIC_x,grid_DIC_y,3,v)
    xlabel('x-pixel')
    ylabel('y-pixel')
    axis equal
    title(strcat('image-',num2str(image_ind)))
    colorbar
    caxis([-0.5 0.5])
    
end