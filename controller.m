function [U] = controller(X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function [U] = controller(X)
%
% controller for the single-track model
%
% inputs: x (x position), y (y position), v (velocity), beta
% (side slip angle), psi (yaw angle), omega (yaw rate), x_dot (longitudinal
% velocity), y_dot (lateral velocity), psi_dot (yaw rate (redundant)), 
% varphi_dot (wheel rotary frequency)
%
% external inputs (from 'racetrack.mat'): t_r_x (x coordinate of right 
% racetrack boundary), t_r_y (y coordinate of right racetrack boundary),
% t_l_x (x coordinate of left racetrack boundary), t_l_y (y coordinate of
% left racetrack boundary)
%
% outputs: delta (steering angle ), G (gear 1 ... 5), F_b (braking
% force), zeta (braking force distribution), phi (gas pedal position)
%
% files requested: racetrack.mat
%
% This file is for use within the "Project Competition" of the "Concepts of
% Automatic Control" course at the University of Stuttgart, held by F.
% Allgoewer.
%
% prepared by J. M. Montenbruck, Dec. 2013 
% mailto:jan-maximilian.montenbruck@ist.uni-stuttgart.de
%
% written by *STUDENT*, *DATE*
% mailto:*MAILADDRESS*


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIALIZATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% state vector
x=X(1); % x position
y=X(2); % y position
v=X(3); % velocity (strictly positive)
beta=X(4); % side slip angle
psi=X(5); % yaw angle
omega=X(6); % yaw rate
x_dot=X(7); % longitudinal velocity
y_dot=X(8); % lateral velocity
psi_dot=X(9); % yaw rate (redundant)
varphi_dot=X(10); % wheel rotary frequency (strictly positive)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% racetrack
% load('racetrack.mat','t_r'); % load right  boundary from *.mat file
% load('racetrack.mat','t_l'); % load left boundary from *.mat file
% t_r_x=t_r(:,1); % x coordinate of right racetrack boundary
% t_r_y=t_r(:,2); % y coordinate of right racetrack boundary
% t_l_x=t_l(:,1); % x coordinate of left racetrack boundary
% t_l_y=t_l(:,2); % y coordinate of left racetrack boundary

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% STATE FEEDBACK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
G=gearing(v); %gear 1 ... 5
zeta=0.3; %braking force distribution
% Initialisation of racetrack and index variable
% load('trajectory.mat');
trajectory = load_trajectory();
K_lat = 1.5;%1.5;
idx = find_ref(x,y, trajectory);
% 3 step lookahead desired positions
x_des = trajectory(idx+3, 1); %3
y_des = trajectory(idx+3, 2); %3
v_des = trajectory(idx, 3); %0
% Lateral control
% Vector to lookahead position
r = [x_des - x; y_des - y];
% r_x = abs(r(1));
% r_abs = norm(r);
% if (r(1) >= 0 && r(2) >= 0) || (r(1) <= 0 && r(2) <= 0)
%     psi_des = acos(r_x/r_abs);
% else
%     psi_des = pi-acos(r_x/r_abs);
% end
psi_des = atan2(r(2),r(1));
delta = K_lat*angle2Range(psi_des - psi);
if delta > 0.53
    delta = 0.53;
elseif delta <-0.53
    delta = -0.53;
end
% Longitudinal control (Bang-Bang control)
if v <= v_des
    phi = 1;
    Fb = 0;
else
    phi = 0;
    Fb = 15000;
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
U=[delta G Fb zeta phi]; % input vector
end

function G = gearing(v)
    if v < 8.6334
        G = 1;
    elseif v <= 15.8718 && v >= 8.6334
        G = 2;
    elseif v <= 22.98 && v > 15.8718
        G = 3;
    elseif v <= 29.83 && v > 22.98
        G = 4;
    else 
        G = 5;
    end
end

function idx = find_ref(x,y, trajectory)
    p = [x,y];
    min_norm = norm(p-trajectory(1,1:2));
    min_i = 1;
    for i = 2:length(trajectory)
        if norm(p-trajectory(i,1:2)) < min_norm
            min_norm = norm(p-trajectory(i,1:2));
            min_i = i;
        end
    end
    idx = min_i;
end

function x = angle2Range(x)
    while x <= -pi
       x = x+2*pi;
    end
    while x > pi
        x = x-2*pi;
    end
end

function trajectory = load_trajectory()
trajectory = [-2.50000000000000	0	47.3548000000000    ;
-2.47346938775510	4.75510204081633	47.3548000000000;
-2.44693877551020	9.51020408163265	47.3548000000000;
-2.42040816326531	14.2653061224490	47.3548000000000;
-2.39387755102041	19.0204081632653	47.3548000000000;
-2.36734693877551	23.7755102040816	47.3548000000000;
-2.34081632653061	28.5306122448980	47.3548000000000;
-2.31428571428571	33.2857142857143	47.3548000000000;
-2.28775510204082	38.0408163265306	47.3548000000000;
-2.26122448979592	42.7959183673469	47.3548000000000;
-2.23469387755102	47.5510204081633	47.3548000000000;
-2.20816326530612	52.3061224489796	47.3548000000000;
-2.18163265306122	57.0612244897959	47.3548000000000;
-2.15510204081633	61.8163265306122	47.3548000000000;
-2.12857142857143	66.5714285714286	47.3548000000000;
-2.10204081632653	71.3265306122449	47.3548000000000;
-2.07551020408163	76.0816326530612	47.3548000000000;
-2.04897959183674	80.8367346938776	47.3548000000000;
-2.02244897959184	85.5918367346939	47.3548000000000;
-1.99591836734694	90.3469387755102	47.3548000000000;
-1.96938775510204	95.1020408163265	47.3548000000000;
-1.94285714285714	99.8571428571429	47.3548000000000;
-1.91632653061225	104.612244897959	47.3548000000000;
-1.88979591836735	109.367346938776	47.3548000000000;
-1.86326530612245	114.122448979592	47.3548000000000;
-1.83673469387755	118.877551020408	47.3548000000000;
-1.81020408163265	123.632653061224	47.3548000000000;
-1.78367346938776	128.387755102041	47.3548000000000;
-1.75714285714286	133.142857142857	47.3548000000000;
-1.73061224489796	137.897959183673	47.3548000000000;
-1.70408163265306	142.653061224490	47.3548000000000;
-1.67755102040816	147.408163265306	47.3548000000000;
-1.65102040816327	152.163265306122	47.3548000000000;
-1.62448979591837	156.918367346939	47.3548000000000;
-1.59795918367347	161.673469387755	47.3548000000000;
-1.57142857142857	166.428571428571	47.3548000000000;
-1.54489795918367	171.183673469388	47.3548000000000;
-1.51836734693878	175.938775510204	47.3548000000000;
-1.49183673469388	180.693877551020	47.3548000000000;
-1.46530612244898	185.448979591837	47.3548000000000;
-1.43877551020408	190.204081632653	47.3548000000000;
-1.41224489795918	194.959183673469	47.3548000000000;
-1.38571428571429	199.714285714286	47.3548000000000;
-1.35918367346939	204.469387755102	4.73548000000000;
-1.33265306122449	209.224489795918	4.73548000000000;
-1.30612244897959	213.979591836735	4.73548000000000;
-1.27959183673469	218.734693877551	4.73548000000000;
-1.25306122448980	223.489795918367	4.73548000000000;
-1.22653061224490	228.244897959184	4.73548000000000;
-1.20000000000000	233	4.73548000000000                ;
-1.50000000000000	236.319692329993	4.73548000000000;
-2.14285714285714	240.917086152119	4.73548000000000;
-2.78571428571429	244.807951964211	4.73548000000000;
-3.42857142857143	248.172399895874	4.73548000000000;
-4.07142857142857	250.821159581283	4.73548000000000;
-4.71428571428571	252.564960654617	4.73548000000000;
-5.35714285714286	253.390169460641	4.73548000000000;
-6	254.032000000000	4.73548000000000                ;
-6.64285714285714	254.592004008746	4.73548000000000;
-7.28571428571429	255.065399416910	4.73548000000000;
-7.92857142857143	255.447404154519	4.73548000000000;
-8.57142857142857	255.733236151604	4.73548000000000;
-9.21428571428572	255.918113338192	4.73548000000000;
-9.85714285714286	255.997253644315	4.73548000000000;
-10.5000000000000	255.966767723881	4.73548000000000;
-11.1428571428571	255.835777381315	4.73548000000000;
-11.7857142857143	255.622012817654	4.73548000000000;
-12.4285714285714	255.343317577564	4.73548000000000;
-13.0714285714286	255.017535205713	4.73548000000000;
-13.7142857142857	254.662509246769	4.73548000000000;
-14.3571428571429	254.251547845586	4.73548000000000;
-15	253.603488317222	4.73548000000000                ;
-15.6428571428571	252.747346038101	4.73548000000000;
-16.2857142857143	251.741989661386	4.73548000000000;
-16.9285714285714	250.646287840237	4.73548000000000;
-17.5714285714286	249.519109227815	4.73548000000000;
-18.2142857142857	248.419322477281	4.73548000000000;
-18.8571428571429	247.405796241795	4.73548000000000;
-19.5000000000000	246.537399174520	4.73548000000000;
-20.1428571428571	245.865916834912	4.73548000000000;
-20.7857142857143	245.270552117359	4.73548000000000;
-21.4285714285714	244.771614983929	4.73548000000000;
-22.0714285714286	244.479776786141	4.73548000000000;
-22.7142857142857	244.310369194895	4.73548000000000;
-23.3571428571429	244.169691721374	4.73548000000000;
-24	244.066338490389	4.73548000000000                ;
-24.6428571428571	244.008903626751	4.73548000000000;
-25.2857142857143	244.002988018075	4.73548000000000;
-25.9285714285714	244.034694832620	4.73548000000000;
-26.5714285714286	244.108337885032	4.73548000000000;
-27.2142857142857	244.232929431914	4.73548000000000;
-27.8571428571429	244.417481729870	4.73548000000000;
-28.5000000000000	244.671007035501	4.73548000000000;
-29.1428571428571	245.002517605410	4.73548000000000;
-29.7857142857143	245.421025696200	4.73548000000000;
-30.4285714285714	245.935543564474	4.73548000000000;
-31.0714285714286	246.555083466834	4.73548000000000;
-31.7142857142857	247.288657659882	4.73548000000000;
-32.3571428571429	248.145278400222	4.73548000000000;
-33	249.133957944457	4.73548000000000                ;
-33	250	47.3548000000000                                ;
-33.0204081632653	253.061224489796	47.3548000000000;
-33.0408163265306	256.122448979592	47.3548000000000;
-33.0612244897959	259.183673469388	47.3548000000000;
-33.0816326530612	262.244897959184	47.3548000000000;
-33.1020408163265	265.306122448980	47.3548000000000;
-33.1224489795918	268.367346938776	47.3548000000000;
-33.1428571428571	271.428571428571	47.3548000000000;
-33.1632653061225	274.489795918367	47.3548000000000;
-33.1836734693878	277.551020408163	47.3548000000000;
-33.2040816326531	280.612244897959	47.3548000000000;
-33.2244897959184	283.673469387755	47.3548000000000;
-33.2448979591837	286.734693877551	47.3548000000000;
-33.2653061224490	289.795918367347	47.3548000000000;
-33.2857142857143	292.857142857143	47.3548000000000;
-33.3061224489796	295.918367346939	47.3548000000000;
-33.3265306122449	298.979591836735	47.3548000000000;
-33.3469387755102	302.040816326531	47.3548000000000;
-33.3673469387755	305.102040816327	47.3548000000000;
-33.3877551020408	308.163265306122	47.3548000000000;
-33.4081632653061	311.224489795918	47.3548000000000;
-33.4285714285714	314.285714285714	47.3548000000000;
-33.4489795918367	317.346938775510	47.3548000000000;
-33.4693877551020	320.408163265306	47.3548000000000;
-33.4897959183674	323.469387755102	47.3548000000000;
-33.5102040816327	326.530612244898	47.3548000000000;
-33.5306122448980	329.591836734694	47.3548000000000;
-33.5510204081633	332.653061224490	47.3548000000000;
-33.5714285714286	335.714285714286	47.3548000000000;
-33.5918367346939	338.775510204082	47.3548000000000;
-33.6122448979592	341.836734693878	47.3548000000000;
-33.6326530612245	344.897959183674	47.3548000000000;
-33.6530612244898	347.959183673469	47.3548000000000;
-33.6734693877551	351.020408163265	47.3548000000000;
-33.6938775510204	354.081632653061	47.3548000000000;
-33.7142857142857	357.142857142857	47.3548000000000;
-33.7346938775510	360.204081632653	47.3548000000000;
-33.7551020408163	363.265306122449	47.3548000000000;
-33.7755102040816	366.326530612245	47.3548000000000;
-33.7959183673469	369.387755102041	47.3548000000000;
-33.8163265306122	372.448979591837	47.3548000000000;
-33.8367346938776	375.510204081633	47.3548000000000;
-33.8571428571429	378.571428571429	47.3548000000000;
-33.8775510204082	381.632653061224	9.47096000000000;
-33.8979591836735	384.693877551020	9.47096000000000;
-33.9183673469388	387.755102040816	9.47096000000000;
-33.9387755102041	390.816326530612	9.47096000000000;
-33.9591836734694	393.877551020408	9.47096000000000;
-33.9795918367347	396.938775510204	9.47096000000000;
-34	400	9.47096000000000                                ;
-34	400	9.47096000000000                                ;
-32.8367346938776	405.507271582629	9.47096000000000;
-31.6734693877551	408.674733383233	9.47096000000000;
-30.5102040816327	411.169827202047	9.47096000000000;
-29.3469387755102	413.148604639668	9.47096000000000;
-28.1836734693878	414.767117296692	9.47096000000000;
-27.0204081632653	416.190555904326	9.47096000000000;
-25.8571428571429	417.497796692469	9.47096000000000;
-24.6938775510204	418.680593582372	9.47096000000000;
-23.5306122448980	419.729692331342	9.47096000000000;
-22.3673469387755	420.635838696684	9.47096000000000;
-21.2040816326531	421.389778435707	9.47096000000000;
-20.0408163265306	421.982257305716	9.47096000000000;
-18.8775510204082	422.478998982589	9.47096000000000;
-17.7142857142857	422.959953164584	9.47096000000000;
-16.5510204081633	423.420969318872	9.47096000000000;
-15.3877551020408	423.857798795373	9.47096000000000;
-14.2244897959184	424.266192944008	9.47096000000000;
-13.0612244897959	424.641903114696	9.47096000000000;
-11.8979591836735	424.980680657359	9.47096000000000;
-10.7346938775510	425.278276921915	9.47096000000000;
-9.57142857142857	425.530443258286	9.47096000000000;
-8.40816326530612	425.732931016391	9.47096000000000;
-7.24489795918368	425.881491546151	9.47096000000000;
-6.08163265306122	425.971876197487	9.47096000000000;
-4.91836734693878	425.999836809741	9.47096000000000;
-3.75510204081633	425.962859044431	9.47096000000000;
-2.59183673469388	425.864053052383	9.47096000000000;
-1.42857142857143	425.707667483675	9.47096000000000;
-0.265306122448976	425.497950988388	9.47096000000000;
0.897959183673471	425.239152216601	9.47096000000000;
2.06122448979592	424.935519818393	9.47096000000000;
3.22448979591837	424.591302443845	9.47096000000000;
4.38775510204081	424.210748743037	9.47096000000000;
5.55102040816327	423.798107366048	9.47096000000000;
6.71428571428572	423.357626962959	9.47096000000000;
7.87755102040816	422.893556183848	9.47096000000000;
9.04081632653061	422.410143678795	9.47096000000000;
10.2040816326531	421.909769125648	9.47096000000000;
11.3673469387755	421.315655233679	9.47096000000000;
12.5306122448980	420.580235053043	9.47096000000000;
13.6938775510204	419.695881510127	9.47096000000000;
14.8571428571429	418.654967531317	9.47096000000000;
16.0204081632653	417.449866043000	9.47096000000000;
17.1836734693878	416.072949971561	9.47096000000000;
18.3469387755102	414.489206509517	9.47096000000000;
19.5102040816327	412.266185000028	9.47096000000000;
20.6734693877551	409.283615066178	9.47096000000000;
21.8367346938776	405.576327658296	9.47096000000000;
23	400	9.47096000000000                                ;
22.7000000000000	402.500000000000	9.47096000000000;
23	400	47.3548000000000                                ;
22.9411764705882	397.500000000000	47.3548000000000;
22.8823529411765	395	47.3548000000000                ;
22.8235294117647	392.500000000000	47.3548000000000;
22.7647058823529	390	47.3548000000000                ;
22.7058823529412	387.500000000000	47.3548000000000;
22.6470588235294	385	47.3548000000000                ;
22.5882352941177	382.500000000000	47.3548000000000;
22.5294117647059	380	47.3548000000000                ;
22.4705882352941	377.500000000000	47.3548000000000;
22.4117647058824	375	47.3548000000000                ;
22.3529411764706	372.500000000000	47.3548000000000;
22.2941176470588	370	47.3548000000000                ;
22.2352941176471	367.500000000000	47.3548000000000;
22.1764705882353	365	47.3548000000000                ;
22.1176470588235	362.500000000000	47.3548000000000;
22.0588235294118	360	47.3548000000000                ;
22	357.500000000000	47.3548000000000                ;
21.9411764705882	355	47.3548000000000                ;
21.8823529411765	352.500000000000	47.3548000000000;
21.8235294117647	350	47.3548000000000                ;
21.7647058823529	347.500000000000	47.3548000000000;
21.7058823529412	345	47.3548000000000                ;
21.6470588235294	342.500000000000	47.3548000000000;
21.5882352941177	340	47.3548000000000                ;
21.5294117647059	337.500000000000	47.3548000000000;
21.4705882352941	335	47.3548000000000                ;
21.4117647058824	332.500000000000	47.3548000000000;
21.3529411764706	330	47.3548000000000                ;
21.2941176470588	327.500000000000	47.3548000000000;
21.2352941176471	325	9.47096000000000                ;
21.1764705882353	322.500000000000	9.47096000000000;
21.1176470588235	320	9.47096000000000                ;
21.0588235294118	317.500000000000	9.47096000000000;
21	315	9.47096000000000                                ;
21	315	4.73548000000000                                ;
21.6842105263158	312.171424615164	4.73548000000000;
22.3684210526316	309.624881615163	4.73548000000000;
23.0526315789474	307.335103089272	4.73548000000000;
23.7368421052632	305.276821126761	4.73548000000000;
24.4210526315790	303.424767816903	4.73548000000000;
25.1052631578947	301.753675248972	4.73548000000000;
25.7894736842105	300.238275512238	4.73548000000000;
26.4736842105263	298.853300695974	4.73548000000000;
27.1578947368421	297.573482889453	4.73548000000000;
27.8421052631579	296.373554181947	4.73548000000000;
28.5263157894737	295.228246662728	4.73548000000000;
29.2105263157895	294.112292421068	4.73548000000000;
29.8947368421053	293.000423546241	4.73548000000000;
30.5789473684211	291.867372127518	4.73548000000000;
31.2631578947368	290.687870254172	4.73548000000000;
31.9473684210526	289.436650015475	4.73548000000000;
32.6315789473684	288.088443500699	4.73548000000000;
33.3157894736842	286.617982799116	4.73548000000000;
34	285	4.73548000000000                                ;
34	285	47.3548000000000                                ;
33.8333333333333	281.111111111111	47.3548000000000;
33.6666666666667	277.222222222222	47.3548000000000;
33.5000000000000	273.333333333333	47.3548000000000;
33.3333333333333	269.444444444444	47.3548000000000;
33.1666666666667	265.555555555556	47.3548000000000;
33	261.666666666667	47.3548000000000                ;
32.8333333333333	257.777777777778	47.3548000000000;
32.6666666666667	253.888888888889	47.3548000000000;
32.5000000000000	250	47.3548000000000                ;
32.5000000000000	250	47.3548000000000                ;
32.5000000000000	245.454545454545	47.3548000000000;
32.5000000000000	240.909090909091	47.3548000000000;
32.5000000000000	236.363636363636	47.3548000000000;
32.5000000000000	231.818181818182	47.3548000000000;
32.5000000000000	227.272727272727	47.3548000000000;
32.5000000000000	222.727272727273	47.3548000000000;
32.5000000000000	218.181818181818	47.3548000000000;
32.5000000000000	213.636363636364	47.3548000000000;
32.5000000000000	209.090909090909	47.3548000000000;
32.5000000000000	204.545454545455	47.3548000000000;
32.5000000000000	200	47.3548000000000                ;
32.5000000000000	195.454545454545	47.3548000000000;
32.5000000000000	190.909090909091	47.3548000000000;
32.5000000000000	186.363636363636	47.3548000000000;
32.5000000000000	181.818181818182	47.3548000000000;
32.5000000000000	177.272727272727	47.3548000000000;
32.5000000000000	172.727272727273	47.3548000000000;
32.5000000000000	168.181818181818	47.3548000000000;
32.5000000000000	163.636363636364	47.3548000000000;
32.5000000000000	159.090909090909	47.3548000000000;
32.5000000000000	154.545454545455	47.3548000000000;
32.5000000000000	150	47.3548000000000                ;
32.5000000000000	145.454545454545	47.3548000000000;
32.5000000000000	140.909090909091	47.3548000000000;
32.5000000000000	136.363636363636	47.3548000000000;
32.5000000000000	131.818181818182	47.3548000000000;
32.5000000000000	127.272727272727	47.3548000000000;
32.5000000000000	122.727272727273	47.3548000000000;
32.5000000000000	118.181818181818	47.3548000000000;
32.5000000000000	113.636363636364	47.3548000000000;
32.5000000000000	109.090909090909	47.3548000000000;
32.5000000000000	104.545454545455	47.3548000000000;
32.5000000000000	100	47.3548000000000                ;
32.5000000000000	95.4545454545455	47.3548000000000;
32.5000000000000	90.9090909090909	47.3548000000000;
32.5000000000000	86.3636363636364	47.3548000000000;
32.5000000000000	81.8181818181818	4.73548000000000;
32.5000000000000	77.2727272727273	4.73548000000000;
32.5000000000000	72.7272727272727	4.73548000000000;
32.5000000000000	68.1818181818182	4.73548000000000;
32.5000000000000	63.6363636363636	4.73548000000000;
32.5000000000000	59.0909090909091	4.73548000000000;
32.5000000000000	54.5454545454545	4.73548000000000;
32.5000000000000	50	4.73548000000000                ;
33	46	4.73548000000000                                ;
33.8275862068966	44.0362335882739	4.73548000000000;
34.6551724137931	41.7040042384863	4.73548000000000;
35.4827586206897	40.2130544354742	4.73548000000000;
36.3103448275862	38.8654272314199	4.73548000000000;
37.1379310344828	37.6551253772344	4.73548000000000;
37.9655172413793	36.5761516238287	4.73548000000000;
38.7931034482759	35.6225087221139	4.73548000000000;
39.6206896551724	34.7881994230010	4.73548000000000;
40.4482758620690	34.0672264774010	4.73548000000000;
41.2758620689655	33.4535926362249	4.73548000000000;
42.1034482758621	32.9411624568754	4.73548000000000;
42.9310344827586	32.5115086432288	4.73548000000000;
43.7586206896552	32.1450344472279	4.73548000000000;
44.5862068965517	31.8279158778454	4.73548000000000;
45.4137931034483	31.5463289440539	4.73548000000000;
46.2413793103448	31.2864496548262	4.73548000000000;
47.0689655172414	31.0344540191348	4.73548000000000;
47.8965517241379	30.7765180459525	4.73548000000000;
48.7241379310345	30.4988177442519	4.73548000000000;
49.5517241379310	30.1875291230057	4.73548000000000;
50.3793103448276	29.8401628130212	4.73548000000000;
51.2068965517241	29.5108006203881	4.73548000000000;
52.0344827586207	29.1669919361452	4.73548000000000;
52.8620689655172	28.7586835237065	4.73548000000000;
53.6896551724138	28.2358221464859	4.73548000000000;
54.5172413793104	27.4797392010743	4.73548000000000;
55.3448275862069	26.2465121314937	4.73548000000000;
56.1724137931034	24.6036741717578	4.73548000000000;
57	22.6468750000000	4.73548000000000                ;
57.3000000000000	20	9.47096000000000                ;
57	16.5000000000000	9.47096000000000                ;
56.3000000000000	13.7000000000000	9.47096000000000;
55.7241379310345	11.0705119443532	9.47096000000000;
54.4482758620690	7.54620558360242	9.47096000000000;
53.1724137931034	4.64488507916163	9.47096000000000;
51.8965517241379	2.00336564844012	9.47096000000000;
50.6206896551724	-0.174991150856413	9.47096000000000;
49.3448275862069	-1.76826648195696	9.47096000000000;
48.0689655172414	-3.21978108455219	9.47096000000000;
46.7931034482759	-4.61021484821339	9.47096000000000;
45.5172413793104	-5.93698109751510	9.47096000000000;
44.2413793103448	-7.19749315703191	9.47096000000000;
42.9655172413793	-8.38916435133836	9.47096000000000;
41.6896551724138	-9.50940800500903	9.47096000000000;
40.4137931034483	-10.5556374426185	9.47096000000000;
39.1379310344828	-11.5252659887412	9.47096000000000;
37.8620689655172	-12.4157069679519	9.47096000000000;
36.5862068965517	-13.2243737048251	9.47096000000000;
35.3103448275862	-13.9486795239352	9.47096000000000;
34.0344827586207	-14.5860377498570	9.47096000000000;
32.7586206896552	-15.1338617071649	9.47096000000000;
31.4827586206897	-15.5895647204335	9.47096000000000;
30.2068965517241	-15.9505601142373	9.47096000000000;
28.9310344827586	-16.2462164549875	9.47096000000000;
27.6551724137931	-16.5285781125182	9.47096000000000;
26.3793103448276	-16.7904884162023	9.47096000000000;
25.1034482758621	-17.0235682338420	9.47096000000000;
23.8275862068966	-17.2194384332394	9.47096000000000;
22.5517241379310	-17.3697198821968	9.47096000000000;
21.2758620689655	-17.4660334485162	9.47096000000000;
20	-17.5000000000000	9.47096000000000                ;
19	-17.5000000000000	9.47096000000000                ;
17.8684210526316	-17.2489531677763	9.47096000000000;
16.7368421052632	-17.1427610237543	9.47096000000000;
15.6052631578947	-17.0925194938759	9.47096000000000;
14.4736842105263	-17.0371672779925	9.47096000000000;
13.3421052631579	-16.9131905644373	9.47096000000000;
12.2105263157895	-16.6634903890433	9.47096000000000;
11.0789473684211	-16.3350661253545	9.47096000000000;
9.94736842105263	-15.9839483359215	9.47096000000000;
8.81578947368421	-15.6347459278070	9.47096000000000;
7.68421052631579	-15.2526193878925	9.47096000000000;
6.55263157894737	-14.8007676966969	9.47096000000000;
5.42105263157895	-14.2423898347389	9.47096000000000;
4.28947368421053	-13.4822028037517	9.47096000000000;
3.15789473684210	-12.3393292886507	9.47096000000000;
2.02631578947369	-10.9191485073674	9.47096000000000;
0.894736842105264	-9.34954469271077	9.47096000000000;
-0.236842105263158	-7.50410075328750	9.47096000000000;
-1.36842105263158	-5.32178458508283	9.47096000000000;
-2.50000000000000	-2.91784998618021	9.47096000000000;
-2.50000000000000	0	47.3548000000000                ;
-2.47346938775510	4.75510204081633	47.3548000000000;
-2.44693877551020	9.51020408163265	47.3548000000000;
-2.42040816326531	14.2653061224490	47.3548000000000;
-2.39387755102041	19.0204081632653	47.3548000000000;
-2.36734693877551	23.7755102040816	47.3548000000000;
-2.34081632653061	28.5306122448980	47.3548000000000;
-2.31428571428571	33.2857142857143	47.3548000000000;
-2.28775510204082	38.0408163265306	47.3548000000000;
-2.26122448979592	42.7959183673469	47.3548000000000;
-2.23469387755102	47.5510204081633	47.3548000000000;
-2.20816326530612	52.3061224489796	47.3548000000000;
-2.18163265306122	57.0612244897959	47.3548000000000;
-2.15510204081633	61.8163265306122	47.3548000000000;
-2.12857142857143	66.5714285714286	47.3548000000000;
-2.10204081632653	71.3265306122449	47.3548000000000;
-2.07551020408163	76.0816326530612	47.3548000000000;
-2.04897959183674	80.8367346938776	47.3548000000000;
-2.02244897959184	85.5918367346939	47.3548000000000;
-1.99591836734694	90.3469387755102	47.3548000000000;
-1.96938775510204	95.1020408163265	47.3548000000000;
-1.94285714285714	99.8571428571429	47.3548000000000;
-1.91632653061225	104.612244897959	47.3548000000000;
-1.88979591836735	109.367346938776	47.3548000000000;
-1.86326530612245	114.122448979592	47.3548000000000;
-1.83673469387755	118.877551020408	47.3548000000000;
-1.81020408163265	123.632653061224	47.3548000000000;
-1.78367346938776	128.387755102041	47.3548000000000;
-1.75714285714286	133.142857142857	47.3548000000000;
-1.73061224489796	137.897959183673	47.3548000000000;
-1.70408163265306	142.653061224490	47.3548000000000;
-1.67755102040816	147.408163265306	47.3548000000000;
-1.65102040816327	152.163265306122	47.3548000000000;
-1.62448979591837	156.918367346939	47.3548000000000;
-1.59795918367347	161.673469387755	47.3548000000000;
-1.57142857142857	166.428571428571	47.3548000000000;
-1.54489795918367	171.183673469388	47.3548000000000;
-1.51836734693878	175.938775510204	47.3548000000000;
-1.49183673469388	180.693877551020	47.3548000000000;
-1.46530612244898	185.448979591837	47.3548000000000;
-1.43877551020408	190.204081632653	47.3548000000000;
-1.41224489795918	194.959183673469	47.3548000000000;
-1.38571428571429	199.714285714286	47.3548000000000;
-1.35918367346939	204.469387755102	4.73548000000000;
-1.33265306122449	209.224489795918	4.73548000000000;
-1.30612244897959	213.979591836735	4.73548000000000;
-1.27959183673469	218.734693877551	4.73548000000000;
-1.25306122448980	223.489795918367	4.73548000000000;
-1.22653061224490	228.244897959184	4.73548000000000;
-1.20000000000000	233	4.73548000000000                ];
end