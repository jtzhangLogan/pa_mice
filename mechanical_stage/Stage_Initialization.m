%% Load dll
disp("-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+")
disp('--> Importing DLL ...')
devManagerCLI = NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.DeviceManagerCLI.dll');
genMotorCLI = NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.GenericMotorCLI.dll');
benchTopCLI = NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.Benchtop.DCServoCLI.dll');
kCubeCLI = NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.KCube.DCServoCLI.dll');
tCubeCLI = NET.addAssembly('C:\Program Files\Thorlabs\Kinesis\Thorlabs.MotionControl.TCube.DCServoCLI.dll');
import Thorlabs.MotionControl.DeviceManagerCLI.*
import Thorlabs.MotionControl.GenericMotorCLI.*
import Thorlabs.MotionControl.Benchtop.DCServoCLI.*
import Thorlabs.MotionControl.KCube.DCServoCLI.*
import Thorlabs.MotionControl.TCube.DCServoCLI.*
DeviceManagerCLI.BuildDeviceList();
DeviceManagerCLI.GetDeviceListSize();
DeviceManagerCLI.GetDeviceList();
disp('--> DLL import success!')


%% Initialize stages
disp("-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+")
% Connect to xy stage
try
    xy_serial = config.stage.SN.xy;
    xy_stage = BenchtopDCServo.CreateBenchtopDCServo(xy_serial);
    xy_stage.Connect(xy_serial);
    disp("--> XY stage connected")
catch
    disp("--> Fail to connect to XY stage")
end

% Enable X motor
try
    motor_x = xy_stage.GetChannel(1);
    motor_x.WaitForSettingsInitialized(10000);
    motor_x.StartPolling(250);
    motor_x.EnableDevice();
    pause(1);
    disp("--> X motor enabled")
catch
    disp("--> Fail to enable X motor")
end

% Enable Y motor
try
    motor_y = xy_stage.GetChannel(2);
    motor_y.WaitForSettingsInitialized(10000);
    motor_y.StartPolling(250);
    motor_y.EnableDevice();
    pause(1)
    disp("--> Y motor enabled")
catch
    disp("--> Fail to enable Y motor")
end

% Load X/Y motor configuration
try 
    motor_x.LoadMotorConfiguration(motor_x.DeviceID);
    motor_y.LoadMotorConfiguration(motor_y.DeviceID);
    disp("--> X/Y motor configuration loaded")
catch
    disp("--> Fail to load X/Y motor configuration")
end

disp("--> XY stage ready!")
disp("-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+")

% % Connect to z stage
% try
%     z_serial = config.stage.SN.z;
%     z_stage = KCubeDCServo.CreateKCubeDCServo(z_serial);
%     z_stage.Connect(z_serial);
%     disp("--> Z stage connected")
% catch
%     disp("--> Fail to connect to Z stage")
% end

% % Enable Z motor
% try
%     z_stage.WaitForSettingsInitialized(5000);
%     z_stage.StartPolling(250);
%     z_stage.EnableDevice();
%     pause(1)
%     disp("--> Z motor enabled")
% catch
%     disp("--> Fail to enable Z motor")
% end

% % Load Z motor configuration
% try
%     motor_z_config = z_stage.LoadMotorConfiguration(z_serial);
%     motor_z_config.DeviceSettingsName = 'MTS50/M-Z8';
%     motor_z_config.UpdateCurrentConfiguration();
%     disp("--> Z motor configuration loaded")
% catch
%     disp("--> Fail to load Z motor configuration")
% end

% % Set motor device settings
% try
%     motor_z_device_settings = z_stage.MotorDeviceSettings;
%     z_stage.SetSettings(motor_z_device_settings, true, false);
%     disp("--> Z motor device settings updated")
% catch
%     disp("--> Fail to update Z motor device settings")
% end

% % Reference to motor_z
% motor_z = z_stage;

% disp("--> Z stage ready!")
% disp("-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+")


%% Home stage
disp("-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+")
% XY
home_xy = input('--> Do you want to home the XY stage? (y/n): ', 's');
if strcmpi(home_xy, 'y')
    % X
    disp('Homing X stage ...');
    motor_x.Home(timeout);
    pause(1);
    disp("X stage homed");
    % Y
    disp('Homing Y stage ...');
    motor_y.Home(timeout);
    pause(1);
    disp("Y stage homed");
else
    disp("Skip homing XY stage");
end

% % Z
% home_z = input('Do you want to home the Z stage? (y/n): ', 's');
% if strcmpi(home_z, 'y')
%     disp('Homing Z stage ...');
%     z_stage.Home(timeout);
%     pause(1);
%     disp("Z stage homed");
% else
%     disp("Skip homing Z stage");
% end