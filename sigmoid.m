  function a = sigmoid(net) 
         %Activation function for outpur Layer
         % Net can be a matrix, vector or scalar
         a = 1.0 ./ ( 1.0 + exp(-net)); 
end