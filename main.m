clc;
clear;
close all;


scriptDir = fileparts(mfilename('fullpath'));
%% Add mechanical stage utility files to path
addpath(fullfile(scriptDir, '..', 'mechanical_stage'));
%% Add Utilities
addpath(fullfile(scriptDir, '..', 'utils'));


%% Load config
fname = './config.json';
config = loadjson(fname);
data_dir = fullfile(config.parent_dir, config.data_dir);
if ~isfolder(data_dir)
    mkdir(data_dir);
end


%% Setup stages
% Initialize stages
timeout = config.stage.timeout;
Stage_Initialization;

%% Move to initial position
disp("-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+")
init_position_config = config.stage.init_position;
x_init = init_position_config.x.value*getUnit(init_position_config.x.unit);
y_init = init_position_config.y.value*getUnit(init_position_config.y.unit);
moveMotor('x', motor_x, x_init);
moveMotor('y', motor_y, y_init);
disp("--> Reached initial position")
disp("-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+")


%% Move to custom position
%% Generate trajectories
curX = 1 / 1e3;
curY = 1 / 1e3;
moveMotor('x', motor_x, curX);
moveMotor('y', motor_y, curY);
pause(1)
disp("--> Reached position")


%% Disconnect
cleanupMotor(motor_x);
