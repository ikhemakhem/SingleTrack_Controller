v_max = 47.3548;
%% straight line 1
x_line1 = linspace(-2.5, -1.2, 50)';
y_line1 = linspace(0, 233, 50)';
line1 = [x_line1, y_line1];
v_line1 = [v_max*ones(length(line1)-7,1); 0.1*v_max*ones(7,1)];

%% s_curve
s = [-34.6, 280;-33.5, 250; -32, 248.5; -30, 247; -27, 245; -25, 244; -22, 244.5; -20, 246; -17.5, 250; -14, 254.5; -10, 256; -8, 255; -5, 253; -4, 250; -2, 240; -1 230; -0.7, 220; -0.5, 210];
%s = [-34.6, 280;-33.5, 250; -32, 248.5; -30, 247; -27, 245; -25, 244; -22, 245; -20, 246; -10, 256; -8, 255; -5, 253; -4, 250; -2, 240; -1 230; -0.7, 220; -0.5, 210];
x_s = s(:,1);
y_s = s(:,2);

[xData, yData] = prepareCurveData( x_s, y_s );

% Set up fittype and options.
ft = 'pchipinterp';
excludedPoints = excludedata( xData, yData, 'Indices', [3 4 5 9 12 14] );
opts = fitoptions( 'Method', 'PchipInterpolant' );
opts.Exclude = excludedPoints;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );


x_s = linspace(-1.5, -33, 50)';
y_s = feval(fitresult, x_s);
s_curve = [x_s, y_s];
v_s_curve = 0.1*v_max*ones(length(s_curve),1);  %0.1;
%% straight line 2
x_line2 = linspace(-33, -34, 50)';
y_line2 = linspace(250, 400, 50)';
line2 = [x_line2, y_line2]; % -34, 402.5
v_line2 = [v_max*ones(length(line2)-7,1); 0.2*v_max*ones(7,1)];  %0.2
%% Circle curve
c = [-34, 400; -33, 405; -28, 415; -20, 422; -5, 426; 10, 422; 18, 415;  22, 405; 23, 400];
x_c = c(:,1);
y_c = c(:,2);
[xData, yData] = prepareCurveData( x_c, y_c );

% Set up fittype and options.
ft = 'pchipinterp';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

x_c = linspace(-34, 23, 50)';
y_c = feval(fitresult, x_c);
c_curve = [x_c, y_c; 22.7, 402.5];
v_c = 0.2*v_max*ones(length(c_curve),1);  %0.2
%% straight line 3
x_line3 = linspace(23, 21, 35)';
y_line3 = linspace(400, 315, 35)';
line3 = [x_line3, y_line3];
v_line3 = [v_max*ones(length(line3)-5,1); 0.2*v_max*ones(5,1)];
%% chicane
ch = [21, 315; 25, 302; 30.5, 292;  34, 285];
x_ch = ch(:,1);
y_ch = ch(:,2);
[xData, yData] = prepareCurveData( x_ch, y_ch );

% Set up fittype and options.
ft = 'splineinterp';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

x_ch = linspace(21, 34, 20)';
y_ch = feval(fitresult, x_ch);
c_chicane = [x_ch, y_ch];
v_chicane = 0.1*v_max*ones(length(c_chicane),1);
%% straight line 4
x_line4_1 = linspace(34, 32.5, 10)';
x_line4_2 = linspace(32.5, 32.5, 45)';
y_line4_1 = linspace(285, 250, 10)';
y_line4_2 = linspace(250, 50, 45)';
line4 = [x_line4_1, y_line4_1; x_line4_2, y_line4_2];
v_line4 = [v_max*ones(length(line4)-8,1); 0.1*v_max*ones(8,1)];
%% 2nd chicane
ch_2 = [ 32.5 50; 33 46; 33.5 45; 34.5 42;  36 38; 42 33; 50 30; 54 28; 58 20];
x_ch_2 = ch_2(:,1);
y_ch_2 = ch_2(:,2);

[xData, yData] = prepareCurveData( x_ch_2, y_ch_2 );
% Set up fittype and options.
ft = 'pchipinterp';
excludedPoints = excludedata( xData, yData, 'Indices', 5 );
opts = fitoptions( 'Method', 'PchipInterpolant' );
opts.Normalize = 'on';
opts.Exclude = excludedPoints;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

x_ch_2 = linspace(33, 57, 30)';
y_ch_2 = feval(fitresult, x_ch_2);
c_chicane_2 = [x_ch_2, y_ch_2];
v_chicane_2 = 0.1*v_max*ones(length(c_chicane_2),1);
%% 2nd circle curve
c_2 = [57 16.5; 56 12; 54 6.5; 50 -1; 40 -11; 30 -16; 20 -17.5];
x_c_2 = c_2(:,1);
y_c_2 = c_2(:,2);
[xData, yData] = prepareCurveData( x_c_2, y_c_2 );

% Set up fittype and options.
ft = 'pchipinterp';
excludedPoints = excludedata( xData, yData, 'Indices', 5 );
opts = fitoptions( 'Method', 'PchipInterpolant' );
opts.Normalize = 'on';
opts.Exclude = excludedPoints;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

x_c_2 = linspace(57, 20, 30)';
y_c_2 = feval(fitresult, x_c_2);
c_curve_2 = [57.3 20; x_c_2(1,:), y_c_2(1,:); 56.3 13.7; x_c_2(2:end,:), y_c_2(2:end,:) ];
v_c_2 = 0.2*v_max*ones(length(c_curve_2),1);
%% last chicane
c_3 = [19 -17.5; 17.5 -17.2; 14 -17; 10 -16; 5 -14; 1 -9.5; -2 -4];
x_c_3 = c_3(:,1);
y_c_3 = c_3(:,2);

[xData, yData] = prepareCurveData( x_c_3, y_c_3 );

% Set up fittype and options.
ft = 'pchipinterp';
excludedPoints = excludedata( xData, yData, 'Indices', [1 5] );
opts = fitoptions( 'Method', 'PchipInterpolant' );
opts.Normalize = 'on';
%opts.Exclude = excludedPoints;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
x_c_3 = linspace(19, -2.5, 20)';
y_c_3 = feval(fitresult, x_c_3);
c_curve_3 = [x_c_3, y_c_3];
v_c_3 = 0.2*v_max*ones(length(c_curve_3),1);
%%
traj = [line1; s_curve; line2; c_curve; line3; c_chicane; line4; c_chicane_2; c_curve_2; c_curve_3; line1];
velocity = [v_line1; v_s_curve; v_line2; v_c; v_line3; v_chicane; v_line4; v_chicane_2; v_c_2; v_c_3; v_line1];
trajectory = [traj, velocity];
save('trajectory.mat','trajectory');
%%
load('racetrack.mat','t_r'); % load right  boundary from *.mat file
load('racetrack.mat','t_l'); % load left boundary from *.mat file
figure('Name','racetrack','NumberTitle','off','Toolbar','figure','MenuBar','none','OuterPosition',[0 -500 460 1100]) % creates window for plot
hold on % allow for multiple plot commands within one figure
axis equal % eqal axis scaling
axis([-50 70 -50 450]) % plot height and width
plot(t_r(:,1),t_r(:,2)) % plot right racetrack boundary
plot(t_l(:,1),t_l(:,2)) % plot left racetrack boundary

hold all;
scatter(line1(:,1), line1(:,2), [], v_line1,'.');
scatter(s_curve(:,1), s_curve(:,2), [], v_s_curve,'.' );
scatter(line2(:,1), line2(:,2), [], v_line2,'.');
scatter(c_curve(:,1), c_curve(:,2), [], v_c,'.');
scatter(line3(:,1), line3(:,2), [], v_line3,'.');
scatter(c_chicane(:,1), c_chicane(:,2), [], v_chicane,'.');
scatter(line4(:,1), line4(:,2), [], v_line4,'.');
scatter(c_chicane_2(:,1), c_chicane_2(:,2), [], v_chicane_2,'.');
scatter(c_curve_2(:,1), c_curve_2(:,2), [], v_c_2,'.');
scatter(c_curve_3(:,1), c_curve_3(:,2), [], v_c_3,'.');
scatter(line1(:,1), line1(:,2), [], v_line1,'.');
colormap('cool'); 
colorbar;
%plot(s_curve);
%plot(line2);
%plot(c_curve);
grid on;
% 
