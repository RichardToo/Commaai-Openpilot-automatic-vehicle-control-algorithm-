function radius = limit_radius(radius, max_radius)
% ���ư뾶ֵ�����������ֵ

% 输出:
% radius     : �뾶��С, m

% 输入:
% radius     : �뾶��С, m
% max_radius : ���뾶, m

radius = min(radius, max_radius);
radius = max(radius, -max_radius);