function plot_with_image(ref,grid_DIC_x,grid_DIC_y,DIC_u,DIC_v,qoi,qoi_str,image_ind)
%close all

figure_font_size = 12;
%custom_caxis_limits = [0 0.2];% the limits for your colorbar so they are consistent for the movie

figure
set(gcf,'color','w','units','inch','position',[13 0 6.85 size(ref,1)/size(ref,2)*6.85])
ax1 = axes;
axis off
ax2 = axes;
axis off
imagesc(ax1,1:size(ref,2),1:size(ref,1),ref)
set(ax1,'YDir','normal','xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
xlim([0 size(ref,2)])
ylim([0 size(ref,1)])
scatter(ax2,grid_DIC_x+DIC_u,grid_DIC_y+DIC_v,6,qoi,'filled','MarkerFaceAlpha',.8,'MarkerEdgeAlpha',.8)
title(strcat('Image-',num2str(image_ind)))
xlabel('X-pixel')
ylabel('Y-pixel')
h = colorbar;

h.Label.String = qoi_str;
h.Label.FontSize = figure_font_size;
%caxis(custom_caxis_limits)
xlim([0 size(ref,2)])
ylim([0 size(ref,1)])
set(ax2, 'color', 'none');
% you might have to toy around with the axis position
set([ax1,ax2],'Position',[.17 .15 .67 .75],'fontsize',figure_font_size);
axes(ax1); axis equal
axes(ax2); axis equal
colormap(ax1,'gray')
colormap(ax2,'parula')


end