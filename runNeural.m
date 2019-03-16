 function theta = runNeural(W1,W2,data)
    %adds bias to matrix
    dataB = addBiasToMatrix(data);
    %Using the get Prediction function that actually run Neural Network
    [theta,a] = getPrediction(dataB,W1,W2);
    return
end