function moveMotor(motorName, motor, goal, tol, timeout)
    % Move a motor to a specified position with error checking and retries
    %
    % Inputs:
    %   motorName - String: Name of the motor for display purposes
    %   motor     - Object: Motor control object (must have EnableDevice, MoveTo, Position methods)
    %   goal      - Double: Target position in meters 
    %   tol       - Double: Position tolerance in meters (optional, default: 1e-7)
    %   timeout   - Double: Movement timeout in seconds (optional, default: 60)
    %
    % Notes:
    %   - Goal position is converted from meters to millimeters internally
    %   - Function attempts to reach goal up to 5 times before giving up
    %   - Displays status messages during movement

    % Handle optional parameters
    if nargin < 4 || isempty(tol)
        tol = 1e-7;  % Default tolerance in meters
    end
    
    if nargin < 5 || isempty(timeout)
        timeout = 60000;  % Default timeout in miliseconds
    end
    
    % Input validation
    if ~ischar(motorName) && ~isstring(motorName)
        error('motorName must be a string or char array');
    end
    
    if ~isnumeric(goal) || ~isscalar(goal)
        error('goal must be a numeric scalar');
    end
    
    if ~isnumeric(tol) || ~isscalar(tol) || tol <= 0
        error('tol must be a positive numeric scalar');
    end
    
    if ~isnumeric(timeout) || ~isscalar(timeout) || timeout <= 0
        error('timeout must be a positive numeric scalar');
    end
    
    % Convert goal from meters to millimeters
    goalMM = goal * 1e3;
    tolMM = tol * 1e3;
    
    % Move motor with retry logic
    maxAttempts = 5;
    attempt = 0;
    success = false;
    
    while attempt < maxAttempts && ~success
        attempt = attempt + 1;
        
        fprintf('--> Moving %s (Attempt %d/%d)...\n', motorName, attempt, maxAttempts);
        
        motor.EnableDevice();
        pause(1);
        motor.MoveTo(goalMM, timeout); 
        pause(1);
        
        % Check if goal is reached
        currentPositionMM = System.Decimal.ToDouble(motor.Position);
        if abs(currentPositionMM - goalMM) <= tolMM
            success = true;
            fprintf('--> Successfully moved %s to %.3f mm\n', motorName, currentPositionMM);
        else
            fprintf('--> Attempt %d failed. Position: %.3f mm, Target: %.3f mm\n', ...
                attempt, currentPositionMM, goalMM);
        end
    end
    
    if ~success
        warning('Failed to move %s to target position after %d attempts', motorName, maxAttempts);
    end
end