function [Exx, Eyy, Exy] = compute_strain(grid_DIC_x,grid_DIC_y,DIC_u,DIC_v,vsg_size)
% calculates the Green-Lagrange strain tensor in 2D
Exx = zeros(size(grid_DIC_x));
Eyy = zeros(size(grid_DIC_x));
Exy = zeros(size(grid_DIC_x));
for node_index=1:length(grid_DIC_x)
    eligible_points=find(sqrt((grid_DIC_x-grid_DIC_x(node_index)).^2+(grid_DIC_y-grid_DIC_y(node_index)).^2)<vsg_size/2);
        displacement_vector=[DIC_u(eligible_points) DIC_v(eligible_points)];
    displacement_vector=displacement_vector(:);
    %affine fit for strain
    shapefun=[ones(length(eligible_points),1) grid_DIC_x(eligible_points) grid_DIC_y(eligible_points) zeros(size(grid_DIC_x(eligible_points))) zeros(size(grid_DIC_x(eligible_points))) zeros(size(grid_DIC_x(eligible_points)));
        zeros(size(grid_DIC_x(eligible_points))) zeros(size(grid_DIC_x(eligible_points))) zeros(size(grid_DIC_x(eligible_points))) ones(length(eligible_points),1) grid_DIC_x(eligible_points) grid_DIC_y(eligible_points)];
%     alpha=(shapefun'*shapefun)\shapefun'*displacement_vector;
    alpha=shapefun\displacement_vector;
    % use coeffeicients to make green-lagrange strain tensor
    Exx(node_index)=alpha(2)+1/2*(alpha(2)^2+alpha(5)^2);
    Eyy(node_index)=alpha(6)+1/2*(alpha(3)^2+alpha(6)^2);
    Exy(node_index)=1/2*(alpha(3)+alpha(5))+1/2*(alpha(2)*alpha(3)+alpha(5)*alpha(6));
    
    
end

end