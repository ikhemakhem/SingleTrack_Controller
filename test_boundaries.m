function [lim_l, lim_r] = test_boundaries(x, y, t_r, t_l)
% y_diff = abs(y*ones(length(t_r_y),1) - t_r_y);
% i_min_r = find(y_diff - min(y_diff) < 0.1, 4);
% xlim_r = t_r_x(i_min_r);
% y_diff = abs(y*ones(length(t_l_y),1) - t_l_y);
% i_min_l = find(y_diff - min(y_diff) < 0.1, 4);
% xlim_l = t_l_x(i_min_l);

p = [x, y];
min_norm = norm(p-t_r(1));
min_i = 1;
for i = 2:length(t_r)
    if norm(p-t_r(i,:)) < min_norm
        min_norm = norm(p-t_r(i,:));
        min_i = i;
    end
end
lim_r = t_r(min_i,:)';

min_norm = norm(p-t_l(1));
min_i = 1;
for i = 2:length(t_l)
    if norm(p-t_l(i,:)) < min_norm
        min_norm = norm(p-t_l(i,:));
        min_i = i;
    end
end
lim_l = t_l(min_i,:)';

end