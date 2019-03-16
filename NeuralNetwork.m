function [W1,W2] = NeuralNetwork() 

    %Training Date
    [input,target] = endPointLocations;
    
    % Hidden Units in HiddenLayer
    hiddenUnits = 3;
    
    [W1, W2, error] = trainNeuralNetwork(input.',target.',hiddenUnits);
    
    %PlotError(error,length(error));
    origin = [0 0];
    armLen = [0.5 0.5];
 
    theta = runNeural(W1,W2,input');
    
    [P1,P2] = GenerateArms(armLen,theta',origin,length(theta));
    
    PlotEndPoints(origin,P2);
   
end