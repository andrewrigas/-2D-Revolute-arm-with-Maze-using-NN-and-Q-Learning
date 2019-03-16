
function [origin,P1,P2] = armConfigurations()
    % Number of arms
    samples = 10;
    
    theta = pi.*rand(samples,2); %Theta Samples from 0 to pi
    
    armLen = [0.5 0.5]; %Arm Lenghts  0.5
    origin = [0 0]; %Origin points
    
    %Generate Arms and store the elbow locations and end points to P1 and P2
    [P1, P2] = GenerateArms(armLen,theta,origin,samples);
    
    PlotArms(P1,P2,origin,samples);
    return
end
    
    
    
   

