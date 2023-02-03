function plot_with_image(ref,grid_DIC_x,grid_DIC_y,DIC_u,DIC_v,qoi,qoi_str,image_ind)

close all
if exist('current_figure','var')
    close(current_figure)
end

figure_font_size = 12;
%custom_caxis_limits = [0 0.2];% the limits for your colorbar so they are consistent for the movie
figure_width = 6;
current_figure = figure;
set(gcf,'color','w','units','inch','position',[13 0 figure_width size(ref,1)/size(ref,2)*figure_width])
ax1 = axes;
axis off
ax2 = axes;
axis off
imagesc(ax1,1:size(ref,2),1:size(ref,1),ref)
set(ax1,'YDir','normal','xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
scatter(ax2,grid_DIC_x+DIC_u,grid_DIC_y+DIC_v,6,qoi,'filled','MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2)
title(strcat('Image-',num2str(image_ind)))
xlabel('X-pixel')
ylabel('Y-pixel')
h = colorbar;

h.Label.String = qoi_str;
h.Label.FontSize = figure_font_size;
%caxis(custom_caxis_limits)
set(ax2, 'color', 'none');
% you might have to toy around with the axis position
set([ax1,ax2],'units','normalized','Position',[.17 .15 .67 .75],'fontsize',figure_font_size);
axes(ax1); axis equal
axes(ax2); axis equal
xlim(ax2,[0 size(ref,2)])
ylim(ax2,[0 size(ref,1)])
xlim(ax1,[0 size(ref,2)])
ylim(ax1,[0 size(ref,1)])

colormap(ax1,'gray')
colormap(ax2,'parula')


end