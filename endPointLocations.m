
function [P2, theta] = endPointLocations()
    %Number of samples
    samples = 1000;
    
    %Theta Samples from 0 to pi
    theta = pi.*rand(samples,2);
    
    %Arm Lenghts  0.5
    armLen = [0.5 0.5];
    
    %Origin points
    origin = [0 0];
    
    %Generate Arms points locations
    [P1, P2] = GenerateArms(armLen,theta,origin,samples);
    return
    
end


