function [px_include, px_exclude] = ROI(ref)

figure
imagesc(uint8(ref)), colormap gray, axis equal
title('Draw ROI')
[~,j_px_include,i_px_include] = roipoly(); % this has the option of other ROI types
title('Draw Exclusion')
[~,j_px_exclude,i_px_exclude] = roipoly(); % this has the option of other ROI types

px_include.i_px = i_px_include;
px_include.j_px = j_px_include;
px_exclude.i_px = i_px_exclude;
px_exclude.j_px = j_px_exclude;
end