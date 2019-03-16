
function [P1 P2] = GenerateArms(armLen ,theta, origin, samples)
    % Declare empty Sets
    P1 = []; 
    P2 =[];
    %Loop and get elbow and end points
    for i = 1:samples
       %Get P1 AND P2 values by sending thetas
       [p1,p2] = RevoluteForwardKinematics2D(armLen, theta(i,:), origin);
       %Store them
       P1 = [P1 ;p1];
       P2 = [P2 ;p2];
    end
end