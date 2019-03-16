function [P1,P2] = RevoluteForwardKinematics2D(armLen, theta, origin)
    % calculate relative forward kinematics
    %Store first length
    l1 = armLen(1);
    %Store second length
    l2 = armLen(2);
    %Store first angle
    theta1 = theta(1);
    %Store second angle
    theta2 = theta(2);
    
    %Store in P1 vector the end point possitions X and Y 
    P1(1) = l1 * cos(theta1) + origin(1);
    P1(2) = l1 * sin(theta1) + origin(2);
    %Store in P2 vector the end point possitions X and Y 
    P2(1) = l2 * cos(theta1 + theta2) + P1(1);
    P2(2) = l2 * sin(theta1 + theta2) + P1(2);
end
 


