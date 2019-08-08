function preview_point = preview_point_on_trajref(veh_pose,...
    preview_dist, trajref, index)
% ����������·���ϵ�Ԥ���

% ���:
% preview_point : Ԥ�������[x, y]

% ����:
% veh_pose      : ������ǰλ��[x, y, theta]
% preview_dist  : Ԥ�����, m
% trajref       : ����·��
% index         : ������·���Ͽ�ʼ������index

n = length(trajref);

for i = index : 1 : n
    % ���μ���trajref��ÿ�㵽������ǰλ�õľ���?
    tmp_dist = norm(trajref(i, 1:2) - veh_pose(1:2));
    
    if tmp_dist > preview_dist
        preview_index = i;
        break;
    end
end

preview_point = trajref(preview_index, 1:2);


