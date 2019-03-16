function [P1,P2] = MazeArmEndPoint(path,origin,armLen)
    %Store how many samples
    samples = length(path');
    %Getting the trained W1,W2
    [w1,w2] = NeuralNetwork();
    %Run neural network and provide us with the prediction theta values
    theta = runNeural(w1,w2,path');
    %Finally generetateArms with those thetas
    [P1,P2] = GenerateArms(armLen,theta',origin,length(theta));
end