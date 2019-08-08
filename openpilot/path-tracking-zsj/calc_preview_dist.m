function preview_dist = calc_preview_dist(params, velocity)
% ����Ԥ�����
% ���:
% preview_dist  : Ԥ�����, m

% ����:
% params        : Ԥ��������
% velcity       : ����, m/s

preview_dist = params.k * velocity;

preview_dist = max(preview_dist, params.min_preview_dist);
preview_dist = min(preview_dist, params.max_preview_dist);


