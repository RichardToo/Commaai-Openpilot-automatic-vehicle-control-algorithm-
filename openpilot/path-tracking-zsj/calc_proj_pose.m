          function proj_pose = calc_proj_pose(p0, p1, p2)
% ���p0�ڵ�p1�͵�p2���ֱ���ϵ�ͶӰ�����꼰����

% ���:
% proj_point : ͶӰ��λ��[x, y, theta]

% ����:
% p0    : point0��λ��[x0, y0, theta0]
% p1    : point0��λ��[x1, y1, theta1]
% p2    : point0��λ��[x2, y2, theta2]

tol = 0.0001;
proj_pose = [0, 0, 0];

if abs(p2(1) - p1(1)) < tol
    % p1��p2ֱ�ߵ�б�������
    x = p1(1);     %ͶӰ��x����Ϊp1��x����
    y = p0(2);     %ͶӰ��y����Ϊp0��y����

elseif abs(p2(2) - p1(2)) < tol
    % p1��p2ֱ�ߵ�б�������
    x = p0(1);     %ͶӰ��x����Ϊp1��x����
    y = p1(2);     %ͶӰ��y����Ϊp0��y����
    
else
    k1 = (p2(2) - p1(2)) / (p2(1) - p1(1)); %p1��p2��ֱ��б��
    k2 = -1 / k1;   %p0��ͶӰ���ֱ��б��? two perpendicular line mutiply is -1
    
    x = (p0(2) - p1(2) + k1 * p1(1) - k2 * p0(1)) / (k1 - k2);
    y = p0(2) + k2 * (x - p0(1));
end

proj_pose(1) = x;
proj_pose(2) = y;

dist = norm(p2(1:2) - p1(1:2));         %��p1����p2�ľ���
dist2 = norm(p2(1:2) - proj_pose(1:2)); %ͶӰ�㵽��p2�ľ���

ratio = dist2 / dist;
theta = ratio * p1(3) + (1 - ratio) * p2(3);

proj_pose(3) = theta;


