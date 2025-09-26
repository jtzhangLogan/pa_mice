function cleanupMotor(motor)
    motor.StopPolling();
    motor.DisableDevice();
    motor.Disconnect();
end
