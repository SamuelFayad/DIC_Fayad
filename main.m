% created January 20, 2023 by Sam as a test repository to more familiarize myself with GitHub
% all of the code here-in will be created on the spot.
function DIC_output = main(subset_info,ref,def,ROI_coords)
 
%% define image coordinates
[image_coords_j image_coords_i] = meshgrid(1:size(ref,2),1:size(ref,1));

%% define subset shape, size, and shape function
subset_info.shape = 'square'; % square or circle
%subset_info.size = 25;
%subset_info.shape_function = 'affine'; % affine or quadratic
%subset_info.step_size = 12; % affine or quadratic
subset = create_subset(subset_info);

%% define analysis grid based on ROI and step size
[grid_DIC_x grid_DIC_y] = meshgrid(1:subset.step_size:size(ref,2),1:subset.step_size:size(ref,1));
points_in_ROI=zeros(size(grid_DIC_x(:)));
points_ex_ROI=zeros(size(grid_DIC_x(:)));
ROI_coords.px_include.i_px
for ROIs = 1:size(ROI_coords.px_include.i_px,2)
points_in_ROI = max([points_in_ROI,inpolygon( grid_DIC_x(:) , grid_DIC_y(:) , ROI_coords.px_include.j_px , ROI_coords.px_include.i_px )],[],2);

end
disp('exc')
for ROIs = 1:size(ROI_coords.px_exclude.i_px,2)
points_ex_ROI = max([points_ex_ROI,inpolygon( grid_DIC_x(:) , grid_DIC_y(:) , ROI_coords.px_exclude.j_px , ROI_coords.px_exclude.i_px )],[],2);
end
points_in_ROI(logical(points_ex_ROI))=0;
% ROI_coords.px_exclude.i_px
% if  ROI_coords.px_exclude.i_px > 0 % see if there are any points to exclude
% points_in_ROI(inpolygon( grid_DIC_x , grid_DIC_y , ROI_coords.px_exclude.j_px , ROI_coords.px_exclude.i_px ))=0;
% end
disp(size(points_in_ROI))
disp('pts')
% points_in_ROI
grid_DIC_x = grid_DIC_x(logical(points_in_ROI));
grid_DIC_y = grid_DIC_y(logical(points_in_ROI));

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

%% define strain analysis variables
vsg_size = subset.step_size*7;

%% Image processing loop
for image_ind = 1 : size(def,3)
    f = waitbar(0,strcat('Analyzing image-',num2str(image_ind)));
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
    plot_with_image(ref,grid_DIC_x,grid_DIC_y,DIC_u(:,image_ind),DIC_v(:,image_ind),DIC_u(:,image_ind),'u',image_ind)
    mkdir('Figures')
    saveas(gcf,strcat('Figures\Image-',num2str(image_ind),'.png'))
    saveas(gcf,strcat('Figures\Image-',num2str(image_ind),'.fig'))
    
end

% output data
DIC_output.grid_DIC_x = grid_DIC_x;
DIC_output.grid_DIC_y = grid_DIC_y;
DIC_output.DIC_u = DIC_u;
DIC_output.DIC_v = DIC_v;
DIC_output.Exx = Exx;
DIC_output.Eyy = Eyy;
DIC_output.Exy = Exy;
end