 function a = sigmoidHidden(net) 
    % Activation for hidden Layers and adding a bias neuron
    a = sigmoid(net); 
    a = addBiasToMatrix(a);
    return
end