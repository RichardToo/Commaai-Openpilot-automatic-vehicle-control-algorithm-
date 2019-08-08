function [path_figure, steer_figure] = draw_path_tracking(...
    path_tracking_alg, roadmap_name, trajref, veh_pose, steer_state,...
    veh_params, simulation_time, simulation_stop_time)
% ·������Ч�����ӻ�����������Ч��������ǰ��ƫ��?

% ���:
% path_figure           : ·������Ч����figure
% steer_figure          : ����ǰ��ƫ�ǵ�figure

% ����:
% path_tracking_alg     : ·�������㷨
% roadmap_name          : ·������
% trajref               : ����·��
% veh_pose              : ������ǰλ��
% steer_state           : ǰ��ƫ�ǵ�ǰ״̬?
% veh_params            : ��������
% simulation_time       :��ǰ����ʱ��
% simulation_stop_time  : ����ֹͣʱ��

% 1. ��������·����������ʼλ��״̬?
screen_size = get(groot, 'Screensize'); %��ȡ������ʾ���Ŀ�Ⱥ͸߶�
screen_width = screen_size(3);          %��Ļ���
screen_height = screen_size(4);         %��Ļ�߶�

path_figure = figure('name', 'Path Tracking', 'position',...
    [1, screen_height/2, screen_width/2, screen_height/2]);
hold on;
grid minor;
axis equal;
path_figure_title_name = set_title_name(path_tracking_alg);
title(path_figure_title_name, 'fontsize', 15);  %����title����
path_figure_ylimit = set_y_limits(roadmap_name);
ylim(path_figure_ylimit);               %y�᷶Χ
xlabel('X(m)', 'fontsize', 15);         %x������
ylabel('Y(m)', 'fontsize', 15);         %y������

plot(trajref(:, 1), trajref(:, 2), 'r.', 'markersize', 20); %�����켣���ӻ�
draw_traj_curvature(trajref);   %�����켣ÿ������ʿ��ӻ�
draw_veh_pose(veh_pose, veh_params);    %������ʼλ�˿��ӻ�
%legend({'trajref', 'vehicle pose'}, 'fontsize', 12);        %ͼ��

% 2. ����ǰ��ƫ�ǧ�
steer_figure = figure('name', 'Path Tracking', 'position',...
    [screen_width/2, screen_height/2, screen_width/2, screen_height/2]);
hold on;
grid minor;
steer_figure_title_name = set_title_name(path_tracking_alg);
title(steer_figure_title_name, 'fontsize', 15);
steer_figure_xlimit = simulation_stop_time;
steer_figure_ylimit = veh_params.max_steer_angle / pi * 180;
axis([0, steer_figure_xlimit, -steer_figure_ylimit, steer_figure_ylimit]);
xlabel('time(s)','fontsize', 15);
ylabel('steer command(deg)', 'fontsize', 15);

plot(simulation_time, steer_state, 'b.', 'markersize', 20);
%legend({'steer command'}, 'fontsize', 12);


