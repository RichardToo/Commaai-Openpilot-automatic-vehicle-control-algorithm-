function [nearest_point, index] = calc_nearest_point(veh_pose, trajref)
% ������ǰλ��������·���ϵ������
% ���:
% nearest_point: ���������[x, y]
% index        : ������index

% ����:
% veh_pose     : ������ǰλ��[x, y, theta]
% trajref      : ����·��[X, Y, Theta, Radius]

n = length(trajref);
dist = zeros(n, 1);

for i = 1:n
    dist(i, :) = norm(trajref(i, 1:2) - veh_pose(1:2));
end

[~, index] = min(dist); 

index = index(1);
nearest_point = trajref(index, 1:2);

