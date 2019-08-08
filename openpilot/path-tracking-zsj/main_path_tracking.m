% �����������Բ�ͬ��·�������㷨
% PP         : Pure Pursuit
% CIRCLE_PP  : Draw Circle then PP
% LQR_model3 : Linear Quadratic Regulator with model3

clc
clear
close all

%% 1. ѡ��·�������㷨
%path_tracking_alg = 'PP';
%path_tracking_alg = 'LQR_model3';
%path_tracking_alg = 'MPC_apollo';
%path_tracking_alg = 'LQR_apollo';
path_tracking_alg = 'MPC_autopilot';

%% 2. ���ó�����ʼ״̬
veh_pose = [0, 2, 0];       %������ʼλ��
steer_state = 0;            %��ǰʱ��ǰ��ƫ�ǧ�
veh_params.velocity = 6;     %����, m/s
veh_params.v_des = veh_params.velocity;       %��������, m/s
veh_params.angular_v=0;       %��ǰ�������ٶ�
roadmap_name = 'big_circle';  %ѡ��·��: small_circle, big_circle,wave_test

%% 3. �������
i = 0;                  %����ʱ��index
time_step = 0.1;        %���沽��, m

simulation_time = 0;    %��ǰ����ʱ��, s
run_distance = 0;       %������ʻ���, m

realCmd=[];              %store commend of steer
delayCmd=[];            %store the delayed commaand of steer
delayCmd_grad=0;    %calculate the gradient
delayCmd_gradstore=[];    %store the gradient of the actual command
steer_cmd_new=0;     %save the new command

%% 3.1 delay and wave simulation parameter
delayTest=false;            %whether start test
self_fix=false;             %whether fix angle
delayStep=2;              %set delay time
discT=2;                    %dicrete delta T
steer_over=1.0;             %overshoot
wheel_angle=0.00;               %steering wheel unaccurate angle
detValue=true;                %set the determinate value for peek finding
wheelAngleTurn_right=0.07;     %set the extra angle when vehile turn dirction
wheelAngleTurn_left=0.07;   
disPeak=2;
turnDelayvalue=4;                   %set the extra delay value when vhile turn 
count=0;                                   %det the count delay when tturn
steer_cmd_save=0;                   %save the steer cmd for turn delay

judgeStep=2;                            %step to erase the effect of delay
%% 4.��������
% 4.1. ����ת����Ʋ���
veh_params.wheel_base = 2.5;    %���, m
veh_params.max_steer_angle = 53 / 180 * pi; %ǰ�����ת��, rad /apollo 53, old 30
veh_params.max_angular_vel = 53 / 180 * pi; %ǰ�������ٶ�, rad/s
veh_params.max_acceleration = 11; %���������ٶ�
veh_params.max_deceleration = 12; %���������ٶ�


% 4.2. ���Ĵ�С�����Ȳ���
veh_params.vehicle_size = 20;
veh_params.vehicle_length = veh_params.velocity * time_step * 0.8;

%% 5. ��������·�������Ȳ���
[trajref_params, simulation_stop_y, simulation_stop_time] =...
    set_trajref_params(roadmap_name, veh_params);   %����trajref����
trajref = generate_trajref(trajref_params,roadmap_name);         %����trajref

%% 6. ��ͬ·�������㷨�Ĳ�������
% 6.1. PP����
pp_params = load_pp_params();

% 6.2. LQR_model3�Ĳ���
lqr_model3_params = load_lqr_model3_params(trajref_params, veh_params);

% 6.3. MPC �Ĳ���
mpc_params = load_mpc_params(veh_params);

% 6.4. Apollo LQR �Ĳ���
lqr_apollo_params = load_lqr_apollo_params(trajref_params,veh_params);

% 6.5. autopilot �Ĳ���
autop_params = load_autopilot_params(veh_params);

%% 7. ����·��������λ�˿��ӻ�
[path_figure, steer_figure] = draw_path_tracking(...
    path_tracking_alg, roadmap_name, trajref, veh_pose, steer_state,...
    veh_params, simulation_time, simulation_stop_time);

%% 8. ��ʼ��log����
log = log_init(time_step, simulation_stop_time);

%pause;  %��ͣ����ʾ·����������ʼλ��

%% 9. ����ָ����·�������㷨ʹ����������·����ʻ
disp([path_tracking_alg,' simulation start!']);
while((simulation_time < simulation_stop_time) &&...
        (veh_pose(2) < simulation_stop_y))
    
    tic;    %����һ�����ڵ�ʱ��
    
    % 9.1. ���·���ʱ��
    i = i + 1;  %����iֵ�����Լ�¼���log
    simulation_time = simulation_time + time_step;
    run_distance = run_distance + veh_params.velocity * time_step;
    log.time(i) = simulation_time;  %��¼����ʱ��
    log.dist(i) = run_distance;     %��¼����������ʻ���
    
   % fprintf('time: %.1fs, ', log.time(i));
    %fprintf('dist: %.1fm, ', log.dist(i));
    
    % 9.2. ��������ǰ��ƫ��
    switch (path_tracking_alg)
        % ѡ��ָ����·�������㷨
        case 'PP'
            steer_cmd = ALG_PP(veh_pose, trajref,...
                pp_params, veh_params, steer_state, time_step);
            
        case 'LQR_model3'
            steer_cmd = ALG_LQR_model3(veh_pose, trajref,...
                lqr_model3_params, veh_params, steer_state, time_step);
            
        case 'MPC_apollo'
            [steer_cmd,acc] = ALG_MPC(veh_pose, trajref,...
                mpc_params, veh_params, steer_state, time_step);
        
        case 'LQR_apollo'
            steer_cmd = ALG_LQR_Apollo(veh_pose, trajref,...
                lqr_apollo_params, veh_params, steer_state, time_step);
            
        case 'MPC_autopilot'
            steer_cmd = ALG_Autopilot(veh_pose, trajref,...
                autop_params, veh_params, steer_state, time_step,log.steer_cmd(i));
        
        otherwise
            disp('There is no this lateral control algorithm!');
            break;
    end
    
    % 9.2.1 ������ʱӰ��
    if(delayTest)% �Ƿ�����ӳ�   
        % start to simulate the wave and delay situation
        % save the steering command
         realCmd=[realCmd, steer_cmd];
        if (i-delayStep-1<=0 || i-discT-1<=0)
            steer_cmd_new=0;
        else
            %dicrete the system 
            if (mod(i,discT)==0)  
                 steer_cmd_new=realCmd(i-delayStep)*steer_over+wheel_angle; 
                 %find the local maximum
                  if (detValue && delayCmd(i-1-disPeak)-delayCmd(i-1)<-0.017)
                      steer_cmd_new=steer_cmd_new+wheelAngleTurn_right;
                      detValue=false;
                      count =0;
                      steer_cmd_save=steer_cmd_new;
                      %find the local minimum
                  elseif(~detValue && delayCmd(i-1-disPeak)-delayCmd(i-1)>0.017)
                      steer_cmd_new=steer_cmd_new-wheelAngleTurn_left;
                      detValue=true;
                      count=0;
                      steer_cmd_save=steer_cmd_new;
                  end
                 %delayCmd_grad=(delayCmd(i-1)-delayCmd(i-1-discT))/(time_step*discT);
            end
        end
        %set the delay when vehicle turn
        if (count<turnDelayvalue)
            steer_cmd_new=steer_cmd_save;
            count=count+1;
        end
        %save the delayed cmd 
        delayCmd=[delayCmd, steer_cmd_new];
        % auto steering control when delay and dift happen
        if (i-judgeStep>0 && self_fix)
            steer_cmd_new=self_aligning_control...
                (steer_cmd_new,delayCmd(i-judgeStep:i));
        end
    else % ����ģ��
        steer_cmd_new=steer_cmd;
    end
    
    % 9.3. ����ǰ��ƫ�Ǽ�����λ��
    steer_state = steer_cmd_new;
    switch (path_tracking_alg)
         case 'MPC_apollo'
             veh_pose = update_veh_pose_mpc(veh_pose, steer_state, acc,...
                 veh_params, mpc_params, time_step);
        otherwise
             veh_pose = update_veh_pose(veh_pose, steer_state, veh_params,...
        time_step);
    end
    
    % ���㳵����ǰλ��������·���ϵ�ͶӰ��λ��
    [~, index] = calc_nearest_point(veh_pose, trajref);
    ref_pose = calc_proj_pose(veh_pose(1:2), trajref(index, 1:3),...
    trajref(index + 1, 1:3));
    log.ref_pose(i, :) = ref_pose;
    
    
    log.steer_cmd(i) = steer_cmd_new / pi * 180;    %��¼����ת�Ǭ角
    log.veh_pose(i, :) = veh_pose;            	%��¼����λ��
    log.veh_speed(i, :) = veh_params.velocity;  %��¼�����ٶ�
    
    % 9.3.1 ���³�����ǰ���ٶ�
    veh_params.angular_v=update_angular_velocity(log,time_step,i);
   % fprintf('steer: %.2 deg, ', log.steer_cmd(i));

    
    % 9.4. ����λ�˼�ǰ��ƫ�ǿ��ӻ�
    set(groot, 'CurrentFigure', path_figure);   %��Ϊ��ǰfigure
    draw_veh_pose(veh_pose, veh_params);    	%���³���λ��
    set(groot, 'CurrentFigure', steer_figure);
    plot(log.time(i), log.steer_cmd(i), 'b.', 'markersize', 20);
    
    % 9.5. ����һ�����ڵ�����ʱ��
    cycle_time = toc;   % ����һ�����ڵ�����ʱ��
    log.cycle_time(i,:)=cycle_time;
  %  fprintf('cycle time: %.2fs\n', cycle_time);
    pause(0.01);        %������ʾ
end

disp('simulation end!');

% draw the delay step plot 
if (delayTest) 
    figure(4)
    plot(delayCmd/pi*180)
    hold on
    plot(realCmd/pi*180)
    hold off
    legend('delayCmd','realCmd')
    title('PP speed 9m/s, wave test ')
    save('sp9mpcdelay','delayCmd','realCmd')
end

%% plot figures
realx=log.veh_pose(:,1);
realy=log.veh_pose(:,2);
realtheta=log.veh_pose(:,3);
realtime=log.time;
realcmd=log.steer_cmd;
real_ref=log.ref_pose;
real_t=log.cycle_time;
%save('sp9ppdelay','realx','realy','realtheta','realtime', 'realcmd','real_ref','real_t')






